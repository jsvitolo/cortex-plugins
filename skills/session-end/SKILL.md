---
name: session-end
description: Capture session learnings before ending work. Use when user says goodbye, is done for the day, or explicitly asks to save session context.
argument-hint: [optional task-id]
user-invocable: true
allowed-tools: Bash(cx:*)
---

# Session End - Capture Learnings

Before ending this session, let's capture what was learned.

## Current Task Context

!`cx ls -s progress 2>/dev/null | head -5`

## Session Summary Template

Based on the work done in this session, I'll create a diary entry:

```
Task: [Summary of what was worked on]

Work Done:
- [Main accomplishments]

Design Decisions:
- [Key technical decisions made]

Challenges:
- [Problems encountered]

Solutions:
- [How challenges were solved]

Lessons Learned:
- [Key takeaways for future sessions]

Preferences:
- [User preferences observed]
```

## Capture Command

After filling the template, run:

```bash
echo "Task: ...
Work Done:
- ...

Design Decisions:
- ...

Lessons Learned:
- ..." | cx memory diary --task CX-N
```

## Post-Capture

After creating the diary:

1. Check if patterns are emerging:
   ```bash
   cx memory reflect
   ```

2. If strong patterns exist, generate rules:
   ```bash
   cx memory rules --min-strength pattern
   ```

## Quick Capture

For a quick capture without full template:

```bash
echo "Task: [brief summary]
Lessons Learned:
- [main takeaway]" | cx memory diary
```
