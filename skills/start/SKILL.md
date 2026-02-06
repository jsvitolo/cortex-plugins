---
description: Start working on a task - creates branch and moves to progress
allowed-tools: mcp__cortex__git_branch, mcp__cortex__task_update, mcp__cortex__task_get
argument-hint: CX-N
---

## Your Task

Start working on a Cortex task using MCP tools.

**Task ID:** $ARGUMENTS

### Step 1: Get Task Info

First, get the task details:
```
mcp__cortex__task_get(id="$ARGUMENTS")
```

If task not found, inform the user.

### Step 2: Create Branch from Updated Main

Use the Cortex MCP tool to create a feature branch:

```
mcp__cortex__git_branch(task_id="$ARGUMENTS")
```

This single command will:
- Checkout main and pull latest
- Create branch: `feat/cx-N-task-slug` (or `fix/` for bugs)
- Checkout the new branch

### Step 3: Move Task to Progress

```
mcp__cortex__task_update(id="$ARGUMENTS", status="progress")
```

### Step 4: Report Success

Show:
- Task title and ID
- Branch name created
- Next steps hint: "Ready to code! When done, run /pr"

**IMPORTANT:**
- The git_branch tool handles updating main automatically
- Task status is updated AFTER branch is created successfully
- If branch creation fails, don't update task status
