#!/bin/bash
# suggest-lsp-for-read.sh - PreToolUse hook for Read
# Suggests using LSP tools instead of reading entire code files

# Read input from stdin
INPUT=$(cat)

# Extract tool name and file path
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
OFFSET=$(echo "$INPUT" | jq -r '.tool_input.offset // empty')

# Only check Read tool
if [ "$TOOL_NAME" != "Read" ]; then
    exit 0
fi

# Skip if offset is specified (targeted read is fine)
if [ -n "$OFFSET" ] && [ "$OFFSET" != "null" ]; then
    exit 0
fi

# Only check code files
if ! echo "$FILE_PATH" | grep -qE '\.(go|ts|tsx|js|jsx|py|rs|ex|exs|java|kt|swift|c|cpp|h)$'; then
    exit 0
fi

# Check if the file is large (> 500 lines)
if [ -f "$FILE_PATH" ]; then
    LINES=$(wc -l < "$FILE_PATH" 2>/dev/null | tr -d ' ')
    if [ "$LINES" -lt 500 ]; then
        exit 0
    fi
fi

cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "additionalContext": "TIP: This is a large code file. Consider using LSP tools first to save tokens:\n\n- mcp__cortex__lsp action=\"symbols\" file=\"<path>\" — file outline (~200 tokens)\n- mcp__cortex__lsp action=\"workspace_search\" query=\"<term>\" — global symbol search\n- Then use Read with offset/limit for specific sections only"
  }
}
EOF

exit 0
