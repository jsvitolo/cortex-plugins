---
name: implement
description: Execute the 3-agent workflow (research → implement → verify) for coding tasks. Use for ALL feature implementations, bug fixes, and code changes. Spawns autonomous agents that research, implement, and verify changes.
argument-hint: <task-id or description>
user-invocable: true
allowed-tools: Task, mcp__cortex__*
---

# Agent Workflow Executor

This skill executes the **3-agent autonomous workflow** for coding tasks.

## Workflow

```
research → implement → verify → done
```

| Agent | Purpose |
|-------|---------|
| **research** | Understand codebase, search memories, create plan |
| **implement** | Write code following the plan |
| **verify** | Run tests, review code, complete task |

## Arguments

$ARGUMENTS

## Instructions

### Step 1: Ensure task exists

If a task ID (CX-N) was provided, get the task:
```
mcp__cortex__task_get(id="CX-N")
```

If a description was provided, create a task first:
```
mcp__cortex__task_create(title="<description>", type="feature|bug|chore")
```

### Step 2: Start the agent workflow

Spawn the research agent to begin:
```
mcp__cortex__agent_spawn(task_id="CX-N", agent_name="research")
```

This returns a **prompt** and **session_id**.

### Step 3: Execute the research agent

Use the Task tool with the prompt from agent_spawn:
```
Task(
  subagent_type="research",
  prompt="<prompt from agent_spawn>",
  run_in_background=false
)
```

The research agent will:
- Search memories for relevant context
- Explore the codebase
- Create an implementation plan
- Call `agent_report` when done

### Step 4: Continue the chain

When the agent completes and calls `agent_report`, check the response:
- If `next_action.action == "spawn_agent"`, execute the next agent
- If `next_action.action == "workflow_complete"`, the task is done

### Step 5: Repeat for implement and verify

Execute each agent's prompt using the Task tool until workflow is complete.

## Example Usage

```
/implement CX-104
```
→ Executes full workflow for task CX-104

```
/implement Add user authentication
```
→ Creates task, then executes full workflow

## Monitoring Progress

Check agent sessions:
```
mcp__cortex__agent_sessions(task_id="CX-N")
```

## Important Notes

- Each agent is autonomous and will complete its phase
- Agents save memories and update task status automatically
- The workflow handles the full cycle: research → implement → verify
- Task is marked as `done` when verify completes
