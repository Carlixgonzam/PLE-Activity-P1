module Loop

// util::Webserver's serve() callback does not correctly resolve
// variables inside the running handler in this Rascal build, confirmed
// by direct testing, see Server.rsc for the history if you want it.
// Rather than fight that, this module never registers a callback at
// all. It runs as a plain, long lived process started once, and drives
// its own loop from inside main(), which is the one execution path we
// verified works correctly for everything: local variables, calling
// other functions, comprehensions, all of it.
//
// A small bridge process, bridge.py, talks HTTP to the browser and
// talks to this process through two files: it writes a request as
// JSON, this loop notices the change, computes the next game state
// using the normal Engine.rsc functions, and writes the response as
// JSON. bridge.py polls for that response and forwards it back over
// HTTP.

import Engine;
import lang::json::IO;
import IO;
import String;

loc levelFile = |project://snakegame/src/main/rascal/levels/level1.snake|;
loc reqFile = |project://snakegame/run/request.json|;
loc respFile = |project://snakegame/run/response.json|;

void writeResponse(str id, GameState st) {
    map[str, value] body = (
        "id": id,
        "width": st.width,
        "height": st.height,
        "snake": [ [p.x, p.y] | Pos p <- st.snake ],
        "food": [st.food.x, st.food.y],
        "walls": [ [p.x, p.y] | Pos p <- st.wallCells ],
        "score": st.score,
        "gameOver": st.gameOver,
        "direction": st.direction,
        "speed": st.speedMs
    );
    writeJSON(respFile, body);
}

void main(list[str] args) {
    if (!exists(reqFile.parent)) {
        mkDirectory(reqFile.parent);
    }

    GameState currentState = initialState(levelFile);
    writeResponse("boot", currentState);

    println("Rascal Snake engine is running.");
    println("Watching <reqFile> for requests from bridge.py.");
    println("Press Ctrl+C to stop.");

    str lastSeen = "";

    while (true) {
        if (exists(reqFile)) {
            str raw = readFile(reqFile);
            if (raw != lastSeen && trim(raw) != "") {
                lastSeen = raw;
                try {
                    map[str, str] req = parseJSON(#map[str, str], raw);
                    str id = req["id"] ? "0";
                    str action = req["action"] ? "state";

                    if (action == "move") {
                        currentState = turn(currentState, req["dir"] ? "");
                    } else if (action == "tick") {
                        currentState = step(currentState);
                    } else if (action == "reset") {
                        currentState = initialState(levelFile);
                    }

                    writeResponse(id, currentState);
                } catch value e: {
                    println("request error: <e>");
                }
            }
        }
    }
}
