# Planner-Reviewer-Implementer

An iterative improvement loop using three Claude Code agents:

1. **Planner** reads your problem definition and proposes changes (`plan.md`)
2. **Reviewer** scores the plan against your criteria (`critique.md`)
3. **Implementer** applies the approved plan to your target files

The loop runs up to 5 iterations until the reviewer scores 10/10, then auto-implements.

## Quick start

### Option A: Fill in `problem.md` yourself

1. Edit `problem.md` with your task, files, constraints, and 10 review criteria
2. Run `./run_loop.sh`

### Option B: Let an agent help you set up

Point Claude Code at this repo and ask it to read `CLAUDE.md` and help you fill in `problem.md`. It will ask you questions about your task, files, and what "good" looks like, then populate the template for you.

## File layout

| File | Purpose |
|------|---------|
| `problem.md` | Your problem definition (the only file you edit) |
| `plan.md` | Generated plan (written by Planner) |
| `critique.md` | Generated critique (written by Reviewer) |
| `run_loop.sh` | Orchestrator script |
| `implement.sh` | Applies the approved plan |
| `planner/CLAUDE.md` | Planner agent instructions |
| `reviewer/CLAUDE.md` | Reviewer agent instructions |
| `examples/` | Example problem definitions |

## Requirements

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) installed and authenticated

## How it works

```
problem.md
    |
    v
[Planner] --> plan.md --> [Reviewer] --> critique.md
    ^                                        |
    |________________________________________|
              (loop until 10/10)
                     |
                     v
              [Implementer]
          (applies plan to files)
```

Each agent runs in its own subdirectory with a `CLAUDE.md` that scopes its permissions. The Planner can only write `plan.md`. The Reviewer can only write `critique.md`. The Implementer is the only agent that touches your target files.
