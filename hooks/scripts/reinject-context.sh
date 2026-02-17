#!/bin/bash
# reinject-context.sh - PreCompact/SessionStart(compact) hook
# Reinjects important Cortex context after compaction

# Check if cx is available
if ! command -v cx &> /dev/null; then
    exit 0
fi

# Check if Cortex is initialized
if [ ! -d ".cortex" ]; then
    exit 0
fi

# Get current task in progress
CURRENT_TASK=$(cx ls --status progress 2>/dev/null | head -5)

# Get recent memories for context
RECENT_CONTEXT=$(cx memory ls --limit 3 2>/dev/null | head -10)

# Build context message
echo "=== Cortex Context (Post-Compaction) ==="
echo ""

if [ -n "$CURRENT_TASK" ]; then
    echo "Current Task in Progress:"
    echo "$CURRENT_TASK"
    echo ""
fi

if [ -n "$RECENT_CONTEXT" ]; then
    echo "Recent Memories:"
    echo "$RECENT_CONTEXT"
fi

echo ""
echo "Remember: Use 'cx done CX-N' when task is complete."

exit 0
