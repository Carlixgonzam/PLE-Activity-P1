module F1SeasonSyntaxSolution

// Reference implementation for a Formula 1 Racing Simulation DSL.
//
// Designed for simulating F1 racing scenarios, this file contains
// core syntax rules and expected results for a DSL targeting
// race simulation projects. Use it as a reference to create
// projects with modules like Race, Driver, Car, Track, and more.
//
// To use this in practice: copy everything below the module line into
// your CosmosSyntax.rsc file, replacing its TODO section. Keep the
// original "module CosmosSyntax" line at the top untouched.

layout Layout = WhitespaceAndComment* !>> [\ \t\n\r#];
lexical WhitespaceAndComment = [\ \t\n\r] | @category="Comment" "#" ![\n]* $;

// Working in progress

lexical INT = ([\-0-9][0-9]* !>> [0-9]);
lexical STRING = "\"" ![\"\n]* "\"";
lexical ID = ([a-zA-Z/.\-][a-zA-Z0-9_/.]* !>> [a-zA-Z0-9_/.]) \ Reserved;

keyword Reserved = "TODO";
