#!/bin/bash
# brainstorm-next-steps.sh - PostToolUse hook for brainstorm operations
# Guides next steps after brainstorm actions

# Read input from stdin
INPUT=$(cat)

# Extract tool name and action
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
ACTION=$(echo "$INPUT" | jq -r '.tool_input.action // empty')

# Only handle mcp__cortex__brainstorm calls
if [ "$TOOL_NAME" != "mcp__cortex__brainstorm" ]; then
    exit 0
fi

case "$ACTION" in
    create)
        cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Brainstorm created! Next steps:\n\n1. Add ideas: mcp__cortex__brainstorm(action=\"add_idea\", id=..., content=..., pros=..., cons=...)\n2. Vote on ideas: mcp__cortex__brainstorm(action=\"vote_idea\", idea_id=..., vote=\"up\"/\"down\")\n3. Select winners: mcp__cortex__brainstorm(action=\"select_idea\", idea_id=..., selected=true)\n4. Record decisions: mcp__cortex__brainstorm(action=\"add_decision\", id=..., content=..., rationale=...)\n5. Convert to plan: /plan or mcp__cortex__brainstorm(action=\"to_plan\", id=...)"
  }
}
EOF
        ;;
    select_idea)
        SELECTED=$(echo "$INPUT" | jq -r '.tool_input.selected // false')
        if [ "$SELECTED" = "true" ]; then
            cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Idea selected! When ready to proceed:\n\n- Record the decision: mcp__cortex__brainstorm(action=\"add_decision\", ...)\n- Convert to plan: mcp__cortex__brainstorm(action=\"to_plan\", id=...)\n\nOr continue exploring more ideas."
  }
}
EOF
        fi
        ;;
    add_decision)
        cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Decision recorded! Ready to move forward?\n\n- Convert to plan: mcp__cortex__brainstorm(action=\"to_plan\", id=...)\n- Or add more decisions if needed"
  }
}
EOF
        ;;
    to_plan)
        cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Plan created from brainstorm!\n\nNext steps:\n1. Review/edit the plan: cx hlplan show PL-N\n2. Approve when ready: mcp__cortex__highlevel_plan(action=\"update\", id=..., status=\"approved\")\n3. Create epic: mcp__cortex__task(action=\"create\", title=..., level=\"epic\")\n4. Break into tasks and link: mcp__cortex__epic(action=\"link_task\", ...)"
  }
}
EOF
        ;;
esac

exit 0
