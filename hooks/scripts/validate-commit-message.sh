#!/bin/bash
# validate-commit-message.sh - PreToolUse hook for Bash
# Validates that git commit messages follow Conventional Commits format
#
# Install in cortex-plugins:
#   cp hooks/validate-commit-message.sh /path/to/cortex-plugins/hooks/scripts/
#   Register in cortex-plugins/.claude-plugin/plugin.json under PreToolUse hooks

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Only check Bash tool with git commit commands
if [ "$TOOL_NAME" != "Bash" ]; then
    exit 0
fi

# Check if this is a git commit command
if ! echo "$COMMAND" | grep -qE 'git commit'; then
    exit 0
fi

# Extract commit message from -m flag
# Handle: git commit -m "msg"
MSG=$(echo "$COMMAND" | sed -n 's/.*git commit.*-m "\([^"]*\)".*/\1/p')
if [ -z "$MSG" ]; then
    # Try single quotes: git commit -m 'msg'
    MSG=$(echo "$COMMAND" | sed -n "s/.*git commit.*-m '\([^']*\)'.*/\1/p")
fi

if [ -z "$MSG" ]; then
    exit 0  # Can't extract message, let it through
fi

# Validate conventional commits format: type(scope): description
# Types: feat, fix, chore, docs, refactor, perf, test, ci, build, style, revert
PATTERN='^(feat|fix|chore|docs|refactor|perf|test|ci|build|style|revert)(\([a-zA-Z0-9_/-]+\))?(!)?: .+'
if ! echo "$MSG" | grep -qE "$PATTERN"; then
    cat << 'HOOK_EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "additionalContext": "WARNING: Commit message does not follow Conventional Commits format.\n\nExpected: type(scope): description (CX-N)\nTypes: feat, fix, chore, docs, refactor, perf, test, ci, build\n\nExamples:\n- feat(tui): add kanban auto-reload (CX-252)\n- fix(lsp): handle nil pointer in index (CX-253)\n- chore: bump version to 0.9.7"
  }
}
HOOK_EOF
fi

exit 0
