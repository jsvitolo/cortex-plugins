---
description: List tasks with optional filters
argument-hint: [-s status] [-t type] [--search text]
---

List Cortex tasks with optional filtering.

## Usage

```bash
cx ls
cx ls -s progress
cx ls -t bug
cx ls --search "auth"
```

## Filters

- `-s, --status`: Filter by status (backlog, progress, review, done)
- `-t, --type`: Filter by type (feature, bug, chore)
- `--search`: Search in title and description

## Output

Shows a table with:
- ID (CX-N)
- Status
- Type
- Priority
- Title

Suggest `cx show CX-N` for full details or `cx ui` for the kanban board.
