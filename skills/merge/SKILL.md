---
description: Merge PR and move Cortex task to done
allowed-tools: mcp__cortex__git_merge
---

## Context

- Current branch: !`git branch --show-current`
- PR for current branch: !`gh pr view --json number,title,state 2>/dev/null || echo "No PR found"`

## Your Task

Merge the Pull Request using the Cortex MCP tool.

### Step 1: Verify PR Exists

Check the context above. If no PR exists for the current branch:
- Inform the user
- Suggest running `/pr` first to create one

### Step 2: Merge with MCP

Use the Cortex MCP tool to merge:

```
mcp__cortex__git_merge()
```

This single command will:
- Squash merge the PR (clean git history)
- Delete the remote branch
- Checkout main locally
- Pull latest changes
- Detect task ID from branch name
- Automatically move task to `done` status

### Step 3: Report Success

Show the merge confirmation and task status update.

**IMPORTANT:**
- The MCP tool handles everything automatically
- If merge fails due to conflicts or checks, the error will be returned
- No need to manually update task status - it's done automatically
