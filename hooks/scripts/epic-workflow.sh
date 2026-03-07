#!/bin/bash
# epic-workflow.sh - PostToolUse hook for epic/task operations
# Guides epic workflow and task linking

# Read input from stdin
INPUT=$(cat)

# Extract tool name and action
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
ACTION=$(echo "$INPUT" | jq -r '.tool_input.action // empty')

# task(action="create") with level="epic"
if [ "$TOOL_NAME" = "mcp__cortex__task" ] && [ "$ACTION" = "create" ]; then
    LEVEL=$(echo "$INPUT" | jq -r '.tool_input.level // "task"')

    if [ "$LEVEL" = "epic" ]; then
        EPIC_ID=$(echo "$INPUT" | jq -r '.tool_result.id // empty')
        cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Epic created!\n\nNext steps:\n1. Create tasks for this epic:\n   mcp__cortex__task(action=\"create\", title=\"...\", level=\"task\")\n2. Link tasks to epic:\n   mcp__cortex__epic(action=\"link_task\", epic_id=\"$EPIC_ID\", task_id=\"CX-N\")\n3. Start first task: cx start CX-N"
  }
}
EOF
    fi
    exit 0
fi

# epic(action="link_task")
if [ "$TOOL_NAME" = "mcp__cortex__epic" ] && [ "$ACTION" = "link_task" ]; then
    cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Task linked to epic!\n\nView epic tasks: mcp__cortex__epic(action=\"tasks\", epic_id=\"...\")\nStart working: cx start CX-N or /implement CX-N"
  }
}
EOF
    exit 0
fi

exit 0
