module CosmosSyntax

// Reference solution. Do not distribute to students.
// Drop this in place of a group's CosmosSyntax.rsc only when you
// need to quickly check that a test case from E1 through E6
// behaves as expected, or as a last resort to unblock a group
// during Mission 4 or 5.

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
