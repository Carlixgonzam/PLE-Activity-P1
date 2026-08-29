# Session script: CosmosLog Mission, 90 minutes

Internal use only. Detailed solutions, three tiered hints, and the rubric
live in `ta_guide.md`. This document is the operational script, what to do
and when. The reference EBNF and Rascal files sit in `reference_solutions/`.

**Before the session starts**
 - Send `FOR_STUDENTS/` to every group with enough lead time that they can 
 add it to their VS Code workspace. 
 - Confirm each student already has their own `rascaldsl` project from 
 Section 4 of the tutorial up and running, since Mission 1 depends on it. 
 - Keep `reference_solutions/CosmosSyntaxSolution.rsc` open somewhere so 
 you can paste from it for a group that is completely stuck during Mission 4. 
 - A visible countdown timer helps a lot here, so set one up if you can.
 - For the opening demo, start the Snake game on your own machine ahead of
 time: `java -jar rascal-shell-stable.jar Loop` in one terminal from inside
 `snake-game/`, then `python3 bridge.py` in another. Confirm
 `http://localhost:8000` loads before students walk in. See
 `snake-game/README.md` if either command errors.

## Introduction and Snake demo, 8 minutes

Set the story and the rules, and make the link to Project 1 unmistakable.
Tell them plainly: nobody is going to see or write Objectilang's grammar
today. They are going to run the exact same procedure on CosmosLog, a
different DSL, so that by the time Project 1 lands they've already done
this once end to end. Walk through the scoring system described in the
rubric, and the three hint limit per mission. Pairs, and everyone moves on
when the timer says so.

**Opening hook: the Snake game, about 3 minutes**

Before handing out Mission 1, show them why any of this matters. You run
this, nobody else needs to touch anything.

 - Have `snake-game/src/main/rascal/levels/level1.snake` and
 `LevelSyntax.rsc` open in one window, and the game itself open in a
 browser tab, both already running from the prep step above.
 - Point at three lines of `level1.snake`: the board size, the snake's
 starting position, one `wall` line. Say plainly that this whole level is
 written in a tiny language, and somewhere there has to be a grammar
 deciding what counts as a valid line in it.
 - Open `LevelSyntax.rsc` and point at the `wall` rule for a couple of
 seconds, just enough for them to notice it is the same shape as
 everything they are about to build: a `syntax` rule, terminals in
 quotes, `INT` for the numbers.
 - Break it live. Change a `wall` line so it uses a word instead of a
 number, save it, and point at the red squiggle: the grammar just
 rejected something.
 - Fix it back, save, click New Game in the browser. The level updates
 with no restart needed. Land the point: the grammar they are about to
 write is not a paper exercise, it decides what a real program is and
 is not allowed to say, today for CosmosLog, in a few weeks for
 Objectilang.

Keep this under three minutes, it is a hook, not a lesson. The real work
starts with Mission 1.

## Mission 1: Fast classification, 6 minutes

Files: `Syntax.rsc` from `Codigo Ordenado-2/4 Concrete Syntax/`, or each
student's own copy inside their `rascaldsl` project.

What they hand in: a filled ten row table.

They clear the mission at eight correct answers out of ten.

Watch for the classic mix up between a lexical nonterminal such as `ID` or
`INT` and a syntactic nonterminal such as `TimeUnit`. It's the most common
error by a wide margin. Don't correct it outright. Ask them whether that
symbol has a `syntax` rule or a `lexical` rule behind it, and let them go
look again.

Circulate rather than parking at one table. This mission moves fast and is
mostly useful for gauging where the room stands.

## Mission 2: Grammar archaeology, 15 minutes

Files: the examples in the handout, also saved as
`instance/mission2_examples.cosmos`.

What they hand in: a full EBNF grammar on paper.

They clear the mission if they cover all five required pieces, terminals,
nonterminals, start symbol, production rules, and a note on identifiers,
and get the repetition or optionality operator right on at least four of
the five trickiest rules: `Mission+`, `Nave+`, `Report+`, `Note?`, and a
four way choice for `ReportKind`.

Hand out level one hints on your own initiative around the five minute
mark if a group still has a blank page. Don't correct their draft line by
line at this stage. Let mistakes surface naturally in Mission 4 when they
try to run their grammar in Rascal, it teaches more that way. The one
exception is a group about to lose the whole mission over a formatting
misunderstanding, such as terminals without quotes, which is worth fixing
on the spot.

## Mission 3: Repair bay, 13 minutes

There is no Rascal file for this one, it's a paper exercise built around
the flawed grammar in the handout.

What they hand in: a list of mistakes plus a corrected grammar.

They clear the mission by finding and fixing four of the six mistakes,
backed by evidence from the Mission 2 examples rather than gut feeling.

Almost no group finds bug six on their own, the one about identifiers
colliding with reserved words. That's by design, don't worry about it.
Bring it up yourself during the wrap up if nobody caught it.

At the ten minute mark, if a group is badly behind, give them a level two
hint on one bug of your choosing so they can keep moving.

## Mission 4: Translation to the engine, 15 minutes

Files: `cosmoslog-dsl/src/main/rascal/CosmosSyntax.rsc` to complete,
`Plugin.rsc` which is already done, and
`instance/mission2_examples.cosmos` for checking their work.

What they hand in: a completed `CosmosSyntax.rsc`, and
`mission2_examples.cosmos` opened with no syntax errors showing.

They clear the mission when the file compiles, meaning `Plugin.rsc` runs
without errors, and the example file shows no red underlines.

This is where most of the technical friction lives, so plan to be
available here rather than anywhere else. Common issues: forgetting to
rerun the main function in `Plugin.rsc` after editing `CosmosSyntax.rsc`,
which the tutorial itself warns about in Section 4.2; writing fields in a
different
order than the examples show, for instance putting `Note` before
`severity`; using `*` where `+` belongs, or the reverse; and forgetting
that literal keywords need single quotes.

If a group is completely stuck with under five minutes left, open
`reference_solutions/CosmosSyntaxSolution.rsc` and copy everything below
its module line into their `CosmosSyntax.rsc`, below their own module
line, so they can at least reach Mission 5 with something working. Note
that they didn't finish Mission 4 on their own when you score it.

## Mission 5: Test case detectives, 10 minutes

Files: `instance/mission5/E1.cosmos` through `E6.cosmos`.

What they hand in: a table of six predictions against actual results.

They clear the mission with four correct predictions out of six, or, with
fewer correct guesses, by correctly explaining why at least two of their
predictions were wrong, which is worth just as much as getting it right
the first time.

Case E6, the negative crew size, tends to spark real discussion. Several
groups will say it should be rejected when in fact the parser accepts it,
since it's syntactically valid even though it makes no sense. Use that
moment as a bridge into the closing discussion about syntax versus
semantics, which is what Section 8 of the tutorial covers under
validation.

## Mission 6: The variance challenge, 10 minutes

**No files, paper only.**
What they hand in: an EBNF rule for `Manifest` plus a three or four line
explanation.

They clear the mission by meeting the four criteria in the rubric found in
`ta_guide.md` and in `reference_solutions/mission6_sample_answers.md`.

This mission is deliberately open ended, there's no single right answer.
Don't mark a structurally sound answer wrong just because it doesn't match
the reference solution word for word. Keep one or two interesting or
contrasting answers in mind to show during the wrap up.

## Wrap up, 7 minutes

Ask one group to walk through bug six from Mission 3 if they caught it. If
nobody did, present it yourself and explain why it's so easy to miss.

Ask one or two groups to share their `Manifest` rule from Mission 6. If
you see two different approaches, one with a separate `Variance`
nonterminal and one without, that contrast is worth highlighting.

Open the floor with a question: how does what you just did connect to
what you'll need for `List[+A]` or `Transformer[-In,+Out]` in Project 1?

If you're keeping score to the end, announce whichever team collected the
most approvals.

## Closing and reflection, 6 minutes

Callback to the opening demo if you want a clean bookend: the Snake level
grammar they saw broken and fixed in three minutes is the same kind of
rule they now know how to write, read, and repair themselves.

Project or read out loud how each mission maps onto Project 1.

Mission 1 practiced telling terminals from nonterminals, which shows up
directly in the section of Task 1 asking for the sets of nonterminals and
symbols. Mission 2 practiced going from examples to EBNF, exactly what
Snippets 1 through 4 demand for Objectilang. Mission 3 practiced spotting
errors in a grammar, which is what self review before submission looks
like. Mission 4 practiced turning EBNF into Rascal concrete syntax, useful
for any future project that asks for an implementation. Mission 5
practiced predicting acceptance or rejection, the same skill needed to
design your own test cases. Mission 6 practiced generics with variance,
directly relevant to `List[+A]` and `Transformer[-In,+Out]`.

Close with a one minute individual reflection, no need to share out loud
unless someone wants to: which mistake today was hardest for you to spot,
and where in your own Objectilang grammar are you most likely to make that
same kind of mistake?

Remind them of the real submission format and deadline for Project 1: a
single PDF, pure EBNF, both team members' names on it, one submission per
group.
