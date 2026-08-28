# Mission 3, the six planted bugs and how to fix them

Do not distribute. The broken grammar handed to students lives in
`student_handout.md`, under Mission 3. This document is the full
diagnosis.

## The grammar students receive, with bugs

```
MissionControlLog ::= Mission
Mission ::= "Mission:" ID Nave
Nave ::= "Ship" ID "crew" INT Report+
Report ::= "Report" ReportKind "severity" ":" INT Note
ReportKind ::= FuelReport | AnomalyReport | CommReport
FuelReport ::= "Fuel" INT "percent"
AnomalyReport ::= "Anomaly" STRING
CommReport ::= "Comm" ID
Note ::= "note" STRING
```

## The six bugs

Bug one sits on the first line, `MissionControlLog ::= Mission`. It's
missing the `+`, so only one mission is allowed. The log example has
three separate `Mission:` blocks, which proves it. This is a missing
repetition operator.

Bug two sits on `Mission ::= "Mission:" ID Nave`. It's also missing a
`+`, allowing only one ship per mission. The Voyager3 mission has two
ships, Nomad and Comet, which proves it. Same category, a missing
repetition operator.

Bug three sits on the `Report` rule, where `Note` is required instead of
optional. The Fuel and Comm reports under Artemis9 have no `note:` at
all, which proves it. This is a missing optionality operator.

Bug four sits on `ReportKind`, which only lists three alternatives and
leaves out `DockReport`. The Odyssey2 mission uses
`Report Dock StationAlpha ...`, which proves it. This is a missing
alternative in a choice.

Bug five sits on `Note ::= "note" STRING`, which is missing the `":"`
between the keyword and the string. Every example writes `note: "..."`
with a colon in between, which proves it. This is a missing terminal.

Bug six doesn't sit anywhere in particular, because it's an omission: the
grammar never states that `ID` excludes reserved words. No single
positive example exposes this one, which is exactly what makes it a
silent bug. Something like `Ship Report crew 6` would be technically
permitted with no visible contradiction until you actually think through
edge cases. This is a missing rule about the identifier alphabet.

## The repaired grammar, matching the Mission 2 reference

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

ID ::= letter, then letter or digit, repeated. An ID cannot equal a
reserved word.
```

## How to pass this mission

Finding and correcting at least four of the six bugs, with reasoning
grounded in the examples rather than a gut feeling, clears the mission.
All six earns a full approval, see the rubric in `ta_guide.md`.

## A teaching note

Bug six is the hardest to spot on purpose, because it never breaks a
positive example. It only shows up once you start thinking about which
invalid instances the grammar should reject, which is exactly the mindset
Mission 5 builds. If a group misses it in Mission 3, don't push too hard,
they'll likely rediscover it on their own while working out case E5 in
Mission 5. It's also a direct parallel to a real and common mistake when
writing the Identifiers section of the Objectilang grammar for Project 1.
