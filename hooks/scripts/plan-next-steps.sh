#!/bin/bash
# plan-next-steps.sh - PostToolUse hook for plan operations
# Guides next steps after plan actions

# Read input from stdin
INPUT=$(cat)

# Extract tool name and action
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
ACTION=$(echo "$INPUT" | jq -r '.tool_input.action // empty')

# Only handle mcp__cortex__highlevel_plan calls
if [ "$TOOL_NAME" != "mcp__cortex__highlevel_plan" ]; then
    exit 0
fi

case "$ACTION" in
    create)
        cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Plan created!\n\nNext steps:\n1. Add details: mcp__cortex__highlevel_plan(action=\"update\", id=..., content=\"...\")\n2. Approve when ready: mcp__cortex__highlevel_plan(action=\"update\", id=..., status=\"approved\")\n3. Create epic + tasks to implement"
  }
}
EOF
        ;;
    update)
        STATUS=$(echo "$INPUT" | jq -r '.tool_input.status // empty')
        if [ "$STATUS" = "approved" ]; then
            cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Plan approved! Ready to implement:\n\n1. Create epic: mcp__cortex__task(action=\"create\", title=..., level=\"epic\")\n2. Link plan to epic: mcp__cortex__highlevel_plan(action=\"link_epic\", id=..., epic_id=...)\n3. Break into tasks: mcp__cortex__task(action=\"create\", ...) for each work item\n4. Link tasks to epic: mcp__cortex__epic(action=\"link_task\", epic_id=..., task_id=...)\n5. Start implementation: cx start CX-N or /implement CX-N"
  }
}
EOF
        fi
        ;;
esac

exit 0
