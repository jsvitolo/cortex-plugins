---
description: Show the mandatory Cortex workflow rules for tasks and memory management
argument-hint:
disable-model-invocation: true
---

# Cortex Workflow Rules

## Current Status

!`cx status 2>/dev/null`

## Active Work

!`cx ls -s progress 2>/dev/null || echo "No tasks in progress - create one with: cx add \"title\""`

---

## Task Lifecycle (MANDATORY)

```
┌─────────────────────────────────────────────────────────────┐
│  1. CREATE TASK      cx add "description"                   │
│         ↓                                                   │
│  2. START TASK       cx start CX-N                          │
│         ↓                                                   │
│  3. DO THE WORK      (write code, tests, docs)              │
│         ↓                                                   │
│  4. COMPLETE TASK    cx done CX-N                           │
└─────────────────────────────────────────────────────────────┘
```

## Memory Management

```
┌─────────────────────────────────────────────────────────────┐
│  1. SEARCH CONTEXT   cx memory search "topic"               │
│         ↓                                                   │
│  2. CAPTURE LEARNING cx memory diary "what I learned"       │
└─────────────────────────────────────────────────────────────┘
```

## Quick Reference

| Action | Command |
|--------|---------|
| Create task | `cx add "title"` |
| Start task | `cx start CX-N` |
| Complete task | `cx done CX-N` |
| Move task | `cx mv CX-N review` |
| Search memories | `cx memory search "query"` |
| Save learning | `cx memory diary "content"` |
| Project status | `cx status` |

## Rules

1. **No coding without a task** - Always `cx add` first
2. **Start before working** - Always `cx start CX-N`
3. **Complete when done** - Always `cx done CX-N`
4. **Capture learnings** - Use `cx memory diary` after sessions
5. **Search before asking** - Check `cx memory search` first
