module CosmosSyntaxSolution

// Reference solution. Do not distribute to students.
//
// Named CosmosSyntaxSolution, not CosmosSyntax, on purpose: this file
// is not its own runnable project, it is loose reference material, and
// giving it the same module name as the real CosmosSyntax.rsc files in
// cosmoslog-dsl and smoke-test caused a duplicate module error the
// moment all three ended up open in the same VS Code window.
//
// To actually use this to unblock a group, copy everything below the
// module line into their CosmosSyntax.rsc, replacing its TODO section.
// Leave their own "module CosmosSyntax" line at the top untouched.

layout Layout = WhitespaceAndComment* !>> [\ \t\n\r#];
lexical WhitespaceAndComment = [\ \t\n\r] | @category="Comment" "#" ![\n]* $;

start syntax MissionControlLog
    = missionControlLog: Mission+ missions
;

syntax Mission
    = mission: 'Mission:' ID name Nave+ naves
;

syntax Nave
    = nave: 'Ship' ID name 'crew' INT crewSize Report+ reports
;

syntax Report
    = report: 'Report' ReportKind kind 'severity' ':' INT sev Note? note
;

syntax ReportKind
    = fuel: FuelReport fuelReport
    | anomaly: AnomalyReport anomalyReport
    | comm: CommReport commReport
    | dock: DockReport dockReport
;

syntax FuelReport = fuelReport: 'Fuel' INT pct 'percent' ;
syntax AnomalyReport = anomalyReport: 'Anomaly' STRING description ;
syntax CommReport = commReport: 'Comm' ID target ;
syntax DockReport = dockReport: 'Dock' ID station ;

syntax Note = note: 'note' ':' STRING text ;

lexical INT = ([\-0-9][0-9]* !>> [0-9]);
lexical STRING = "\"" ![\"\n]* "\"";
lexical ID = ([a-zA-Z/.\-][a-zA-Z0-9_/.]* !>> [a-zA-Z0-9_/.]) \ Reserved;

keyword Reserved = "Mission" | "Ship" | "crew" | "Report" | "severity" | "note"
                  | "Fuel" | "percent" | "Anomaly" | "Comm" | "Dock" | ":";

// Expected results for the Mission 5 cases:
// E1 accepted, E2 accepted, E3 rejected, E4 rejected,
// E5 rejected, E6 accepted since it is syntactically valid
// even though it is semantically absurd.
