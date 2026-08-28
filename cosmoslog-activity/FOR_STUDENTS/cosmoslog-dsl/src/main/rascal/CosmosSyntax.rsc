module CosmosSyntax

// ============================================================
// CosmosLog, concrete syntax, Mission 4
// ============================================================
// Already provided: layout, comments, the lexical nonterminals
// INT, STRING, ID, and the reserved word list.
// Still missing: the syntax rules and the start syntax rule.
//
// Use your EBNF from Mission 2, corrected with what you learned
// in Mission 3, as the source of truth. Translate each EBNF rule
// into a Rascal syntax rule the way Section 4.1 of the tutorial
// showed with Planning and Task in Syntax.rsc.
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
// TODO 1, the start symbol.
// A CosmosLog file contains one or more Mission.
// Shape hint: start syntax MissionControlLog = label: body ;
// ------------------------------------------------------------



// ------------------------------------------------------------
// TODO 2, Mission.
// A Mission opens with the literal 'Mission:', has an ID for
// the mission name, and one or more Nave.
// ------------------------------------------------------------



// ------------------------------------------------------------
// TODO 3, Nave.
// A Nave opens with the literal 'Ship', has an ID for its name,
// the literal 'crew', an INT for the crew size, and one or more
// Report.
// ------------------------------------------------------------



// ------------------------------------------------------------
// TODO 4, Report.
// A Report opens with the literal 'Report', has a ReportKind,
// then the literal 'severity', the literal ':', an INT, and an
// optional Note. Watch the order: in the examples severity
// always comes before the note, whenever the note is present.
// ------------------------------------------------------------



// ------------------------------------------------------------
// TODO 5, ReportKind.
// A ReportKind is one of four alternatives: FuelReport,
// AnomalyReport, CommReport, DockReport.
// Check your examples. All four kinds actually appear in the
// Mission 2 data. If your Mission 3 EBNF missed one, this is
// the moment to add it.
// ------------------------------------------------------------



// ------------------------------------------------------------
// TODO 6, the four concrete report types.
// FuelReport becomes 'Fuel' INT 'percent'
// AnomalyReport becomes 'Anomaly' STRING
// CommReport becomes 'Comm' ID
// DockReport becomes 'Dock' ID
// ------------------------------------------------------------



// ------------------------------------------------------------
// TODO 7, Note.
// A Note is the literal 'note', the literal ':', and a STRING.
// ------------------------------------------------------------



// ============================================================
// Given, leave this alone: the lexical alphabet
// ============================================================
lexical INT = ([\-0-9][0-9]* !>> [0-9]);
lexical STRING = "\"" ![\"\n]* "\"";
lexical ID = ([a-zA-Z/.\-][a-zA-Z0-9_/.]* !>> [a-zA-Z0-9_/.]) \ Reserved;

keyword Reserved = "Mission" | "Ship" | "crew" | "Report" | "severity" | "note"
                  | "Fuel" | "percent" | "Anomaly" | "Comm" | "Dock" | ":";
