---
name: task-context
description: Provides task awareness and enforces task lifecycle. Auto-loaded when discussing work, features, bugs, or implementation. Ensures tasks are created, started, and completed properly.
user-invocable: false
---

# Task Context & Lifecycle Management

You MUST track all work through Cortex tasks.

## Current Status

!`cx status 2>/dev/null`

## Tasks In Progress

!`cx ls -s progress 2>/dev/null`

## Tasks In Review

!`cx ls -s review 2>/dev/null`

## MANDATORY TASK LIFECYCLE

### Starting New Work

**ALWAYS check if a task exists first:**
```bash
cx ls | grep -i "relevant keyword"
```

**If no task exists, CREATE ONE:**
```bash
cx add "Clear, actionable title"
```

**Before writing ANY code, START the task:**
```bash
cx start CX-N
```

### During Work

**Keep task in progress while working:**
- The task status should reflect reality
- One task in progress at a time (focus)
- Add notes if needed: `cx edit CX-N`

### Completing Work

**When implementation is done:**
```bash
# If needs review
cx mv CX-N review

# If fully complete
cx done CX-N
```

**After committing:**
- Reference task ID in commit message
- Example: `git commit -m "feat: implement auth (CX-15)"`

## Task Commands Quick Reference

| Action | Command |
|--------|---------|
| List all | `cx ls` |
| List by status | `cx ls -s progress` |
| Create task | `cx add "title"` |
| Show details | `cx show CX-N` |
| Start working | `cx start CX-N` |
| Move to review | `cx mv CX-N review` |
| Complete | `cx done CX-N` |
| Edit | `cx edit CX-N` |

## Memory Context

### Recent Memories

!`cx memory ls -n 3 2>/dev/null`

### Search for Context

Before implementing, check if there are relevant learnings:
```bash
cx memory search "relevant query"
```

### Capture Learnings

At session end, capture what was learned:
```bash
echo "Task: [summary]
Work Done:
- [items]
Lessons Learned:
- [learnings]" | cx memory diary --task CX-N
```

## RULES

1. **No work without a task** - Always create a task before implementing
2. **Start before coding** - Run `cx start` before writing code
3. **Complete after finishing** - Run `cx done` when work is done
4. **One at a time** - Focus on one in-progress task
5. **Reference in commits** - Include CX-N in commit messages
6. **Search memories first** - Check `cx memory search` for past context
7. **Capture at session end** - Create diary entry with learnings
