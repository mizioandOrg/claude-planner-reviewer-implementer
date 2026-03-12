# Planner-Reviewer-Implementer

This repo contains two implementations of the same Planner-Reviewer-Implementer loop pattern.

## Implementations

### `bash-orchestration/`
Classic approach. A bash script spawns separate Claude Code CLI processes as agents. Agents communicate via flat files (`plan.md`, `critique.md`). Run from a plain terminal (not inside a Claude Code session).

- Entry point: `bash-orchestration/run_loop.sh`
- Requires: Claude Code CLI authenticated, `jq` installed
- See `bash-orchestration/CLAUDE.md` for full details

### `agent-orchestration/`
MoMa (Mother Agent) approach. A single Claude Code session acts as the orchestrator. It spawns Planner, Reviewer, and Implementer as subagents using the `Agent` tool. Context is passed directly via a shared `team_log` — no inter-agent files needed.

- Entry point: open a Claude Code session with `agent-orchestration/` as working directory
- Requires: Claude Code CLI authenticated
- See `agent-orchestration/CLAUDE.md` for full details

## Shared files

- `Dockerfile` — sandbox container with all dependencies (recommended for bash-orchestration)
