#!/bin/bash
# check-task-tracking.sh - PreToolUse hook for Bash
# Warns if committing without a task in progress

# Read input from stdin
INPUT=$(cat)

# Extract the command being executed
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Only check for git commit commands
if ! echo "$COMMAND" | grep -qE '^git commit'; then
    exit 0
fi

# Check if cx is available
if ! command -v cx &> /dev/null; then
    exit 0
fi

# Check if Cortex is initialized
if [ ! -d ".cortex" ]; then
    exit 0
fi

# Check if there's a task in progress
TASKS_IN_PROGRESS=$(cx ls --status progress 2>/dev/null | grep -c "CX-" || echo "0")

if [ "$TASKS_IN_PROGRESS" = "0" ]; then
    # Return JSON with warning context (not blocking, just warning)
    cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "additionalContext": "WARNING: No Cortex task in progress. Consider running 'cx add \"Task title\"' and 'cx start CX-N' before committing. This helps maintain traceability."
  }
}
EOF
fi

exit 0
