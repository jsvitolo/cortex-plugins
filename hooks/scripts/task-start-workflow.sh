#!/bin/bash
# task-start-workflow.sh - PostToolUse hook for task_update
# Guides workflow when task status changes

# Read input from stdin
INPUT=$(cat)

# Extract tool name
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')

if [ "$TOOL_NAME" != "mcp__cortex__task_update" ]; then
    exit 0
fi

# Extract status change
NEW_STATUS=$(echo "$INPUT" | jq -r '.tool_input.status // empty')
TASK_ID=$(echo "$INPUT" | jq -r '.tool_input.id // empty')

case "$NEW_STATUS" in
    progress)
        # Get current branch
        CURRENT_BRANCH=$(git branch --show-current 2>/dev/null)

        if [ "$CURRENT_BRANCH" = "main" ] || [ "$CURRENT_BRANCH" = "master" ]; then
            cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Task $TASK_ID started!\n\nYou're on $CURRENT_BRANCH. Create a feature branch:\n  git checkout -b feat/${TASK_ID,,}-description\n\nOr use: mcp__cortex__git_branch(task_id=\"$TASK_ID\")"
  }
}
EOF
        else
            cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Task $TASK_ID in progress on branch: $CURRENT_BRANCH\n\nWorkflow:\n1. Implement changes\n2. Commit with: git commit -m \"feat: description ($TASK_ID)\"\n3. Push and create PR: /pr\n4. After merge: /merge or cx done $TASK_ID"
  }
}
EOF
        fi
        ;;
    review)
        cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Task $TASK_ID moved to review!\n\nIf PR is approved, merge with:\n  /merge\n\nThis will squash merge and move task to done."
  }
}
EOF
        ;;
    done)
        cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Task $TASK_ID completed!\n\nConsider:\n- Saving learnings: cx memory diary \"What was learned\"\n- Check for next task: cx ls --status backlog"
  }
}
EOF
        ;;
esac

exit 0
