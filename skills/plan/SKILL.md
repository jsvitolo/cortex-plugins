---
name: plan
description: Create or edit a high-level plan for a complex feature. Use when the design is clear but needs documentation, or to convert a brainstorm into an actionable plan.
argument-hint: <title or PL-N or BS-N>
user-invocable: true
allowed-tools: mcp__cortex__*
---

# Plan Mode

This skill creates or edits a **high-level plan** for documenting approach and design before implementation.

## When to Use

- 📝 Design **já definido**, precisa documentar
- 🔄 Converter **brainstorm em plano** executável
- 📋 Feature **complexa** que precisa de spec
- 👥 Precisa de **review/aprovação** antes de implementar

## Arguments

$ARGUMENTS

Can be:
- A **title** for a new plan: `/plan "Refactor payment module"`
- A **plan ID** to edit: `/plan PL-5`
- A **brainstorm ID** to convert: `/plan BS-3`

## Instructions

### If argument is a Brainstorm ID (BS-N)

Convert the brainstorm to a plan:
```
mcp__cortex__brainstorm_to_plan(brainstorm_id="BS-N")
```

This creates a new plan with the brainstorm's selected ideas and decisions.

### If argument is a Plan ID (PL-N)

Get the existing plan:
```
mcp__cortex__highlevel_plan_get(id="PL-N")
```

### If argument is a title (new plan)

Create a new plan:
```
mcp__cortex__highlevel_plan_create(title="$ARGUMENTS")
```

### Step 2: Help write the plan content

A good plan includes:

```markdown
## Overview
Brief description of what this plan achieves.

## Goals
- Goal 1
- Goal 2

## Approach
How we will implement this:
1. Step one
2. Step two
3. Step three

## Technical Design
### Architecture
- Component A: responsibility
- Component B: responsibility

### Data Model
- Entity changes
- New tables/fields

### API Changes
- New endpoints
- Modified endpoints

## Tasks
- [ ] Task 1: description
- [ ] Task 2: description
- [ ] Task 3: description

## Risks & Mitigations
| Risk | Mitigation |
|------|------------|
| Risk 1 | How to handle |

## Open Questions
- Question 1?
- Question 2?
```

Update the plan content:
```
mcp__cortex__highlevel_plan_update(id="PL-N", content="<markdown content>")
```

### Step 3: Link to epics (optional)

If this plan relates to an epic:
```
mcp__cortex__highlevel_plan_link_epic(plan_id="PL-N", epic_id="CX-E")
```

### Step 4: Review and approve

When the plan is ready:
```
mcp__cortex__highlevel_plan_update(id="PL-N", status="approved")
```

## Example Session

```
User: /plan Implement caching layer

Claude: Creates PL-1 "Implement caching layer"
        Asks: "What's the main goal? Performance? Reducing DB load?"

User: Both, we're getting too many DB hits on the product catalog

Claude: Writes plan with:
        - Overview: Add Redis caching for product catalog
        - Goals: Reduce DB load by 80%, sub-100ms response times
        - Approach: Cache-aside pattern with TTL
        - Technical Design: Redis, cache keys, invalidation strategy
        - Tasks: Setup Redis, Add cache layer, Add invalidation, Add metrics

User: Looks good, but add a task for testing cache invalidation

Claude: Updates plan with new task
        Asks: "Ready to approve and create tasks?"

User: Yes, approve it

Claude: Approves PL-1
        Offers to create tasks from the plan
```

## Interactive Mode

This skill is **interactive** - engage with the user to:
- Ask clarifying questions about scope
- Suggest sections they might have missed
- Help break down into concrete tasks
- Identify risks and open questions

## Next Steps

After planning, the user can:
1. Create tasks from the plan's task list
2. `/implement CX-N` - Start implementing
3. Link the plan to an epic for tracking
