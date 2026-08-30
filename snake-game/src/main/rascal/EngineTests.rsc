module EngineTests

import Engine;
import LevelSyntax;
import List;

test bool moveUpDecreasesY() = moveOne(pos(5, 5), "up") == pos(5, 4);
test bool moveDownIncreasesY() = moveOne(pos(5, 5), "down") == pos(5, 6);
test bool moveLeftDecreasesX() = moveOne(pos(5, 5), "left") == pos(4, 5);
test bool moveRightIncreasesX() = moveOne(pos(5, 5), "right") == pos(6, 5);

test bool oppositeDirectionsDetected()
    = isOpposite("up", "down")
    && isOpposite("down", "up")
    && isOpposite("left", "right")
    && isOpposite("right", "left")
    ;

test bool nonOppositeDirectionsNotFlagged()
    = !isOpposite("up", "left")
    && !isOpposite("up", "up")
    ;

private GameState freshState(list[Pos] snake, str dir)
    = gameState(snake, pos(0, 0), dir, dir, 10, 10, [], 0, false, 100);

test bool turnIgnoresReversal() {
    GameState st = freshState([pos(5, 5), pos(5, 6)], "up");
    return turn(st, "down").pending == "up";
}

test bool turnAcceptsValidDirection() {
    GameState st = freshState([pos(5, 5), pos(5, 6)], "up");
    return turn(st, "left").pending == "left";
}

test bool turnIgnoresGarbageInput() {
    GameState st = freshState([pos(5, 5), pos(5, 6)], "up");
    return turn(st, "sideways").pending == "up";
}

test bool stepMovesSnakeForwardWithoutGrowing() {
    GameState st = freshState([pos(5, 5), pos(5, 6), pos(5, 7)], "up");
    GameState next = step(st);
    return next.snake == [pos(5, 4), pos(5, 5), pos(5, 6)] && !next.gameOver;
}

test bool stepDetectsBorderCollision() {
    GameState st = freshState([pos(0, 0)], "up")[food = pos(9, 9)];
    return step(st).gameOver;
}

test bool stepDetectsWallCollision() {
    GameState st = freshState([pos(5, 5)], "up")[wallCells = [pos(5, 4)]][food = pos(0, 0)];
    return step(st).gameOver;
}

test bool stepDetectsSelfCollision() {
    GameState st = freshState([pos(5, 5), pos(5, 4), pos(4, 4), pos(4, 5)], "up")[food = pos(0, 0)];
    return step(st).gameOver;
}

test bool stepGrowsAndScoresOnFood() {
    GameState st = freshState([pos(5, 5), pos(5, 6)], "up")[food = pos(5, 4)];
    GameState next = step(st);
    return size(next.snake) == 3 && next.snake[0] == pos(5, 4) && next.score == 1 && !next.gameOver;
}

test bool wallCellsOfCoversHorizontalSpan() {
    Wall w = (Wall) `wall 0,0 to 2,0`;
    return wallCellsOf(w) == [pos(0, 0), pos(1, 0), pos(2, 0)];
}

test bool wallCellsOfCoversVerticalSpanRegardlessOfOrder() {
    Wall w = (Wall) `wall 3,2 to 3,0`;
    return wallCellsOf(w) == [pos(3, 0), pos(3, 1), pos(3, 2)];
}
