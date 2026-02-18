#!/bin/bash
# lsp-reindex-on-edit.sh - PostToolUse hook for Edit/Write
# Triggers LSP reindex when code files are edited

# Read input from stdin
INPUT=$(cat)

# Extract tool name and file path
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only check Edit and Write tools
if [ "$TOOL_NAME" != "Edit" ] && [ "$TOOL_NAME" != "Write" ]; then
    exit 0
fi

# Only trigger for supported languages
if ! echo "$FILE_PATH" | grep -qE '\.(ex|exs)$'; then
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

# Trigger reindex in the background (non-blocking)
cx lsp index --language elixir --path "$(pwd)" > /dev/null 2>&1 &

exit 0
