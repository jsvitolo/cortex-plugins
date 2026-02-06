---
description: Start working on a task
argument-hint: [task-id]
---

Move a task to in_progress status and generate a branch name.

## Usage

```bash
cx start CX-1
cx start 1
```

## What it does

1. Updates task status to `in_progress`
2. Generates a git branch name based on task type and title
3. Shows the suggested branch name

## After starting

Suggest:
- Create the branch: `git checkout -b <branch-name>`
- Open the TUI: `cx ui` to see the kanban board
- When done: `cx done CX-N`
