#!/bin/bash
# run_loop.sh — Drives planner-reviewer loop until score 10/10 then implements
# Uses --resume to retain session context between iterations (no re-reading files)
set -e

trap 'echo ""; echo "Stopped by user."; kill -- -$$ 2>/dev/null; exit 1' INT TERM

DIR="$(cd "$(dirname "$0")" && pwd)"
MAX_ITERATIONS=5
ITERATION=0
PLANNER_SESSION=""
REVIEWER_SESSION=""

# Verify problem.md exists
if [ ! -f "$DIR/problem.md" ]; then
  echo "Error: problem.md not found. Copy problem.md.example or create one from the template."
  exit 1
fi

run_claude() {
  local ROLE_DIR="$1"
  local SESSION_ID="$2"
  local PROMPT="$3"
  local RESPONSE

  cd "$ROLE_DIR"

  if [ -z "$SESSION_ID" ]; then
    RESPONSE=$(claude --print --dangerously-skip-permissions --output-format json "$PROMPT")
  else
    RESPONSE=$(claude --print --dangerously-skip-permissions --output-format json --resume "$SESSION_ID" "$PROMPT")
  fi

  echo "$RESPONSE" | jq -r '.result' 2>/dev/null || echo "$RESPONSE"
  echo "$RESPONSE" | jq -r '.session_id' 2>/dev/null
}

echo "Starting Planner-Reviewer loop (max $MAX_ITERATIONS iterations)..."

while [ $ITERATION -lt $MAX_ITERATIONS ]; do
  ITERATION=$((ITERATION + 1))
  echo ""
  echo "=== Iteration $ITERATION/$MAX_ITERATIONS ==="

  echo "[Planner] Planning improvements..."
  PLANNER_OUTPUT=$(run_claude "$DIR/planner" "$PLANNER_SESSION" "Read ../problem.md and plan the required changes.")
  PLANNER_SESSION=$(echo "$PLANNER_OUTPUT" | tail -1)
  echo "$PLANNER_OUTPUT" | head -n -1

  echo "[Reviewer] Reviewing plan..."
  REVIEWER_OUTPUT=$(run_claude "$DIR/reviewer" "$REVIEWER_SESSION" "Read ../problem.md and review the plan in ../plan.md. Write critique to ../critique.md.")
  REVIEWER_SESSION=$(echo "$REVIEWER_OUTPUT" | tail -1)
  echo "$REVIEWER_OUTPUT" | head -n -1

  SCORE=$(grep -oP 'Score:\s*\K[0-9]+' "$DIR/critique.md" 2>/dev/null || echo "0")
  echo "[Loop] Score: $SCORE/10"

  if [ "$SCORE" -ge 10 ]; then
    echo "Plan approved at 10/10. Running implement.sh..."
    cd "$DIR"
    bash implement.sh
    echo "Done."
    exit 0
  fi

  echo "Score below 10 — continuing to next iteration..."
done

echo "Max iterations ($MAX_ITERATIONS) reached. Final score: $SCORE/10"
echo "Review critique.md for remaining issues."
