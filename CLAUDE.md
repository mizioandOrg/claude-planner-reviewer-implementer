# Planner-Reviewer-Implementer Framework

A general-purpose iterative improvement loop using three Claude agents:
- **Planner** — reads the problem and proposes changes (writes `plan.md`)
- **Reviewer** — scores the plan against criteria (writes `critique.md`)
- **Implementer** — applies the approved plan to target files

## How to use

1. Fill in `problem.md` with your task description, files, rules, and 10 review criteria
2. Run `./run_loop.sh`
3. The loop iterates (max 5 rounds) until the reviewer scores 10/10, then auto-implements

## File layout

- `problem.md` — your problem definition (the only file you need to edit)
- `plan.md` — generated plan (written by Planner, read by Reviewer and Implementer)
- `critique.md` — generated critique (written by Reviewer, read by Planner)
- `run_loop.sh` — orchestrator script
- `implement.sh` — applies the approved plan
- `planner/CLAUDE.md` — Planner agent instructions
- `reviewer/CLAUDE.md` — Reviewer agent instructions
- `examples/` — example problem definitions for reference
