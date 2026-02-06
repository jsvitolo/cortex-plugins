#!/bin/bash
# ensure-main-updated.sh - PreToolUse hook for git checkout/branch
# Ensures main is up-to-date before creating new branches

# Read input from stdin
INPUT=$(cat)

# Extract the command being executed
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Only check for branch creation commands
if ! echo "$COMMAND" | grep -qE '^git (checkout -b|branch|switch -c)'; then
    exit 0
fi

# Get current branch
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null)

# If already on a feature branch, skip
if echo "$CURRENT_BRANCH" | grep -qE '^(feat|fix|chore|docs|refactor)/'; then
    exit 0
fi

# Check if we're on main/master
if [ "$CURRENT_BRANCH" != "main" ] && [ "$CURRENT_BRANCH" != "master" ]; then
    cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "additionalContext": "NOTE: You're not on main/master. Consider:\n1. git checkout main && git pull\n2. Then create your feature branch\n\nThis ensures your branch starts from the latest code."
  }
}
EOF
    exit 0
fi

# Check if main is behind remote
git fetch origin "$CURRENT_BRANCH" --quiet 2>/dev/null

LOCAL=$(git rev-parse "$CURRENT_BRANCH" 2>/dev/null)
REMOTE=$(git rev-parse "origin/$CURRENT_BRANCH" 2>/dev/null)

if [ "$LOCAL" != "$REMOTE" ]; then
    cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "additionalContext": "WARNING: Your main branch is not up-to-date with remote.\n\nRun first:\n  git pull origin main\n\nThen create your feature branch."
  }
}
EOF
fi

exit 0
