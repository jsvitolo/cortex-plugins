#!/bin/bash
# check-branch-for-commit.sh - PreToolUse hook for Bash
# Warns if committing directly to main/master (should be on feature branch)

# Read input from stdin
INPUT=$(cat)

# Extract the command being executed
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Only check for git commit commands
if ! echo "$COMMAND" | grep -qE '^git commit'; then
    exit 0
fi

# Get current branch
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null)

# Check if on main or master
if [ "$CURRENT_BRANCH" = "main" ] || [ "$CURRENT_BRANCH" = "master" ]; then
    cat << 'EOF'
{
  "decision": "block",
  "reason": "You are on the main/master branch. Create a feature branch first:\n\n1. Run: git checkout -b feat/cx-N-description\n2. Or use: cx start CX-N (creates branch + worktree automatically)\n\nDirect commits to main/master should be avoided."
}
EOF
    exit 0
fi

# Check if branch follows naming convention
if ! echo "$CURRENT_BRANCH" | grep -qE '^(feat|fix|chore|docs|refactor)/cx-[0-9]+-'; then
    cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "additionalContext": "NOTE: Branch '$CURRENT_BRANCH' doesn't follow naming convention (feat/cx-N-desc or fix/cx-N-desc). Consider renaming for better traceability."
  }
}
EOF
fi

exit 0
