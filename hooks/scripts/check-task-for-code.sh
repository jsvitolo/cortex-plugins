#!/bin/bash
# check-task-for-code.sh - PreToolUse hook for Edit/Write
# Warns if editing code files without a task in progress

# Read input from stdin
INPUT=$(cat)

# Extract tool name and file path
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only check for Edit and Write tools
if [ "$TOOL_NAME" != "Edit" ] && [ "$TOOL_NAME" != "Write" ]; then
    exit 0
fi

# Skip non-code files (docs, configs, etc.)
if echo "$FILE_PATH" | grep -qE '\.(md|txt|json|yaml|yml|toml|gitignore)$'; then
    exit 0
fi

# Skip test files (usually ok to edit freely)
if echo "$FILE_PATH" | grep -qE '(_test\.go|\.test\.|\.spec\.|__test__)'; then
    exit 0
fi

# Check if cx is available
if ! command -v cx &> /dev/null; then
    exit 0
fi

# Check if Cortex is initialized
if [ ! -d ".cortex" ]; then
    exit 0
fi

# Check if there's a task in progress
TASKS_IN_PROGRESS=$(cx ls --status progress 2>/dev/null | grep -c "CX-" || echo "0")

if [ "$TASKS_IN_PROGRESS" = "0" ]; then
    cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "additionalContext": "WARNING: Editing code without a Cortex task in progress.\n\nRecommended workflow:\n1. cx add \"Task description\" --type feature|bug|chore\n2. cx start CX-N\n3. Then make your changes\n\nThis ensures traceability and proper git workflow."
  }
}
EOF
fi

exit 0
