#!/bin/bash
# reinject-context.sh - PreCompact hook
# Reinjects rich Cortex context after compaction

if ! command -v cx &> /dev/null; then
    exit 0
fi

if [ ! -d ".cortex" ]; then
    exit 0
fi

# Use the rich context command with markdown format
# Timeout after 4 seconds to stay under 5s limit
timeout 4 cx context --format markdown 2>/dev/null

exit 0
