---
description: Show detailed information about a task with live data
argument-hint: [task-id]
disable-model-invocation: true
---

Display detailed information about a Cortex task.

## Task Details

!`cx show $ARGUMENTS 2>/dev/null || echo "Task not found. Use: cx ls to see available tasks"`

## Usage

```bash
cx show CX-1
cx show 1
```

Task IDs can be provided with or without the CX- prefix.

## Next Actions

Based on task status:
- **backlog**: `cx start CX-N` to begin working
- **progress**: `cx done CX-N` when complete
- **review**: `cx mv CX-N done` to close
