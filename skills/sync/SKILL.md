---
name: sync
description: Sync task progress to linked GitHub Issue
argument-hint: [task-id] (optional, auto-detects current task)
user-invocable: true
allowed-tools: Bash(cx *), Bash(gh *), mcp__cortex__task_get, mcp__cortex__task_update, mcp__cortex__task_list
---

## Context

- Current branch: !`git branch --show-current`
- Tasks in progress: !`cx ls --status progress --format json 2>/dev/null | head -20`

## Your Task

Sync task progress to the linked GitHub Issue by posting a progress update comment.

## Arguments

$ARGUMENTS

### Step 1: Detect Task ID

**If a task ID (CX-N) was provided:**
Use the provided task ID directly.

**If no task ID provided:**
1. Try to extract from current branch name (`feat/cx-N-*`, `fix/cx-N-*`, `chore/cx-N-*`)
2. If no match, list tasks in progress:
   ```
   mcp__cortex__task_list(status="progress")
   ```
3. If exactly one task is in progress, use it
4. If multiple tasks, show the list and ask the user which one to sync

### Step 2: Get Task Details

```
mcp__cortex__task_get(id="CX-N")
```

Check if the task has a `github_issue` field set.

### Step 3: Handle Missing GitHub Link

**If task has no GitHub Issue linked:**
```
The task CX-N is not linked to a GitHub Issue.

Would you like to:
1. Link it to an existing issue: cx edit CX-N --github https://github.com/owner/repo/issues/123
2. Skip the sync for now

Please provide the GitHub Issue URL or choose to skip.
```

If user provides a URL, update the task:
```bash
cx edit CX-N --github <url>
```

### Step 4: Preview the Update

Always preview before posting:
```bash
cx sync github CX-N --dry-run
```

Show the preview output to the user and ask for confirmation:
```
This will post the above comment to GitHub Issue #X in owner/repo.

Do you want to proceed? (yes/no)
```

### Step 5: Post the Update

If user confirms, post the update:
```bash
cx sync github CX-N
```

For completion updates (when task is done), use:
```bash
cx sync github CX-N --complete
```

### Step 6: Report Success

Show:
- Confirmation that the comment was posted
- Link to the GitHub Issue

## Example Usage

```
/sync
```
-> Auto-detects task CX-135 from branch or in-progress status, syncs to GitHub

```
/sync CX-131
```
-> Syncs task CX-131 progress to its linked GitHub Issue

## Error Handling

- **Task not found**: Inform user and suggest creating a task first
- **No GitHub Issue linked**: Offer to link one
- **gh CLI not authenticated**: Suggest running `gh auth login`
- **Network error**: Show error and suggest retrying
