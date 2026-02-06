#!/bin/bash
# suggest-pr-after-push.sh - PostToolUse hook for Bash
# Suggests creating PR after git push

# Read input from stdin
INPUT=$(cat)

# Extract the command that was executed
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Only check for git push commands
if ! echo "$COMMAND" | grep -qE '^git push'; then
    exit 0
fi

# Check if push was successful (exit code 0)
EXIT_CODE=$(echo "$INPUT" | jq -r '.tool_result.exit_code // 0')
if [ "$EXIT_CODE" != "0" ]; then
    exit 0
fi

# Get current branch
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null)

# Don't suggest PR for main/master
if [ "$CURRENT_BRANCH" = "main" ] || [ "$CURRENT_BRANCH" = "master" ]; then
    exit 0
fi

# Check if cx is available
if ! command -v cx &> /dev/null; then
    exit 0
fi

# Check if there's a task in progress
TASK_IN_PROGRESS=$(cx ls --status progress 2>/dev/null | grep -oE 'CX-[0-9]+' | head -1)

if [ -n "$TASK_IN_PROGRESS" ]; then
    cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Push successful! Ready for review?\n\nRun: /pr\n\nThis will:\n- Create a GitHub PR\n- Move task $TASK_IN_PROGRESS to 'review' status automatically"
  }
}
EOF
else
    cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Push successful! To create a PR, run: /pr"
  }
}
EOF
fi

exit 0
