module Engine

import LevelSyntax;
import ParseTree;
import util::Math;
import List;
import String;
import IO;

data Pos = pos(int x, int y);

data GameState
    = gameState(
        list[Pos] snake,
        Pos food,
        str direction,
        str pending,
        int width,
        int height,
        list[Pos] wallCells,
        int score,
        bool gameOver,
        int speedMs
      )
    ;

Level parseLevel(loc file) = parse(#start[Level], readFile(file)).top;

list[Pos] wallCellsOf(Wall w) {
    int x1 = toInt("<w.x1>");
    int y1 = toInt("<w.y1>");
    int x2 = toInt("<w.x2>");
    int y2 = toInt("<w.y2>");
    list[Pos] cells = [];
    for (int x <- (x1 < x2 ? [x1..x2+1] : [x2..x1+1]), int y <- (y1 < y2 ? [y1..y2+1] : [y2..y1+1])) {
        cells += pos(x, y);
    }
    return cells;
}

str directionOf(Direction d) {
    if (/up() := d) return "up";
    if (/down() := d) return "down";
    if (/left() := d) return "left";
    return "right";
}

Pos randomFreeCell(GameState st) {
    list[Pos] taken = st.snake + st.wallCells;
    while (true) {
        Pos candidate = pos(arbInt(st.width), arbInt(st.height));
        if (candidate notin taken) return candidate;
    }
    return pos(0, 0);
}

GameState initialState(loc levelFile) {
    Level lvl = parseLevel(levelFile);

    int width = toInt("<lvl.width>");
    int height = toInt("<lvl.height>");
    int sx = toInt("<lvl.sx>");
    int sy = toInt("<lvl.sy>");
    int len = toInt("<lvl.len>");
    int speedMs = toInt("<lvl.ms>");
    str dir = directionOf(lvl.dir);

    list[Pos] snake = [pos(sx - i, sy) | int i <- [0..len]];
    if (dir == "left") snake = [pos(sx + i, sy) | int i <- [0..len]];
    if (dir == "up") snake = [pos(sx, sy + i) | int i <- [0..len]];
    if (dir == "down") snake = [pos(sx, sy - i) | int i <- [0..len]];

    list[Pos] wallCells = [*wallCellsOf(w) | Wall w <- lvl.walls];

    GameState st = gameState(snake, pos(0, 0), dir, dir, width, height, wallCells, 0, false, speedMs);
    return st[food = randomFreeCell(st)];
}

Pos moveOne(Pos p, str dir) {
    switch (dir) {
        case "up": return pos(p.x, p.y - 1);
        case "down": return pos(p.x, p.y + 1);
        case "left": return pos(p.x - 1, p.y);
        case "right": return pos(p.x + 1, p.y);
    }
    return p;
}

bool isOpposite(str a, str b)
    = (a == "up" && b == "down")
    || (a == "down" && b == "up")
    || (a == "left" && b == "right")
    || (a == "right" && b == "left")
    ;

GameState turn(GameState st, str dir) {
    if (dir notin {"up", "down", "left", "right"}) return st;
    if (isOpposite(st.direction, dir)) return st;
    return st[pending = dir];
}

GameState step(GameState st) {
    if (st.gameOver) return st;

    str dir = st.pending;
    Pos newHead = moveOne(st.snake[0], dir);

    bool hitBorder = newHead.x < 0 || newHead.x >= st.width || newHead.y < 0 || newHead.y >= st.height;
    bool hitWall = newHead in st.wallCells;
    bool hitSelf = newHead in st.snake[0..-1];

    if (hitBorder || hitWall || hitSelf) {
        return st[direction = dir][gameOver = true];
    }

    bool ateFood = newHead == st.food;
    list[Pos] newSnake = ateFood ? [newHead] + st.snake : [newHead] + st.snake[0..-1];

    GameState next = st[snake = newSnake][direction = dir];

    if (ateFood) {
        next = next[score = next.score + 1];
        next = next[food = randomFreeCell(next)];
    }

    return next;
}
