---
description: Create PR and move Cortex task to review
allowed-tools: Bash(git status:*), Bash(git add:*), Bash(git commit:*), mcp__cortex__git_pr
---

## Context

- Current branch: !`git branch --show-current`
- Git status: !`git status --short`

## Your Task

Create a Pull Request using the Cortex MCP tool.

### Step 1: Check for Uncommitted Changes

If there are uncommitted changes (from git status):
1. Show the changes to the user
2. Ask if they want to commit them first
3. If yes, stage and commit with an appropriate message

### Step 2: Create PR with MCP

Use the Cortex MCP tool to create the PR:

```
mcp__cortex__git_pr()
```

This single command will:
- Detect task ID from branch name (feat/cx-N-* → CX-N)
- Push the branch to origin
- Create a GitHub PR with title and body from task info
- Automatically move task to `review` status

### Step 3: Report Success

Show the PR URL returned by the tool.

**IMPORTANT:**
- Always check for uncommitted changes FIRST
- The MCP tool handles everything else automatically
- If PR already exists, inform the user with the existing PR URL
