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
import List;

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
    println("Level: <currentState.width> x <currentState.height>, snake starts at <currentState.snake[0]>, <size(currentState.wallCells)> wall cells, tick speed <currentState.speedMs> ms.");
    println("Watching <reqFile> for requests from bridge.py.");
    println("Press Ctrl+C to stop.");
    println("");

    str lastSeen = "";
    int n = 0;

    while (true) {
        if (exists(reqFile)) {
            str raw = readFile(reqFile);
            if (raw != lastSeen && trim(raw) != "") {
                lastSeen = raw;
                n = n + 1;
                try {
                    map[str, str] req = parseJSON(#map[str, str], raw);
                    str id = req["id"] ? "0";
                    str action = req["action"] ? "state";

                    str dirNote = "";
                    if (action == "move") {
                        dirNote = " dir=<req["dir"] ? "none">";
                    }
                    println("[<n>] request id=<id> action=<action><dirNote>");

                    if (action == "move") {
                        str dir = req["dir"] ? "";
                        bool validDir = dir == "up" || dir == "down" || dir == "left" || dir == "right";
                        bool opposite
                            = (currentState.direction == "up" && dir == "down")
                            || (currentState.direction == "down" && dir == "up")
                            || (currentState.direction == "left" && dir == "right")
                            || (currentState.direction == "right" && dir == "left")
                            ;
                        currentState = turn(currentState, dir);
                        if (!validDir) {
                            println("[<n>]   ignored: \"<dir>\" is not a direction");
                        } else if (opposite) {
                            println("[<n>]   ignored: cannot reverse straight into <currentState.direction>");
                        } else {
                            println("[<n>]   queued: next tick will head <dir>, current heading is still <currentState.direction> until then");
                        }
                    } else if (action == "tick") {
                        if (currentState.gameOver) {
                            println("[<n>]   game is already over, ignoring tick");
                        } else {
                            Pos oldHead = currentState.snake[0];
                            int oldScore = currentState.score;
                            currentState = step(currentState);
                            if (currentState.gameOver) {
                                println("[<n>]   head moved from <oldHead> toward <currentState.direction>, hit a wall, the border, or its own body: GAME OVER, final score <currentState.score>");
                            } else if (currentState.score > oldScore) {
                                println("[<n>]   head moved from <oldHead> to <currentState.snake[0]>: ate food, score <oldScore> to <currentState.score>, snake now <size(currentState.snake)> cells, new food placed at <currentState.food>");
                            } else {
                                println("[<n>]   head moved from <oldHead> to <currentState.snake[0]>, heading <currentState.direction>, score unchanged at <currentState.score>");
                            }
                        }
                    } else if (action == "reset") {
                        currentState = initialState(levelFile);
                        println("[<n>]   new game: snake at <currentState.snake[0]>, food placed at <currentState.food>, score reset to 0");
                    } else {
                        println("[<n>]   just reporting the current state, nothing changes");
                    }

                    writeResponse(id, currentState);
                    println("[<n>]   responded to bridge.py: score=<currentState.score> gameOver=<currentState.gameOver>");
                    println("");
                } catch value e: {
                    println("[<n>] request error: <e>");
                    println("");
                }
            }
        }
    }
}
