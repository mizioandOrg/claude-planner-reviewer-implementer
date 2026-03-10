#!/bin/bash
# implement.sh — Applies the approved plan.md to target files
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

echo "[Implementer] Applying approved plan..."
claude --print --dangerously-skip-permissions \
  "Read problem.md and plan.md. Implement every change described in plan.md into the target files listed in problem.md. Follow the Implementation Instructions section in problem.md for any post-change steps."

echo "[Implementer] Done."
