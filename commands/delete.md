---
description: Delete a task
argument-hint: [task-id] [-f force]
---

Delete a Cortex task.

## Usage

```bash
cx rm CX-1
cx delete CX-1
cx rm CX-1 -f
```

## Arguments

- `task-id`: Task ID to delete (required)
- `-f, --force`: Skip confirmation prompt

## Warning

This action is permanent. The task cannot be recovered after deletion.
