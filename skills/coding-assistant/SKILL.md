---
name: coding-assistant
description: Use this skill for ALL coding work. Enforces task tracking, memory usage, and proper workflow using Cortex MCP tools. MUST be used when implementing features, fixing bugs, or any development work.
user-invocable: false
---

# Cortex Coding Assistant

You MUST use **Cortex MCP tools** (`mcp__cortex__*`) for all operations. Prefer MCP tools over Bash commands.

## Current Project Status

!`cx status 2>/dev/null || echo "Run: cx init"`

## Active Tasks

!`cx ls -s progress 2>/dev/null`

## MANDATORY RULES - MCP-First Approach

**CRITICAL:** Always prefer Cortex MCP tools over Bash commands and generic Claude tools.

### 1. Task Management - Use MCP tools

| Task | Use This (MCP) | NOT This (Bash) |
|------|----------------|-----------------|
| Create task | `mcp__cortex__task(action="create")` | `cx add` |
| Start task | `mcp__cortex__task(action="update", status="progress")` | `cx start` |
| Complete task | `mcp__cortex__task(action="update", status="done")` | `cx done` |
| Move task | `mcp__cortex__task(action="update", status="...")` | `cx mv` |
| List tasks | `mcp__cortex__task(action="list")` | `cx ls` |
| Get task | `mcp__cortex__task(action="get")` | `cx show` |

**Example - Task workflow:**
```
# ✅ CORRECT: Use MCP
mcp__cortex__task(action="create", title="Add new feature", type="feature")
mcp__cortex__task(action="update", id="CX-69", status="progress")
# ... do work ...
mcp__cortex__task(action="update", id="CX-69", status="done")

# ❌ WRONG: Bash commands
Bash("cx add 'Add new feature'")
Bash("cx start CX-69")
Bash("cx done CX-69")
```

#### Task MCP Tools Reference

| Tool | Parameters | Purpose |
|------|------------|---------|
| `task(action="create")` | `title`, `type?`, `description?` | Create new task |
| `task(action="update")` | `id`, `status?`, `title?`, `description?` | Update task |
| `task(action="get")` | `id` | Get task details |
| `task(action="list")` | `status?`, `level?` | List tasks |

### 2. Memory System - Use MCP tools

| Task | Use This (MCP) | NOT This (Bash) |
|------|----------------|-----------------|
| List memories | `mcp__cortex__memory(action="list")` | `cx memory ls` |
| Save memory | `mcp__cortex__memory(action="save")` | `cx memory diary` |
| Search memories | `mcp__cortex__memory(action="list", search="...")` | `cx memory search` |

**Example - Memory workflow:**
```
# ✅ CORRECT: Use MCP
mcp__cortex__memory(action="list", search="authentication")
mcp__cortex__memory(action="save", content="Learned that...", task_id="CX-69")

# ❌ WRONG: Bash commands
Bash("cx memory search 'authentication'")
Bash("cx memory diary --task CX-69")
```

### 3. Code Operations - Use LSP tools

| Task | Use This (MCP) | NOT This |
|------|----------------|----------|
| Find functions/classes | `lsp(action="symbols")` | Grep for "func " |
| Find symbol definition | `lsp(action="definition")` | Grep + Read |
| Find all usages | `lsp(action="references")` | Grep for symbol name |
| Get type/docs info | `lsp(action="hover")` | Read + guess |
| Rewrite function | `lsp_edit(action="replace")` | Edit with old/new |
| Rename symbol | `lsp_edit(action="rename")` | Multiple Edit calls |
| Search workspace | `lsp(action="workspace_search")` | Grep |

**Example - Code workflow:**
```
# ✅ CORRECT: Use LSP
mcp__cortex__lsp(action="symbols", file="internal/mcp/server.go")
mcp__cortex__lsp(action="hover", file="...", line=10, column=5)
mcp__cortex__lsp_edit(action="replace", file="...", symbol_name="NewServer", new_body="...")

# ❌ WRONG: Generic tools
Grep(pattern="func NewServer")
Read(file_path="...", offset=100, limit=20)
Edit(file_path="...", old_string="...", new_string="...")
```

#### LSP Tools Reference

| Tool | Purpose |
|------|---------|
| `lsp(action="symbols")` | List all symbols in a file |
| `lsp(action="workspace_search")` | Global symbol search |
| `lsp(action="definition")` | Go to definition |
| `lsp(action="references")` | Find all references |
| `lsp(action="hover")` | Get type info and docs |
| `lsp_edit(action="replace")` | Replace entire symbol body |
| `lsp_edit(action="rename")` | Rename symbol across project |

### 4. Thinking Tools - Pause and Reflect

**IMPORTANT:** Use thinking tools to pause and reflect at key moments. These help prevent mistakes and keep you focused.

| Tool | When to Call |
|------|--------------|
| `think(action="collected_information")` | After gathering info (searching, reading symbols) |
| `think(action="task_adherence")` | Before making significant code changes |
| `think(action="whether_done")` | When you believe the task is complete |

**Example - Using thinking tools:**
```
# After exploring codebase
mcp__cortex__lsp(action="symbols", file="...")
mcp__cortex__lsp(action="references", ...)
mcp__cortex__think(action="collected_information")  # ← Pause to reflect

# Before editing
mcp__cortex__think(action="task_adherence")  # ← Verify alignment
mcp__cortex__lsp_edit(action="replace", ...)

# When finishing
mcp__cortex__think(action="whether_done")  # ← Verify completion
mcp__cortex__task(action="update", id="CX-N", status="done")
```

#### When to use each thinking tool

**`think(action="collected_information")`** - Call after:
- Multiple `lsp(action="symbols")` or `lsp(action="references")` calls
- Exploring unfamiliar parts of the codebase
- Before starting implementation

**`think(action="task_adherence")`** - Call before:
- Making significant code changes
- In long conversations with many back-and-forths
- When scope seems to be expanding

**`think(action="whether_done")`** - Call when:
- You believe the task is complete
- Before marking task as done
- After implementing a feature

### 5. When to use Bash/Generic tools (fallback only)

Use Bash with `cx` commands only when:
- MCP server is not available
- Need interactive prompts (cx ui, cx memory reflect)
- Running git commands
- Running build/test commands

Use generic tools (Edit, Read, Grep) only when:
- File doesn't have LSP support (markdown, yaml, json, etc.)
- Need to search across ALL files (use Grep, then LSP for editing)
- LSP server not available (check with `lsp_status`)
- Editing non-code content (comments, strings, config)

### 6. Workflow Summary

| Action | MCP Tool | When |
|--------|----------|------|
| Create task | `task(action="create", title="...")` | Before starting new work |
| Start task | `task(action="update", id="CX-N", status="progress")` | When beginning implementation |
| Complete task | `task(action="update", id="CX-N", status="done")` | When task is finished |
| List tasks | `task(action="list", status="progress")` | Check current work |
| Search memories | `memory(action="list", search="...")` | Before implementing |
| Save learning | `memory(action="save", content="...")` | At session end |
| Find symbols | `lsp(action="symbols", file="...")` | When exploring code |
| Edit function | `lsp_edit(action="replace", ...)` | When modifying code |
| Rename symbol | `lsp_edit(action="rename", ...)` | When refactoring |

## NEVER DO THIS

- Never use `Bash("cx add ...")` when `task(action="create")` works
- Never use `Bash("cx start/done ...")` when `task(action="update")` works
- Never use `Bash("cx memory ...")` when `memory(action="list/save")` works
- Never use `Edit` for function changes when `lsp_edit(action="replace")` works
- Never use `Grep` for finding functions when `lsp(action="symbols")` works
- Never rename manually when `lsp_edit(action="rename")` works
- Never use markdown TODOs instead of `task_create`
- Never forget to set task to `progress` before working
- Never forget to set task to `done` after completing
