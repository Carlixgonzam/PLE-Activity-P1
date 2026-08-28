# Mission 2 reference grammar, CosmosLog

Do not distribute. Use this for fast grading and for the guiding
questions.

## Terminals

```
"Mission:" "Ship" "crew" "Report" "severity" ":" "note"
"Fuel" "percent" "Anomaly" "Comm" "Dock"
```

Plus the implicit terminals from the lexical alphabet: digits, letters,
quote marks.

## Nonterminals

```
MissionControlLog, Mission, Nave, Report, ReportKind,
FuelReport, AnomalyReport, CommReport, DockReport, Note,
ID, INT, STRING
```

## Start symbol

```
MissionControlLog
```

## Production rules

```
MissionControlLog ::= Mission+

Mission ::= "Mission:" ID Nave+

Nave ::= "Ship" ID "crew" INT Report+

Report ::= "Report" ReportKind "severity" ":" INT Note?

ReportKind ::= FuelReport | AnomalyReport | CommReport | DockReport

FuelReport ::= "Fuel" INT "percent"

AnomalyReport ::= "Anomaly" STRING

CommReport ::= "Comm" ID

DockReport ::= "Dock" ID

Note ::= "note" ":" STRING
```

## Identifiers and reserved words

```
ID ::= letter, then letter or digit, repeated. An ID cannot equal a
reserved word.
Reserved = Mission, Ship, crew, Report, severity, note, Fuel, percent,
Anomaly, Comm, Dock
```

## What to check in each team's work

Their exact nonterminal names do not need to match this document. What
matters is the structure.

Does the top level rule use `+` on `Mission`, not `*` and not a bare
symbol with no operator? The handout asks for one or more missions,
proven by the three blocks in the example. Does `Mission` use `+` on
`Nave`? The Voyager3 mission has two ships. Does `Nave` use `+` on
`Report`? Does `Report` mark `Note` as optional with `?`, rather than
mandatory or missing entirely? Does `ReportKind` have four alternatives?
It's common for a team to only find three, missing Dock, if they didn't
check every example carefully. Do they treat `":"` as a separate terminal
from `"severity"` and from `"note"`, two tokens rather than one merged
token, matching how the examples actually write it? Do they say anywhere,
even informally, that identifiers can't match a reserved word? That
connects directly to Section 3 of the Project 1 handout.

## Mistakes you'll likely see

Merging `Report` and `ReportKind` into one large rule. Not wrong on its
own, but it makes Mission 4's translation into Rascal harder, so suggest
splitting it without requiring it. Placing `severity` after `note` in
their rule because some groups don't check the actual order in the
examples closely enough. Writing `ID` as a quoted terminal instead of
treating it as a nonterminal.
