#!/usr/bin/env python3
"""Local HTTP bridge for the Rascal Snake engine.

This is here because util::Webserver, Rascal's own HTTP library, does
not correctly hold onto mutable state inside its request callback in
the Rascal build this project was built against. That is a library
limitation, not a design choice, and it is documented at the top of
Loop.rsc alongside the tests that proved it.

Instead, Loop.rsc runs as a long lived process and does all the actual
game logic. This script only relays HTTP requests from the browser to
that process, through two small JSON files, and relays the answer back.
It has no game logic of its own.

Run Loop.rsc first, in its own terminal, then run this script, then
open http://localhost:8000 in a browser.
"""

import http.server
import itertools
import json
import pathlib
import socketserver
import threading
import time
import urllib.parse

ROOT = pathlib.Path(__file__).resolve().parent
WEB_DIR = ROOT / "web"
RUN_DIR = ROOT / "run"
REQUEST_FILE = RUN_DIR / "request.json"
RESPONSE_FILE = RUN_DIR / "response.json"

BRIDGE_PORT = 8000
POLL_TIMEOUT_SECONDS = 8.0
POLL_INTERVAL_SECONDS = 0.02

_lock = threading.Lock()
_counter = itertools.count(1)


def ask_engine(action: str, extra: dict | None = None) -> dict:
    """Write one request, wait for the matching response, return it."""
    RUN_DIR.mkdir(exist_ok=True)
    with _lock:
        req_id = str(next(_counter))
        payload = {"id": req_id, "action": action}
        if extra:
            payload.update(extra)
        REQUEST_FILE.write_text(json.dumps(payload))

        deadline = time.monotonic() + POLL_TIMEOUT_SECONDS
        while time.monotonic() < deadline:
            if RESPONSE_FILE.exists():
                try:
                    data = json.loads(RESPONSE_FILE.read_text())
                except (json.JSONDecodeError, OSError):
                    data = None
                if data is not None and data.get("id") == req_id:
                    return data
            time.sleep(POLL_INTERVAL_SECONDS)

        raise TimeoutError(
            "Loop.rsc did not answer in time. Is it running in its own terminal?"
        )


class Handler(http.server.BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        pass

    def _send_json(self, data: dict, status: int = 200):
        body = json.dumps(data).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def _send_file(self, path: pathlib.Path, content_type: str):
        body = path.read_bytes()
        self.send_response(200)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        parsed = urllib.parse.urlparse(self.path)
        path = parsed.path
        params = dict(urllib.parse.parse_qsl(parsed.query))

        try:
            if path == "/" or path == "/index.html":
                self._send_file(WEB_DIR / "index.html", "text/html")
            elif path == "/state":
                self._send_json(ask_engine("state"))
            elif path == "/move":
                self._send_json(ask_engine("move", {"dir": params.get("dir", "")}))
            elif path == "/tick":
                self._send_json(ask_engine("tick"))
            elif path == "/reset":
                self._send_json(ask_engine("reset"))
            else:
                self.send_error(404, "not found")
        except TimeoutError as e:
            self._send_json({"error": str(e)}, status=504)
        except Exception as e:  # last resort, keep the bridge alive
            self._send_json({"error": repr(e)}, status=500)


def main():
    with socketserver.ThreadingTCPServer(("127.0.0.1", BRIDGE_PORT), Handler) as httpd:
        print(f"Bridge listening on http://localhost:{BRIDGE_PORT}")
        print("Make sure Loop.rsc is already running in another terminal.")
        httpd.serve_forever()


if __name__ == "__main__":
    main()
