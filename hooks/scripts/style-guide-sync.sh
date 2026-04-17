#!/bin/bash
# style-guide-sync.sh - SessionStart hook
# Auto-sync style guide on session start (non-blocking).
# Only runs if cx is installed and .cortex/ exists.

if command -v cx &>/dev/null && [ -d ".cortex" ]; then
    cx style sync --if-needed 2>/dev/null || true
fi

exit 0
