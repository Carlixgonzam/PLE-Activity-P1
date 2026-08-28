module Server

// Kept for reference only. This module is not used by the running
// game, see Loop.rsc and bridge.py instead.
//
// This was the first design: Rascal serving HTTP directly through
// util::Webserver. It does not work in this Rascal build. serve()'s
// Response(Request) callback fails to resolve any local variable whose
// initializer reads a module level variable, and fails to resolve the
// parameters of any separately defined Rascal function called from
// inside the callback, including this module's own helper functions
// and Engine.rsc's functions. The error is always "Undeclared
// variable", naming whatever binding the callback tried to use.
//
// That was confirmed by direct testing: a handler returning a literal
// string worked, a handler reading a pre-existing, never reassigned
// module variable worked, and a handler declaring
// "GameState st = currentState;" and then using "st" one line later
// failed, even with no function call anywhere in sight. Fully inlining
// every handler, so nothing but data constructors, local variables,
// and Java-implemented built-ins remained, still failed the same way.
//
// Given that, this file is left as is rather than fixed further. If a
// newer Rascal build turns out not to have this problem, this is a
// reasonable starting point to revive the direct-HTTP-server design.

import Engine;
import util::Webserver;
import util::Math;
import Content;
import IO;

loc levelFile = |project://snakegame/src/main/rascal/levels/level1.snake|;
loc indexFile = |project://snakegame/web/index.html|;

GameState currentState = initialState(levelFile);

map[str,str] noHeaders = ();

Response handle(get("/")) {
    return fileResponse(indexFile, "text/html", noHeaders);
}

Response handle(get("/state")) {
    GameState st = currentState;
    map[str, value] result = (
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
    return jsonResponse(ok(), noHeaders, result);
}

default Response handle(Request req) {
    return response(notFound(), "text/plain", noHeaders, "not found");
}

loc serverLoc = |http://localhost:9797|;

void main(list[str] args) {
    serve(serverLoc, handle);
    println("Snake server running at <serverLoc>");
    int keepAlive = 0;
    while (true) {
        keepAlive = arbInt(1);
    }
}

void stopServer() {
    shutdown(serverLoc);
}
