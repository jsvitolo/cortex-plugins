#!/bin/bash
# plan-next-steps.sh - PostToolUse hook for plan operations
# Guides next steps after plan actions

# Read input from stdin
INPUT=$(cat)

# Extract tool name
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')

case "$TOOL_NAME" in
    mcp__cortex__highlevel_plan_create)
        cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Plan created!\n\nNext steps:\n1. Add details: highlevel_plan_update(id, content=\"...\")\n2. When ready: plan submitted for review\n3. Approve: highlevel_plan_update(id, status=\"approved\")\n4. Create epic + tasks to implement"
  }
}
EOF
        ;;
    mcp__cortex__highlevel_plan_update)
        STATUS=$(echo "$INPUT" | jq -r '.tool_input.status // empty')
        if [ "$STATUS" = "approved" ]; then
            cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Plan approved! Ready to implement:\n\n1. Create epic: task_create(title, level=\"epic\")\n2. Link plan to epic: highlevel_plan_link_epic(plan_id, epic_id)\n3. Break into tasks: task_create() for each work item\n4. Link tasks to epic: epic_link_task(epic_id, task_id)\n5. Start implementation: cx start CX-N or /implement CX-N"
  }
}
EOF
        fi
        ;;
esac

exit 0
