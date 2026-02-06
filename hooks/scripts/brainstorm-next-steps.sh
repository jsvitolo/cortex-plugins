#!/bin/bash
# brainstorm-next-steps.sh - PostToolUse hook for brainstorm operations
# Guides next steps after brainstorm actions

# Read input from stdin
INPUT=$(cat)

# Extract tool name
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')

# Check for brainstorm-related tools
case "$TOOL_NAME" in
    mcp__cortex__brainstorm_create)
        cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Brainstorm created! Next steps:\n\n1. Add ideas: brainstorm_add_idea(id, content, pros, cons)\n2. Vote on ideas: brainstorm_vote_idea(idea_id, \"up\"/\"down\")\n3. Select winners: brainstorm_select_idea(idea_id, true)\n4. Record decisions: brainstorm_add_decision(id, content, rationale)\n5. Convert to plan: /plan or brainstorm_to_plan(id)"
  }
}
EOF
        ;;
    mcp__cortex__brainstorm_select_idea)
        # Check if input has selected=true
        SELECTED=$(echo "$INPUT" | jq -r '.tool_input.selected // false')
        if [ "$SELECTED" = "true" ]; then
            cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Idea selected! When ready to proceed:\n\n- Record the decision: brainstorm_add_decision()\n- Convert to plan: brainstorm_to_plan(brainstorm_id)\n\nOr continue exploring more ideas."
  }
}
EOF
        fi
        ;;
    mcp__cortex__brainstorm_add_decision)
        cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Decision recorded! Ready to move forward?\n\n- Convert to plan: brainstorm_to_plan(brainstorm_id)\n- Or add more decisions if needed"
  }
}
EOF
        ;;
    mcp__cortex__brainstorm_to_plan)
        cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Plan created from brainstorm!\n\nNext steps:\n1. Review/edit the plan: cx hlplan show PL-N\n2. Approve when ready: plan_approve(plan_id)\n3. Create epic: task_create(title, level=\"epic\")\n4. Break into tasks: task_create() + epic_link_task()"
  }
}
EOF
        ;;
esac

exit 0
