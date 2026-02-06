#!/bin/bash
# suggest-done-after-merge.sh - PostToolUse hook for Bash
# Suggests marking task as done after merge

# Read input from stdin
INPUT=$(cat)

# Extract the command that was executed
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Check for merge commands (gh pr merge or git merge)
if ! echo "$COMMAND" | grep -qE '(gh pr merge|git merge)'; then
    exit 0
fi

# Check if command was successful
EXIT_CODE=$(echo "$INPUT" | jq -r '.tool_result.exit_code // 0')
if [ "$EXIT_CODE" != "0" ]; then
    exit 0
fi

# Check if cx is available
if ! command -v cx &> /dev/null; then
    exit 0
fi

# Check if there's a task in review
TASK_IN_REVIEW=$(cx ls --status review 2>/dev/null | grep -oE 'CX-[0-9]+' | head -1)

if [ -n "$TASK_IN_REVIEW" ]; then
    cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Merge successful!\n\nDon't forget to close the task:\n  cx done $TASK_IN_REVIEW\n\nOr use /merge next time - it handles everything automatically!"
  }
}
EOF
fi

exit 0
