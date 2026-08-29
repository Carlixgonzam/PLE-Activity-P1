# TA guide: CosmosLog Mission

Keep this away from students. It holds solutions, hints, and the rubric.

The full reference grammars and EBNF live in `reference_solutions/`. This
document summarizes them and adds graded hints, guiding questions, common
mistakes, timing, and a short rubric.

## Suggested timing for the 90 minutes

 - Introduction - 5 minutes. 
 - Mission 1 - 7 minutes, total 12 minutes. 
 - Mission 2 - 15 minutes, total 27 minutes. 
 - Mission 3 - 13 minutes, total 40 minutes. 
 - Mission 4 - 15 minutes, total 55 minutes. 
 - Mission 5 - 10 minutes, total 65 minutes.
 - Mission 6 - 10 minutes, total 75 minutes. 
 - The wrap up - 8 minutes, total 83 minutes. 
 - Closing and reflection - 7 minutes, total 90 minutes.

Missions 2 and 4 are the ones most likely to run long or short depending 
on the group, so they can absorb a couple of minutes borrowed from 
elsewhere if you're on track everywhere else.

## Mission 1: Fast classification

The answer key:

`Planning` is a syntactic nonterminal, the start symbol. `'Person'` is a
terminal, a keyword. `ID` is a lexical nonterminal. The `+` in `Task+` is
a repetition operator, one or more, applied to `Task`. `INT` is a lexical
nonterminal. `':'` is a terminal, a punctuation symbol. The `?` in
`Duration?` is an optionality operator applied to `Duration`. `TimeUnit`
is a syntactic nonterminal. `'min'` is a terminal, a keyword. The `|` in
the `Action` rule is a choice operator.

The concept worth explaining: the distinction that trips people up almost
every time is lexical versus syntactic. Both kinds of rules produce
nonterminals, but a lexical rule such as `ID` or `INT` doesn't allow
layout, meaning whitespace, to sneak in between its parts, and it's
usually built from character level regular expressions. A syntactic rule
such as `TimeUnit` does allow layout between its components and is built
out of other named nonterminals and terminals.

Guiding questions, don't hand over the answer: is that symbol defined
with the word `syntax` or the word `lexical` in the file? Can that symbol
have whitespace in the middle of its parts?

A common mistake is treating `TimeUnit` as a terminal just because it
doesn't have quotes around it. Remind students that quotes are the only
thing marking a terminal, not capitalization.

## Mission 2: Grammar archaeology

See `reference_solutions/mission2_reference_grammar.md` for the full
grammar and a grading checklist.

Hints, level one, giving away almost nothing: count how many `Mission:`
blocks appear in the example. What does that tell you about how many
times that part of the rule can repeat? Look for all four different
report types one by one in the text.

Hints, level two, narrowing things down: look closely at the Voyager3
mission. It has something the other two don't. What element repeats there
that doesn't repeat elsewhere? Does every `Report` have a `note:`? What
EBNF operator means an element might or might not be there?

Hints, level three, close to giving away the rule, reserve these for
groups that are truly stuck: the rule for a ship needs the same `+`
operator you already used for missions, but applied to reports instead of
ships. Can a report exist without a note? Then `Note` needs a `?`, not no
operator at all and not a `*`.

A useful general question: what would happen to a real CosmosLog file
with a mission that has only one ship? Would their rule allow that? What
about five ships? That forces them to think about the range each operator
actually covers.

Common mistakes: skipping `ReportKind` as an intermediate nonterminal and
folding all four alternatives directly into `Report`. That's not wrong,
but it produces one long, confusing rule, so suggest splitting it out
without insisting. Writing `Note` before `severity` because that's how
they think about it conceptually rather than the order the text actually
uses. Leaving out any mention of identifiers versus reserved words, which
is partly expected here and gets reinforced in Mission 3.

## Mission 3: Repair bay

See `reference_solutions/mission3_bug_list.md` for the full table of six
bugs with their evidence and fix.

Hints for bugs one through five, level one: take each line of the grammar
and try to find a Mission 2 example that uses it. If nothing matches
exactly, something is wrong there.

Level two: the Voyager3 mission has two ships. Read the rule for
`Mission` in the broken grammar. Does it allow that? Which reports in the
examples have no `note:`? Read the rule for `Report`. Is the note
optional there?

Level three: one whole alternative is missing from `ReportKind`. Which of
the four report types from Mission 2 doesn't appear in that list? Compare
`Note ::= "note" STRING` with how `note:` actually looks in any example.
There's a symbol missing between the two parts.

Hints for bug six, the identifiers and reserved words issue, at three
levels: level one, no Mission 2 example breaks this grammar for this
reason, so think of an example we didn't give you. What would happen if
someone named a ship `Report`? Level two, does the grammar say anywhere
what characters an `ID` can contain? Does it say an `ID` can't be the same
as a keyword like `Ship` or `Report`? Level three, recall the `\ Reserved`
pattern from the Planning and Task `Syntax.rsc` they already know.
Something equivalent is missing here.

A common mistake worth watching for: some groups fix `Nave+` back down to
`Nave` in the rule for a ship, a rule that was already correct, because
they lose track of which rule actually had the bug. Ask them to write down
the example that proves each bug before touching the grammar, it stops
guesswork.

## Mission 4: Translation to the engine

See `reference_solutions/CosmosSyntaxSolution.rsc`.

Hints, level one: go back to Section 4.1 of the tutorial. How did the
`Task` rule look in Rascal? Their `Report` rule translates in almost the
same way.

Level two: did they save the file? Did they rerun the main function in
`Plugin.rsc` after saving? The tutorial says explicitly in Section 4.2
that the DSL has to be re-registered every time the grammar changes.

Level three: show them, without letting them copy paste yet, the full
`Report` rule from `CosmosSyntaxSolution.rsc` and ask them to compare it
field by field with their own.

Common mistakes: confusing the terminal `'Fuel'` with `Fuel`, which
doesn't exist as a nonterminal in this grammar, usually a stray quote or
capitalization typo that produces a confusing compile error. Not finishing
all seven rules before testing, which causes Rascal to report undefined
nonterminal errors in a cascade that looks worse than it is, so reassure
them this is normal mid completion. Writing `Note note` instead of
`Note? note`, which will show up as an error on every line in the example
file that has no `note:`.

A fast way to check your own understanding: open
`instance/mission2_examples.cosmos` yourself with
`CosmosSyntaxSolution.rsc` in place. There should be no underlines at
all. Keep that mental picture handy when a group says they don't know
what's missing.

## Mission 5: Test case detectives

Expected results with the reference grammar:

E1 is accepted, a minimal valid instance. E2 is accepted, two missions,
no note anywhere, includes a Dock report. E3 is rejected, missing the
literal `"Mission:"` at the start. E4 is rejected, `severity:` gets a
STRING instead of an INT. E5 is rejected, `Report`, a reserved word, used
as a ship name. E6 is accepted, `crew -6` is syntactically valid since INT
allows negative numbers, even though it's semantically absurd, and that's
not something a grammar is meant to catch.

Guiding questions: before running each case, ask which specific rule in
their grammar is being tested. For E6 specifically: does your grammar
guarantee a number is positive? Should it? What's the name, from the
tutorial, of the phase that catches something syntactically valid but
meaningless? The answer is validation, covered in Section 8, and it's not
a grammar problem.

A common mistake is confusing a bug in their own grammar, say if they left
`Note` mandatory back in Mission 4, with a correct behavior of CosmosLog
as designed. Help them tell the two apart by asking whether a given result
exposes a bug in their `CosmosSyntax.rsc`, or is actually what CosmosLog
should do.

## Mission 6: The variance challenge

See `reference_solutions/mission6_sample_answers.md` for two full valid
answers and the insight about declaration versus use.

Hints, level one: what operator did you already use today for an element
that might or might not be there? The same one applies here, but to the
plus or minus modifier, not to a whole nonterminal.

Level two: how would you write "the modifier is plus or it's minus"?
You already did something like that in Mission 2 with the four report
types. It's the same operator.

Level three: give them the empty shape
`Manifest ::= "Manifest" "[" ___ "]"` and ask them to fill the blank by
combining the two ideas from the earlier hints.

A guiding question for the two parameter extension: if you already have a
rule for one parameter with an optional modifier, how would you write "two
of those, separated by a comma"?

There is no single correct answer here. Grade against the rubric in
`reference_solutions/mission6_sample_answers.md`, not against an exact
string match.

## Short formative rubric, per team, not an official grade

Score each of the following from zero to three. Distinguishing a
terminal from a nonterminal and from an operator, checked in Missions 1
and 2: zero means no distinction at all, one means it takes constant
help, two means one or two corrections were needed, three means they
handled it without help. Turning examples into a complete, consistent
EBNF grammar, checked in Mission 2: zero for an incomplete or
inconsistent grammar, one for covering most of it with gaps, two for
covering everything with one minor error, three for a complete and
correct grammar. Finding and arguing for errors in someone else's
grammar, checked in Mission 3: zero for one or none out of six, one for
two or three, two for four or five, three for all six with clear
evidence. Translating EBNF into Rascal and debugging it, checked in
Mission 4: zero for failing to compile, one for compiling only with
direct help, two for compiling after one or two hints, three for
compiling on their own. Designing and predicting test cases, checked in
Mission 5: zero for fewer than three correct out of six with no
explanation, one for three or four correct, two for four or five correct
with explanations, three for five or six correct with solid explanations.
Transferring the pattern to a new case, checked in Mission 6: zero for
failing to represent the optional modifier at all, one for representing
the modifier without a real choice between plus and minus, two for
meeting three of the four rubric criteria, three for meeting all four and
explaining the extension coherently.

Use this as material for qualitative feedback at the close of the
session, not necessarily as a grade. Check with the course instructor
first if it's going to feed into a participation score.

## Approval system for the story

Each mission cleared, based on the criteria above, earns approvals. Three
approvals if no hint was used. Two if one hint was used. One if two or
three hints were used. Zero if the minimum bar wasn't met, though the team
still moves on to the next mission regardless. The maximum possible is
eighteen approvals, six missions times three. Announce the team with the
most during the wrap up if you want to keep the story going through the
end.
