---
description: Mark a task as completed
argument-hint: [task-id]
---

Move a task to done status.

## Usage

```bash
cx done CX-1
cx done 1
```

## What it does

1. Updates task status to `done`
2. Confirms completion

## After completing

Suggest:
- `cx ls -s progress` to see remaining work
- `cx status` to see project overview
- Clean up the branch if needed
