module LevelSyntax

layout Layout = WhitespaceAndComment* !>> [\ \t\n\r#];
lexical WhitespaceAndComment = [\ \t\n\r] | @category="Comment" "#" ![\n]* $;

lexical INT = [0-9]+ !>> [0-9];

syntax Direction
    = up: 'up'
    | down: 'down'
    | left: 'left'
    | right: 'right'
    ;

syntax Wall
    = wall: 'wall' INT x1 ',' INT y1 'to' INT x2 ',' INT y2
    ;

start syntax Level
    = level: 'board' INT width 'x' INT height
             'snake' 'at' INT sx ',' INT sy 'length' INT len 'heading' Direction dir
             'speed' INT ms
             Wall* walls
    ;
