#!/bin/bash
# filter-rewrite.sh - PreToolUse hook for Bash
# Rewrites filterable commands to use cx filter for output compression.
#
# Claude Code PreToolUse hooks:
#   - Receive JSON on stdin with tool_name and tool_input
#   - Output JSON to modify the tool input
#   - Exit 0 = proceed (with optional modifications)
#   - Exit 2 = block the tool use

# Skip if cx is not installed
command -v cx &>/dev/null || exit 0

# Skip if jq is not installed
command -v jq &>/dev/null || exit 0

# Read hook input from stdin
INPUT=$(cat)

# Extract the command from JSON
# Claude Code sends: {"tool_name":"Bash","tool_input":{"command":"..."}}
COMMAND_STR=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)

# If no command, skip
[ -z "$COMMAND_STR" ] && exit 0

# If already using cx filter, skip
echo "$COMMAND_STR" | grep -q 'cx filter' && exit 0

# --------------------------------------------------------------------------
# Filterable command patterns (v1 hardcoded list)
# These are commands whose output benefits from cx filter compression.
# --------------------------------------------------------------------------
FILTER_PATTERNS=(
    # git commands
    'git diff'
    'git status'
    'git log'
    'git branch'
    'git stash list'
    'git remote -v'
    # go commands
    'go test'
    'go build'
    'go vet'
    # cargo (rust)
    'cargo test'
    'cargo build'
    'cargo check'
    # npm
    'npm test'
    'npm install'
    'npm audit'
    # yarn
    'yarn test'
    'yarn install'
    # python
    'pytest'
    'python -m pytest'
    'pip install'
    'pip list'
    'pip freeze'
    # docker
    'docker ps'
    'docker images'
    'docker build'
    # kubernetes
    'kubectl get'
    # system
    'ls'
    'find'
    'du'
    'df'
    'ps aux'
    'env'
    # typescript
    'tsc'
)

# --------------------------------------------------------------------------
# rewrite_segment: If a command segment starts with a filterable command,
# prepend "cx filter " to it.
#
# Only rewrites the left side of pipes. Does not touch commands inside
# quotes or subshells. Trims leading whitespace for matching, preserves
# original whitespace in the output.
# --------------------------------------------------------------------------
rewrite_segment() {
    local seg="$1"
    # Trim leading whitespace for matching
    local trimmed
    trimmed=$(echo "$seg" | sed 's/^[[:space:]]*//')

    # Don't rewrite if already has cx filter
    echo "$trimmed" | grep -q '^cx filter' && { echo "$seg"; return; }

    # Don't rewrite empty segments
    [ -z "$trimmed" ] && { echo "$seg"; return; }

    # Split on first pipe — only rewrite the left side
    local left right has_pipe
    if echo "$seg" | grep -q '|'; then
        left=$(echo "$seg" | sed 's/|.*//')
        right=$(echo "$seg" | sed 's/[^|]*|/|/')
        has_pipe=1
    else
        left="$seg"
        right=""
        has_pipe=0
    fi

    local left_trimmed
    left_trimmed=$(echo "$left" | sed 's/^[[:space:]]*//')

    # Check if the left side starts with a filterable command
    local matched=0
    for pattern in "${FILTER_PATTERNS[@]}"; do
        # Match: segment starts with the pattern, followed by end-of-string,
        # whitespace, or a flag/argument
        if echo "$left_trimmed" | grep -qE "^${pattern}([[:space:]]|$)"; then
            matched=1
            break
        # Exact match (e.g., "tsc" alone)
        elif [ "$left_trimmed" = "$pattern" ]; then
            matched=1
            break
        fi
    done

    if [ "$matched" = "1" ]; then
        # Preserve leading whitespace from original segment
        local leading_ws
        leading_ws=$(echo "$left" | sed 's/[^[:space:]].*//')
        if [ "$has_pipe" = "1" ]; then
            echo "${leading_ws}cx filter ${left_trimmed}${right}"
        else
            echo "${leading_ws}cx filter ${left_trimmed}"
        fi
    else
        echo "$seg"
    fi
}

# --------------------------------------------------------------------------
# Main rewrite logic
#
# Strategy: Split the command on && ; and || delimiters, rewrite each
# segment independently, then rejoin.
#
# This uses a simple approach: replace delimiters with a unique marker,
# split on the marker, process each part, and rejoin.
# --------------------------------------------------------------------------

# We process the command by iterating through segments separated by && ; ||
# Using awk to split while preserving delimiters
REWRITTEN=""
MODIFIED=0

# Use a line-based approach: replace delimiters with newline + marker
# then process each segment
MARKER=$'\x01'

# Replace delimiters with marker-delimited tokens
# Order matters: && before &, || before |
TOKENIZED=$(echo "$COMMAND_STR" | sed \
    -e "s/&&/${MARKER}AND${MARKER}/g" \
    -e "s/||/${MARKER}OR${MARKER}/g" \
    -e "s/;/${MARKER}SEMI${MARKER}/g")

# Split on marker and process
IFS="$MARKER" read -r -a TOKENS <<< "$TOKENIZED"

RESULT=""
for token in "${TOKENS[@]}"; do
    case "$token" in
        AND)
            RESULT="${RESULT}&&"
            ;;
        OR)
            RESULT="${RESULT}||"
            ;;
        SEMI)
            RESULT="${RESULT};"
            ;;
        *)
            # This is a command segment — try to rewrite it
            REWRITTEN_SEG=$(rewrite_segment "$token")
            RESULT="${RESULT}${REWRITTEN_SEG}"
            if [ "$REWRITTEN_SEG" != "$token" ]; then
                MODIFIED=1
            fi
            ;;
    esac
done

# Only output if we actually modified something
if [ "$MODIFIED" = "1" ]; then
    # Build the output JSON that rewrites the command
    # Use jq to safely construct JSON with proper escaping
    jq -n --arg cmd "$RESULT" '{
        "tool_input": {
            "command": $cmd
        }
    }'
fi

exit 0
