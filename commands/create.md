---
description: Create a new task
argument-hint: [title] [-t type] [-p priority] [-d description]
---

Create a new Cortex task.

## Usage

```bash
cx add "Task title"
cx add "Fix login bug" -t bug -p 1
cx add "Add dark mode" -t feature -p 2 -d "Support system theme"
```

## Arguments

- `title`: Task title (required)
- `-t, --type`: Task type (feature, bug, chore) - default: feature
- `-p, --priority`: Priority 1-5 (1 is highest) - default: 3
- `-d, --description`: Task description

## Task IDs

Tasks are assigned sequential IDs like CX-1, CX-2, etc.

After creating a task, show the task ID and suggest:
- `cx start CX-N` to begin working
- `cx show CX-N` to see details
- `cx ui` to open the kanban board
