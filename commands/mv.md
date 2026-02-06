---
description: Move a task to a different status
argument-hint: [task-id] [status]
---

Move a task to a specific status.

## Usage

```bash
cx mv CX-1 review
cx mv 1 backlog
cx mv CX-2 progress
```

## Valid statuses

- `backlog` - Not started
- `progress` - In progress
- `review` - Under review
- `done` - Completed

## Examples

```bash
# Send back to backlog
cx mv CX-1 backlog

# Move to review
cx mv CX-1 review

# Complete
cx mv CX-1 done
```
