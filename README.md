# Planner-Reviewer-Implementer

An iterative improvement loop using three Claude Code agents:

1. **Planner** reads your problem definition and proposes changes
2. **Reviewer** scores the plan against your criteria
3. **Implementer** applies the approved plan to your target files

The loop runs up to 5 iterations until the reviewer scores 10/10, then auto-implements.

## Two implementations

### `agent-orchestration/` — MoMa (Mother Agent)
A single Claude Code session acts as the orchestrator (MoMa). It spawns Planner, Reviewer, and Implementer as separate subagents via the `Agent` tool. Context is passed directly via a shared `team_log` — no inter-agent files needed. Runs safely in interactive mode — `--dangerously-skip-permissions` is optional.

**Requirements:** Claude Code CLI authenticated

### `bash-orchestration/` — classic
A bash script spawns Claude Code CLI processes as agents. Agents communicate via flat files (`plan.md`, `critique.md`). Run from a plain terminal (not inside a Claude Code session).

> **Run in a sandbox.** This orchestrator uses `--dangerously-skip-permissions` and should run inside an isolated environment (container, VM, or CI sandbox) — not directly on your personal machine or production system.

**Requirements:** Claude Code CLI authenticated, `jq` (`apt install jq` / `brew install jq`)

> **Authenticate before first run.** Run `claude` once interactively to complete authentication, then run the loop script.

> **Do not run from inside a Claude Code session.** Claude Code blocks nested invocations.

## Quick start

### Option A: Fill in `problem.md` yourself

For agent-orchestration (MoMa):
1. Edit `agent-orchestration/problem.md` with your task, files, constraints, and 10 review criteria — or leave it blank and MoMa will run a setup wizard
2. Open a Claude Code session in `agent-orchestration/`:
   ```bash
   cd agent-orchestration
   claude
   ```
   MoMa starts automatically and will ask for permission before each subagent spawn and tool call.

   To skip all permission prompts (recommended in sandboxed environments only):
   ```bash
   claude --dangerously-skip-permissions
   ```
   Subagents inherit permissions from the parent session — no flag needed per subagent.

For bash-orchestration:
1. Edit `bash-orchestration/problem.md` with your task, files, constraints, and 10 review criteria
2. Run `bash bash-orchestration/run_loop.sh`

### Option B: Let an agent help you set up

Point Claude Code at this repo and ask it to read `CLAUDE.md` and help you fill in `problem.md`. It will ask you questions about your task, files, and what "good" looks like, then populate the template for you.

## How agent-orchestration (MoMa) works

```
problem.md
    |
    v
  [MoMa] --> spawns --> [Planner subagent] --> plan text (in context)
    |                                               |
    +---------> spawns --> [Reviewer subagent] <----+
    |                           |
    |                      score < 10? loop
    |                           |
    +---------> spawns --> [Implementer subagent]
                               |
                          target files modified
```

MoMa holds all state in its context window. No files are written between agents unless context pressure requires it.

## How bash-orchestration works

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

Each agent runs in its own subdirectory with a `CLAUDE.md` that scopes its permissions.

## Running with Docker (bash-orchestration)

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
  bash -c "claude && bash bash-orchestration/run_loop.sh"

# Subsequent runs: restart the same container (credentials already stored inside)
docker start -ai pri
```

> **Security note:** Credentials are stored inside the named container only — not on your host
> filesystem and not in a mounted volume. Do not replace this with a bind mount of your host
> `~/.claude` directory. The script processes untrusted file content using
> `--dangerously-skip-permissions`, making it vulnerable to prompt injection that could leak
> credentials. Use a dedicated Claude account with minimal permissions for automation workloads.
