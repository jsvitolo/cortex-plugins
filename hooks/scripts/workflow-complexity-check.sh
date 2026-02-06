#!/bin/bash
# workflow-complexity-check.sh - PreToolUse hook for task_create
# Suggests brainstorm/plan for complex features

# Read input from stdin
INPUT=$(cat)

# Extract tool name
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')

# Only check for task creation
if [ "$TOOL_NAME" != "mcp__cortex__task_create" ]; then
    exit 0
fi

# Extract task details
TITLE=$(echo "$INPUT" | jq -r '.tool_input.title // empty')
TYPE=$(echo "$INPUT" | jq -r '.tool_input.type // "feature"')
LEVEL=$(echo "$INPUT" | jq -r '.tool_input.level // "task"')

# Skip if creating subtask or if it's a bug/chore
if [ "$LEVEL" = "subtask" ] || [ "$TYPE" = "bug" ] || [ "$TYPE" = "chore" ]; then
    exit 0
fi

# Check if cx is available
if ! command -v cx &> /dev/null; then
    exit 0
fi

# Check for complexity indicators in title
COMPLEX_KEYWORDS="system|architecture|refactor|redesign|migration|integration|auth|security|api|database|infrastructure"

if echo "$TITLE" | grep -qiE "$COMPLEX_KEYWORDS"; then
    # Check if there's an active brainstorm or plan
    ACTIVE_BRAINSTORMS=$(cx brainstorm ls --status active 2>/dev/null | grep -c "BS-" || echo "0")
    DRAFT_PLANS=$(cx hlplan ls --status draft 2>/dev/null | grep -c "PL-" || echo "0")

    if [ "$ACTIVE_BRAINSTORMS" = "0" ] && [ "$DRAFT_PLANS" = "0" ]; then
        cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "additionalContext": "This looks like a complex feature. Consider using the full workflow:\n\n1. /brainstorm \"$TITLE\" - Explore ideas and trade-offs\n2. /plan \"$TITLE\" - Document the approach\n3. Then create epic + tasks\n\nOr proceed if the solution is already clear."
  }
}
EOF
    fi
fi

exit 0
