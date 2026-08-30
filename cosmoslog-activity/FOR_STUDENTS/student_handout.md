# CosmosLog Mission: Countdown to a Working Grammar

ISIS-2111 Programming Language Essentials, Project 1 review session

## Where this fits

Your Objectilang grammar for Project 1 is due soon. Today you are not going
to touch Objectilang directly. Instead you will run through the exact same
process you'll need for it: read example programs, write EBNF, find the
bugs in a grammar, translate that grammar into Rascal, and test it. You'll
do all of that on a different language, CosmosLog, the logging system of a
fictional space agency.

Your TA is Mission Control today and will check off each mission as your
team clears it. The team with the most approvals at the end gets bragging
rights, but the real point is walking out knowing exactly what Project 1
will ask of you and which mistakes to avoid.

## Ground rules

Work in pairs, or in threes if your TA says so. Every mission has a time
limit. When time is up, move to the next one even if you're not finished;
come back later if you have minutes to spare. You get three hints per
mission at most, and using them costs a bit of your score, explained
below. Do not look up Objectilang's grammar online and do not ask an AI to
solve CosmosLog for you. The goal is to practice the process, and an
answer copied from somewhere else won't transfer anyway. All EBNF work
should follow the Project 1 format: nonterminals as plain words, terminals
in quotes.

## What you need

The `cosmoslog-dsl` folder, a Rascal project that mostly works already but
has a few gaps you'll fill in during Mission 4. Your own `rascaldsl`
project from Section 4 of the Rascal tutorial, already running, for
Mission 1 only. Paper or a shared document for the EBNF work in Missions
2, 3, and 6.

---

## Mission 1: Fast classification

Time: 7 minutes.

Warm up by spotting terminals, nonterminals, and EBNF operators in a
grammar you already know.

Open the `Syntax.rsc` file from your own `rascaldsl` project, the one for
Planning and Task from the tutorial. Sort each of these ten items into one
of four buckets: a syntactic nonterminal, a terminal, a lexical
nonterminal, or an EBNF operator.

| # | Item | Category |
|---|------|----------|
| 1 | `Planning` | |
| 2 | `'Person'` | |
| 3 | `ID` | |
| 4 | the `+` in `Task+` | |
| 5 | `INT` | |
| 6 | `':'` | |
| 7 | the `?` in `Duration?` | |
| 8 | `TimeUnit` | |
| 9 | `'min'` | |
| 10 | the `\|` in the `Action` rule | |

Hand your filled table to your TA.

---

## Mission 2: Grammar archaeology

Time: 15 minutes.

Reconstruct a full EBNF grammar from valid examples, the same skill Project
1 asks for when you build Objectilang's grammar out of Snippets 1 through
4.

Below is a complete, valid CosmosLog file. You'll also find it saved as
`cosmoslog-dsl/src/main/rascal/instance/mission2_examples.cosmos`.

```
Mission: Artemis9
Ship Falcon crew 6
Report Fuel 82 percent severity: 2
Report Comm GroundControl severity: 3

Mission: Odyssey2
Ship Odyssey crew 3
Report Dock StationAlpha severity: 1
Report Fuel 45 percent severity: 5 note: "Refuel scheduled next orbit"

Mission: Voyager3
Ship Nomad crew 12
Report Anomaly "Sensor drift on panel B" severity: 7 note: "Monitoring closely"
Ship Comet crew 2
Report Fuel 10 percent severity: 9 note: "Critical - refuel immediately"
```

On paper or in a shared document, write down the set of terminal symbols
you can identify, the set of nonterminals you need, the start symbol, the
production rules in EBNF using the Project 1 format, and a short note on
what identifiers look like and which words they can't be.

Some things your grammar has to handle. A file can hold more than one
mission. A mission can have more than one ship. A ship always has at least
one report. There are four different kinds of report, so look for all four
in the example. The note field, written as `note: "..."`, is not always
there.

Hand in your finished grammar in the Project 1 format.

---

## Mission 3: Repair bay

Time: 13 minutes.

Find and fix the mistakes in someone else's grammar, the same skill your
TA will use when grading your Project 1 submission.

An intern wrote the grammar below for CosmosLog, and it has six mistakes.
Every one of them makes the grammar reject a valid example or let through
an identifier it shouldn't. None of them is a spelling error.

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

Use the Mission 2 examples as test cases against this grammar. For each
block in that file, check whether this grammar would actually accept it.
Write down every mistake you find, note which line it's on, what's wrong,
and which example from Mission 2 proves it. Then write the corrected line.

One mistake does not show up in any positive example from Mission 2. To
find it, ask yourself what invalid instance this grammar would wrongly let
through.

You clear this mission by finding and fixing at least four of the six
mistakes, backed by evidence from the examples.

Turn in your list of mistakes and your corrected grammar.

---

## Mission 4: Translation to the engine

Time: 15 minutes.

Turn your EBNF from Mission 2, corrected with what you learned in Mission
3, into Rascal concrete syntax, and watch it actually run.

Open `cosmoslog-dsl/src/main/rascal/CosmosSyntax.rsc`. The layout rule,
the comment syntax, and the lexical alphabet for INT, STRING, ID, and the
reserved keyword list are already there and working. Leave them alone.

Fill in the seven rules marked TODO, translating your own grammar.
Remember the equivalences from Section 4.1 of the tutorial: one or more
repetitions becomes `NoTerminal+`, zero or more becomes `NoTerminal*`, an
optional element becomes `NoTerminal?`, a choice becomes
`alt1 | alt2 | alt3`, and a literal terminal goes between single quotes.

Save the file, open `Plugin.rsc`, and click Run in new Rascal terminal
above the main function. Then open any `.cosmos` file in the `instance`
folder. You should see syntax highlighting. Open
`mission2_examples.cosmos` next. If your grammar is right, there should be
no red underlines anywhere.

If something breaks, check the order of fields against the examples first,
then check whether you used `?` where you needed `+`, or the other way
around.

Turn in a completed `CosmosSyntax.rsc` and a clean, error free
`mission2_examples.cosmos`.

---

## Mission 5: Test case detectives

Time: 10 minutes.

Predict whether the parser will accept or reject an instance before you
run it. This is the same reasoning you'll use later to design test cases
for your own Objectilang grammar.

Inside `cosmoslog-dsl/src/main/rascal/instance/mission5/` there are six
files, `E1.cosmos` through `E6.cosmos`. Without opening them in the
editor yet, read them in a plain text viewer or with `cat` in a terminal.
For each one, write down your prediction, accepted or rejected, and your
reasoning.

Then open them one at a time in VS Code, with your CosmosLog project
already registered, and check your predictions. For every one you got
wrong, write down why your grammar behaved differently than you expected.

Turn in a table with six rows: prediction, actual result, and an
explanation wherever those two differ.

---

## Mission 6: The variance challenge

Time: 10 minutes, paper only, one answer per pair.

Practice, in a domain that has nothing to do with Objectilang, the exact
kind of rule that will give you the most trouble in Project 1: generics
with covariance and contravariance.

Mission Control wants a new construct, `Manifest`, for declaring reusable
generic cargo containers such as fuel, spare parts, or samples, in the
same spirit as `List[+A]` from Snippet 1 of Project 1 or
`Transformer[-In,+Out]` from Snippet 3.

Design an EBNF rule for declaring a generic `Manifest` that takes a type
parameter with an optional covariance or contravariance modifier, and that
can be instantiated with a concrete type, for example `Manifest[FuelUnit]`
or `Manifest[+FuelUnit]`. You don't need to explain what covariance or
contravariance actually mean, only capture the syntax.

Then, in three or four lines, explain how you would extend your rule to
support two type parameters with different modifiers, the way
`Transformer[-In,+Out]` does. You don't need to write that rule out in
full.

Turn in your `Manifest` rule plus your short explanation.

---

## Final checklist

Before the wrap-up discussion, make sure your team has all of this ready.
The Mission 1 table, filled in. A complete EBNF for Mission 2 in the
Project 1 format, covering terminals, nonterminals, the start symbol,
production rules, and a note on identifiers. At least four of the six
Mission 3 mistakes found and corrected, with evidence for each. A
completed `CosmosSyntax.rsc` from Mission 4, with the Mission 2 examples
parsing cleanly. The Mission 5 table of six predictions against actual
results. The Mission 6 `Manifest` rule with its explanation. And your team
should be able to say, in one sentence, what separates a terminal from a
nonterminal, and what separates a `syntax` rule from a `lexical` rule.

## What to submit

At the end of the session, upload the following to the location your TA
gives you: your EBNF document covering Missions 2, 3, and 6; your finished
`CosmosSyntax.rsc` from Mission 4; and your prediction table from Mission
5.

Nothing related to Objectilang is due today. That submission has its own
deadline, set in the Project 1 handout.
