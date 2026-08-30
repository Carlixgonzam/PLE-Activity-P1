***

# PLE-Activity-P1


## Macro Structure

```text
PLE-Activity-P1/
├── rascal-projects.code-workspace
└── <activity-name>/
    ├── README.md              # Brief description of the exercise
    ├── report/                # Formal explanation (LaTeX)
    ├── FOR_STUDENTS/          # Working base for students
    │   └── <base-project>/
    │       ├── pom.xml
    │       ├── META-INF/RASCAL.MF
    │       └── src/main/rascal/
    │           ├── Syntax.rsc     # Grammar to complete
    │           ├── Main.rsc       # Entry point
    │           ├── Plugin.rsc     # Environment integration
    │           └── instance/      # Input/output examples
    └── FOR_TA/                # Guide material for teaching assistants
        ├── session_script.md  # How to guide a tutorial session for this exercise
        ├── ta_guide.md        # What to expect from the exercise
        └── reference_solutions/
```

> **Note:** The content in `FOR_STUDENTS` must be self-sufficient for completing the practice without revealing the solution. All grading materials, session guides, or answers must remain strictly in `FOR_TA` and not be shared with students.

## Workflow

To create or adapt an exercise using this pattern:

1.  **Initialize:** Copy the base structure into a new `<activity-name>` folder.
2.  **Define:** Implement the grammar (`Syntax.rsc`) and main logic in `FOR_STUDENTS`.
3.  **Validate:** Add concrete test cases in `instance/` to verify valid and invalid behaviors.
4.  **Document:** Describe the objective, execution instructions, and deliverables in the activity's `README.md`.
5.  **Separate:** Move solutions and evaluation notes to `FOR_TA` before publishing the material to students.