---
name: memory-system
description: Capture session learnings, search past context, generate rules. Use at session end to save insights, or to recall previous decisions and patterns.
argument-hint: [action] [query or context]
user-invocable: true
allowed-tools: Bash(cx:*)
---

# Memory System

Cortex memory captures learnings across sessions: diary entries, reflections, and rules.

## Current Memory Status

!`cx memory stats 2>/dev/null`

## Recent Memories

!`cx memory ls -n 5 2>/dev/null`

## Action Requested

$ARGUMENTS

## Available Commands

### Create Diary Entry (Session Capture)

Capture what was learned in this session:

```bash
# Pipe structured context
echo "Task: [what was worked on]
Work Done:
- [item 1]
- [item 2]

Design Decisions:
- [decision 1]

Lessons Learned:
- [learning 1]" | cx memory diary --task CX-N
```

### Search Memories

Find relevant past context:

```bash
cx memory search "query"
```

### Create Reflection

Analyze patterns across diary entries:

```bash
cx memory reflect              # Last 7 days
cx memory reflect --since 2024-01-01
```

### Generate Rules

Create CLAUDE.md rules from patterns:

```bash
cx memory rules
cx memory rules --min-strength strong
```

### Export Rules to CLAUDE.md

```bash
cx memory export               # Updates CLAUDE.md
```

### View Memory Details

```bash
cx memory show mem-xxx
```

## Workflow

```
Session Work → Diary Entry → Reflection → Rules → CLAUDE.md
```

1. **During work**: Observe patterns, decisions, learnings
2. **Session end**: Create diary with `cx memory diary`
3. **Periodically**: Run `cx memory reflect` to find patterns
4. **When patterns emerge**: Run `cx memory rules` and `cx memory export`

## Memory Types

| Type | Purpose | Command |
|------|---------|---------|
| diary | Session capture | `cx memory diary` |
| reflection | Pattern analysis | `cx memory reflect` |
| rule | CLAUDE.md rules | `cx memory rules` |

## Best Practices

1. **Capture frequently** - Create diary entries at end of significant work
2. **Be specific** - Include concrete decisions and reasons
3. **Link to tasks** - Use `--task CX-N` to associate with work
4. **Search first** - Check `cx memory search` before asking questions
5. **Reflect weekly** - Run reflection to identify emerging patterns
