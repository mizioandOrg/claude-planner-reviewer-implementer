# Skill: Score Extraction

Use this skill to extract the numeric score from a Reviewer subagent's output.

## Algorithm

1. Search the returned text for a line matching the pattern: `Score: N/10`
2. Extract N as an integer (0–10)
3. If no such line is found:
   - Treat the score as 0
   - Note the parse failure in your reasoning
   - Spawn the Reviewer subagent again with the same inputs and the instruction: "Your final line must be exactly `Score: N/10` — no other text after it."
4. If N equals 10 → the plan is approved, proceed to Implementer invocation
5. If N is less than 10 → append the full critique text to `team_log` and begin the next iteration

## Notes

- The score line is guaranteed to be the last non-empty line if the Reviewer followed its role definition
- Do not attempt to infer a score from other parts of the critique text
- A retry counts as the same iteration (does not increment the iteration counter)
