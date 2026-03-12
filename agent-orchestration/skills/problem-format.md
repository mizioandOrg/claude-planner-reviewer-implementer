# Skill: Problem Format

Use this skill to validate that `problem.md` is well-formed at startup.

## Required Sections

```
## Orchestration          ← agent-orchestration only (new)
Max Iterations: N         (default: 5)
Visibility: low or high   (default: low)

## Task Description       ← required
[description of the task]

## Context Files          ← required (may be empty list)
- path/to/file

## Target Files           ← required
- path/to/file

## Rules & Constraints    ← required
- [rule]

## Review Criteria        ← required, exactly 10 items
1. [criterion]
...
10. [criterion]

## Implementation Instructions  ← required
[commands to run after implementation]
```

## Validation Checks

1. `## Orchestration` section is present
2. `## Review Criteria` contains exactly 10 numbered items
3. `## Target Files` lists at least one file
4. `## Task Description` is not empty

## On Validation Failure

If any check fails, stop the loop and output:
```
MoMa startup error: problem.md is missing [section/field]. Please fix it before running the loop.
```

Do not attempt to guess or fill in missing fields.
