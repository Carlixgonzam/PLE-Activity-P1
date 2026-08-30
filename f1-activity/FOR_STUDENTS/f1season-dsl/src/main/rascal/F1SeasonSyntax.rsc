module F1SeasonSyntax

// ============================================================
// F1SeasonSyntax, concrete syntax, Mission 4
// ============================================================
// Already provided: layout, comments, the lexical nonterminals
// INT, STRING, ID, and the reserved word list.
// Still missing: the syntax rules and the start syntax rule.
//
// Some intructions
//
// A few reminders.
// A nonterminal repeated one or more times becomes NoTerminal+
// A nonterminal repeated zero or more times becomes NoTerminal*
// An optional nonterminal, zero or one, becomes NoTerminal?
// A choice between alternatives is alt1 | alt2 | alt3
// A literal terminal, a keyword or symbol, goes between single quotes
// ============================================================

layout Layout = WhitespaceAndComment* !>> [\ \t\n\r#];
lexical WhitespaceAndComment = [\ \t\n\r] | @category="Comment" "#" ![\n]* $;

// ------------------------------------------------------------
// TODO 1
// ------------------------------------------------------------



// ------------------------------------------------------------
// TODO 2
// ------------------------------------------------------------



// ------------------------------------------------------------
// TODO 3
// ------------------------------------------------------------



// ------------------------------------------------------------
// TODO 4
// ------------------------------------------------------------



// ------------------------------------------------------------
// TODO 5
// ------------------------------------------------------------



// ------------------------------------------------------------
// TODO 6
// ------------------------------------------------------------



// ------------------------------------------------------------
// TODO 7
// ------------------------------------------------------------

// ------------------------------------------------------------
// Maybe less or more TODOs.
// ------------------------------------------------------------




// ============================================================
// Given, leave this alone: the lexical alphabet
// ============================================================
lexical INT = ([\-0-9][0-9]* !>> [0-9]);
lexical STRING = "\"" ![\"\n]* "\"";
lexical ID = ([a-zA-Z/.\-][a-zA-Z0-9_/.]* !>> [a-zA-Z0-9_/.]) \ Reserved;

keyword Reserved = "TODO";