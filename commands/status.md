---
description: Show project status overview with live task data
argument-hint:
disable-model-invocation: true
---

Show Cortex project status with task counts by status.

## Current Status

!`cx status 2>/dev/null || echo "Cortex not initialized. Run: cx init"`

## Active Work

!`cx ls -s progress 2>/dev/null || echo "No tasks in progress"`

## Quick Actions

- `cx ls -s progress` - See active work details
- `cx ls -s backlog` - See pending tasks
- `cx ui` - Open the kanban board
- `cx add "title"` - Create a new task
