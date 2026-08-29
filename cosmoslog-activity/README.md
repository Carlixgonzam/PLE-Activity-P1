# CosmosLog Mission: Project 1 Review Activity

This folder is self contained and does not modify the original skeleton
you were given, the `Codigo Ordenado-2` folder with reference code from
`rascal_tutorial.pdf`.

## What we found in the original skeleton

`Codigo Ordenado-2` is not a project skeleton for Objectilang. It holds the
code listings from `rascal_tutorial.pdf` itself, sections 4 through 9,
sorted into folders, built around the tutorial's own example DSL of
Planning, PersonTasks, and Task. It is missing a full project layout: no
META-INF/RASCAL.MF, no src/main/rascal, no Main.rsc outside section 9. It
has nothing to do with Objectilang.

Given that, this activity treats that tutorial code as a working, already
solved example for Mission 1, and builds a new DSL in a different domain
for Missions 2 through 6. That DSL is CosmosLog, a logging system for
space missions, packaged as a full Rascal project under
`FOR_STUDENTS/cosmoslog-dsl/`.

## How to use this folder

Before the session, zip `FOR_STUDENTS/` and send it to every group through
whatever channel the course already uses. Each student should also have
their own `rascaldsl` project open already, the one built from
`Codigo Ordenado-2` while following the tutorial.

During the session, follow `FOR_TA/session_script.md`. It opens with a
three minute demo run from the Snake game project, a sibling folder at
`../snake-game/`, not part of this folder. Start that game on your own
machine before students arrive, see `snake-game/README.md`, since the
demo is the TA changing its level grammar live, not something students
run themselves.

When a group gets stuck, work through the graded hints in
`FOR_TA/ta_guide.md` instead of handing over the answer right away.

Keep `FOR_TA/` away from students at all times. It holds the correct
grammars and the answer key for every mission.

## Quick technical check

```
cd cosmoslog-activity/FOR_STUDENTS/cosmoslog-dsl
```

In VS Code, add that folder to the workspace, open
`src/main/rascal/Plugin.rsc`, and run its main function in a new Rascal
terminal. It will fail until `CosmosSyntax.rsc` is completed during
Mission 4. That failure is expected, not a bug.
