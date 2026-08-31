# Rascal Snake

A small arcade game where Rascal is the authoritative logic engine: it
owns the game state, applies every move, checks every collision, and
decides when the game is over. A browser page renders the board on a
canvas and sends player input.

## Architecture

```
browser  <-- HTTP -->  bridge.py  <-- JSON files -->  Loop.rsc (Rascal)
```

The browser only ever talks to `bridge.py`, a small Python HTTP server
with no game logic of its own. It serves the page and relays every
request to the Rascal process by writing a request file and waiting for
the matching response file.

`Loop.rsc` is a plain, long running Rascal process, started once. It
parses the level file, holds the current `GameState`, and on every
request runs the same `turn` and `step` logic defined in `Engine.rsc`.

### Why not Rascal serving HTTP directly

The first version of this project used `util::Webserver`, Rascal's own
HTTP library, to have Rascal listen on a socket directly. That turned
out not to work: in this Rascal build, the callback `serve()` invokes
on every request fails to correctly resolve local variables and
function parameters, even for code that works perfectly everywhere
else. The full story, and the tests that pinned it down, are in
`src/main/rascal/Server.rsc`, kept only for reference. `Loop.rsc` sidesteps
the bug entirely by never registering a callback: everything runs
inside one ordinary `main()`, which does work correctly.

## The level DSL

Levels are written in a small language, defined in `LevelSyntax.rsc`.

```
board 24 x 18
snake at 12,9 length 3 heading right
speed 140
wall 5,4 to 5,13
wall 18,4 to 18,13
```

`board` sets the grid size. `snake` sets the starting head position,
length, and direction. `speed` sets the tick interval in milliseconds,
used by the browser to drive the tick loop. Any number of `wall` lines
describe solid rectangles the snake cannot cross. The default level
lives at `src/main/rascal/levels/level1.snake`; point `Loop.rsc` at a
different file to try a different layout.

## Running it

You need Java, and a `rascal-shell-stable.jar` somewhere on disk. Two
terminals, in this order.

Terminal one, the engine:

```
cd snake-game
java -jar /path/to/rascal-shell-stable.jar Loop
```

Wait for `Rascal Snake engine is running.` The first run is slower,
Rascal is generating the level grammar's parser.

Terminal two, the bridge:

```
cd snake-game
python3 bridge.py
```

Then open `http://localhost:8000` in a browser. Arrow keys or WASD to
steer, the snake ticks on its own at the level's speed, and there's a
New Game button once you top a wall or yourself.

## Editing the level live

`/reset`, the New Game button, re-reads and re-parses
`levels/level1.snake` from disk every time, no restart needed. Edit that
file, save it, click New Game, and the change shows up immediately. This
is what the grammar review activity's opening demo relies on: break a
wall line, save, show the parse error; fix it, save, click New Game,
show the new level. For the parse error itself to show up as a red
squiggle while editing, open this folder in VS Code and run `Plugin.rsc`'s
main function once, in a new Rascal terminal, the same way `Plugin.rsc`
works in `cosmoslog-dsl`. That registers `.snake` files with the editor;
it is unrelated to `Loop.rsc` and `bridge.py`, which is what actually
runs the game.

## Known rough edges

`Loop.rsc`'s main loop polls its request file in a tight `while (true)`
loop with no sleep, since this Rascal build has no sleep function in
its standard library. It will pin one CPU core the entire time it runs.
Fine for a local demo, worth revisiting with `util::ShellExec` calling
the OS `sleep` command if that bothers you.

The bridge and the engine exchange exactly one request at a time,
serialized behind a lock in `bridge.py`, which is enough for one player
in one browser tab. It is not built for multiple concurrent players.
