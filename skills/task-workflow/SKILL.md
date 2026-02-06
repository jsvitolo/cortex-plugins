---
name: task-workflow
description: Manage task lifecycle - create, start, complete tasks. Use when beginning new work, tracking progress, or completing features. Ensures proper task hygiene.
argument-hint: [action] [task-id or title]
disable-model-invocation: true
allowed-tools: Bash(cx:*)
---

# Task Workflow Manager

Manage the complete task lifecycle with Cortex.

## Current Status

!`cx status 2>/dev/null`

## Action Requested

$ARGUMENTS

## Available Actions

### Create a New Task
```bash
cx add "Task title"
```

### Start Working on a Task
```bash
cx start CX-N
```

### Move Task to Review
```bash
cx mv CX-N review
```

### Complete a Task
```bash
cx done CX-N
```

### Show Task Details
```bash
cx show CX-N
```

### Edit a Task
```bash
cx edit CX-N
```

## Task States

```
backlog → progress → review → done
```

## Workflow Rules

1. **One task in progress at a time** - Focus on completing current work
2. **Create before coding** - Always create a task before starting work
3. **Update status promptly** - Move tasks as work progresses
4. **Add context** - Use task descriptions and notes for future reference
