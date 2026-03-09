---
name: brainstorm
description: Start a brainstorming session to explore ideas before committing to a plan. Use when the solution isn't clear, there are multiple approaches, or you need to explore trade-offs.
argument-hint: <title>
user-invocable: true
allowed-tools: mcp__cortex__*
---

# Brainstorm Mode

This skill starts an **interactive brainstorming session** to explore ideas before committing to implementation.

## When to Use

- 🧠 Feature nova **sem design claro**
- 🤔 **Múltiplas abordagens** possíveis
- ⚖️ Precisa **explorar trade-offs**
- 💡 Quer **capturar ideias** antes de decidir

## Arguments

$ARGUMENTS

## Instructions

### Step 1: Create the brainstorm session

```
mcp__cortex__brainstorm(action="create", title="$ARGUMENTS", description="Exploring approaches for: $ARGUMENTS")
```

This returns a brainstorm ID (BS-N).

### Step 2: Guide the exploration

Help the user explore by:

1. **Suggesting initial ideas** based on the title
2. **Adding ideas** as the user discusses options:
   ```
   mcp__cortex__brainstorm(action="add_idea", id="BS-N", content="Idea description")
   ```

3. **Adding pros/cons** to each idea:
   ```
   mcp__cortex__brainstorm(action="add_idea", id="BS-N", content="OAuth2", pros=["Industry standard", "Delegated auth"], cons=["Complex setup", "External dependency"])
   ```

4. **Voting** on ideas as preferences emerge:
   ```
   mcp__cortex__brainstorm(action="vote_idea", idea_id="<id>", vote=1)  # +1 or -1
   ```

5. **Selecting** the winning ideas:
   ```
   mcp__cortex__brainstorm(action="select_idea", idea_id="<id>", selected=true)
   ```

### Step 3: Capture decisions

As the user makes decisions, record them:
```
mcp__cortex__brainstorm(action="add_decision", id="BS-N", decision="We will use OAuth2 with Google provider")
```

### Step 4: Add references (optional)

If external resources are discussed:
```
mcp__cortex__brainstorm(action="add_ref", id="BS-N", url="https://...", title="OAuth2 Best Practices")
```

### Step 5: Convert to Plan (when ready)

When the user is ready to move forward:
```
mcp__cortex__brainstorm(action="to_plan", id="BS-N")
```

This creates a Plan (PL-N) with:
- Selected ideas as the approach
- Decisions documented
- References linked

## Example Session

```
User: /brainstorm Authentication system

Claude: Creates BS-1 "Authentication system"
        Suggests ideas: OAuth2, JWT, Session-based, Passwordless

User: I like OAuth2 and JWT, what are the trade-offs?

Claude: Adds pros/cons to both ideas
        OAuth2: + delegated, + secure | - complex, - external
        JWT: + stateless, + scalable | - token size, - no revocation

User: Let's go with OAuth2 for external users, JWT for API

Claude: Votes +1 on OAuth2 and JWT
        Selects both as winning ideas
        Adds decision: "Hybrid approach: OAuth2 for web, JWT for API"

User: Ok, let's plan this out

Claude: Converts BS-1 to PL-1
        Shows plan with approach and decisions
```

## Interactive Mode

This skill is **interactive** - engage with the user to:
- Ask clarifying questions about requirements
- Suggest ideas they might not have considered
- Help evaluate trade-offs objectively
- Guide towards a decision when ready

## Next Steps

After brainstorm, the user can:
1. `/plan BS-N` - Continue editing the generated plan
2. `cx add "Task" --type feature` - Create tasks from the plan
3. `/implement CX-N` - Implement the tasks
