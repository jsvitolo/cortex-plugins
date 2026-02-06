#!/bin/bash
# epic-workflow.sh - PostToolUse hook for epic/task operations
# Guides epic workflow and task linking

# Read input from stdin
INPUT=$(cat)

# Extract tool name
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')

case "$TOOL_NAME" in
    mcp__cortex__task_create)
        LEVEL=$(echo "$INPUT" | jq -r '.tool_input.level // "task"')

        if [ "$LEVEL" = "epic" ]; then
            # Check tool result for the created epic ID
            EPIC_ID=$(echo "$INPUT" | jq -r '.tool_result.id // empty')
            cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Epic created!\n\nNext steps:\n1. Create tasks for this epic:\n   task_create(title, level=\"task\")\n2. Link tasks to epic:\n   epic_link_task(epic_id=\"$EPIC_ID\", task_id=\"CX-N\")\n3. Start first task: cx start CX-N"
  }
}
EOF
        fi
        ;;
    mcp__cortex__epic_link_task)
        cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Task linked to epic!\n\nView epic tasks: epic_tasks(epic_id)\nStart working: cx start CX-N or /implement CX-N"
  }
}
EOF
        ;;
esac

exit 0
