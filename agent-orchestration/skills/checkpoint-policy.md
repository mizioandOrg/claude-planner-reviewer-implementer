# Skill: Checkpoint Policy

Use this skill to decide when to write files vs. keep everything in context.

## When to Write Files

### 1. Approval checkpoint (always)
When score reaches 10/10, write `checkpoints/approved-plan.md` with the final plan text before invoking the Implementer. This is the handoff artifact and audit record.

### 2. Context pressure
If the accumulated `team_log` is getting large — either because you are on iteration 4+ or because plans/critiques are unusually long — write:
- `checkpoints/team_log.md` — the full team_log so far

Then replace the inlined `team_log` in subsequent subagent prompts with:
```
Team history: see checkpoints/team_log.md
```
Subagents can read the file directly. This keeps both MoMa's context and subagent prompt sizes manageable.

Note: subagent context windows are fresh per spawn and are only at risk if the team_log itself is very large (e.g. a complex multi-file task with long plans). MoMa's own context is the more likely pressure point.

### 3. High visibility mode (optional)
If `problem.md` contains `Visibility: high` in the `## Orchestration` section, write `plan.md` and `critique.md` at the end of each iteration. This mirrors bash-orchestration behavior and lets the user inspect progress in their editor.

## Default Behavior

By default (`Visibility: low`), no `plan.md` or `critique.md` files are written. All communication is in-context.

## What MoMa Must Never Write

- Target files (only the Implementer subagent may touch those)
- Files outside `checkpoints/` and (in high visibility mode) `plan.md`/`critique.md`
