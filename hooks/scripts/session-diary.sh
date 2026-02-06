#!/bin/bash
# session-diary.sh - Stop hook
# Reminds to save session context before ending

# Check if cx is available
if ! command -v cx &> /dev/null; then
    exit 0
fi

# Check if Cortex is initialized
if [ ! -d ".cortex" ]; then
    exit 0
fi

# Check if there's a task in progress
TASK_IN_PROGRESS=$(cx ls --status progress 2>/dev/null | grep -oE 'CX-[0-9]+' | head -1)

echo "=== Session End Checklist ==="
echo ""

if [ -n "$TASK_IN_PROGRESS" ]; then
    echo "Task in progress: $TASK_IN_PROGRESS"
    echo ""
    echo "Options:"
    echo "  - cx done $TASK_IN_PROGRESS  (if work is complete)"
    echo "  - Leave in progress for next session"
    echo ""
fi

echo "Consider saving session context:"
echo "  cx memory diary \"Brief summary of what was accomplished\""
echo ""
echo "Or use: /session-end"

exit 0
