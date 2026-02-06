#!/bin/bash
# cortex-status.sh - SessionStart hook
# Loads Cortex status and injects context into the session

# Check if cx is available
if ! command -v cx &> /dev/null; then
    echo "Cortex not installed. Run: go install github.com/jonesvitolo/cortex/cmd/cx@latest"
    exit 0
fi

# Check if Cortex is initialized in this project
if [ ! -d ".cortex" ]; then
    echo "Cortex not initialized in this project. Run: cx init"
    exit 0
fi

# Get status and format as context
STATUS=$(cx status 2>/dev/null)
if [ $? -eq 0 ]; then
    echo "$STATUS"
else
    echo "Cortex: Unable to get status"
fi

exit 0
