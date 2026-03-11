# Planner-Reviewer-Implementer

> **Run this in a sandbox.**
> This framework executes Claude Code agents with `--dangerously-skip-permissions` against files in your project. It is designed to run inside an isolated environment (container, VM, or CI sandbox) — not directly on your personal machine or production system.

An iterative improvement loop using three Claude Code agents:

1. **Planner** reads your problem definition and proposes changes (`plan.md`)
2. **Reviewer** scores the plan against your criteria (`critique.md`)
3. **Implementer** applies the approved plan to your target files

The loop runs up to 5 iterations until the reviewer scores 10/10, then auto-implements.

## Requirements

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) installed and authenticated
- `jq` installed (`apt install jq` / `brew install jq`)

> **Authenticate before first run.**
> The script launches Claude Code as a subprocess. Run `claude` once interactively to complete authentication, then run `./run_loop.sh`.

> **Do not run from inside a Claude Code session.**
> Claude Code blocks nested invocations. Run `run_loop.sh` from a plain terminal, not from within an active Claude Code session.

## Quick start

### Option A: Fill in `problem.md` yourself

1. Edit `problem.md` with your task, files, constraints, and 10 review criteria
2. Run `./run_loop.sh`

### Option B: Let an agent help you set up

Point Claude Code at this repo and ask it to read `CLAUDE.md` and help you fill in `problem.md`. It will ask you questions about your task, files, and what "good" looks like, then populate the template for you.

## Running with Docker

Build the image:

```bash
docker build -t planner-reviewer-implementer .
```

Create a named container, authenticate inside it, then run the loop — all in one session. The container is kept so credentials persist for subsequent runs:

```bash
# First time: create the container, authenticate, then run
docker run -it --name pri \
  -v "$(pwd)":/workspace \
  planner-reviewer-implementer \
  bash -c "claude && bash run_loop.sh"

# Subsequent runs: restart the same container (credentials already stored inside)
docker start -ai pri
```

> **Security note:** Credentials are stored inside the named container only — not on your host
> filesystem and not in a mounted volume. Do not replace this with a bind mount of your host
> `~/.claude` directory. The script processes untrusted file content using
> `--dangerously-skip-permissions`, making it vulnerable to prompt injection that could leak
> credentials. Use a dedicated Claude account with minimal permissions for automation workloads.

## File layout

| File | Purpose |
|------|---------|
| `problem.md` | Your problem definition (the only file you edit) |
| `plan.md` | Generated plan (written by Planner) |
| `critique.md` | Generated critique (written by Reviewer) |
| `run_loop.sh` | Orchestrator script |
| `implement.sh` | Applies the approved plan |
| `Dockerfile` | Container image with all dependencies |
| `planner/CLAUDE.md` | Planner agent instructions |
| `reviewer/CLAUDE.md` | Reviewer agent instructions |
| `examples/` | Example problem definitions |

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
