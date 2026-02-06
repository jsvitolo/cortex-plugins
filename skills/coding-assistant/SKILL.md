---
name: coding-assistant
description: Use this skill for ALL coding work. Enforces task tracking, memory usage, and proper workflow using Cortex MCP tools. MUST be used when implementing features, fixing bugs, or any development work.
user-invocable: false
---

# Cortex Coding Assistant

You MUST use **Cortex MCP tools** (`mcp__cortex__*`) for all operations. Prefer MCP tools over Bash commands.

## Current Project Status

!`cx status 2>/dev/null`

## Active Tasks

!`cx ls -s progress 2>/dev/null`

## MANDATORY RULES - MCP-First Approach

**CRITICAL:** Always prefer Cortex MCP tools over Bash commands and generic Claude tools.

### 1. Task Management - Use MCP tools

| Task | Use This (MCP) | NOT This (Bash) |
|------|----------------|-----------------|
| Create task | `mcp__cortex__task_create` | `cx add` |
| Start task | `mcp__cortex__task_update(status="progress")` | `cx start` |
| Complete task | `mcp__cortex__task_update(status="done")` | `cx done` |
| Move task | `mcp__cortex__task_update(status="...")` | `cx mv` |
| List tasks | `mcp__cortex__task_list` | `cx ls` |
| Get task | `mcp__cortex__task_get` | `cx show` |
| Task history | `mcp__cortex__task_log` | `cx log` |

**Example - Task workflow:**
```
# ✅ CORRECT: Use MCP
mcp__cortex__task_create(title="Add new feature", type="feature")
mcp__cortex__task_update(id="CX-69", status="progress")
# ... do work ...
mcp__cortex__task_update(id="CX-69", status="done")

# ❌ WRONG: Bash commands
Bash("cx add 'Add new feature'")
Bash("cx start CX-69")
Bash("cx done CX-69")
```

#### Task MCP Tools Reference

| Tool | Parameters | Purpose |
|------|------------|---------|
| `task_create` | `title`, `type?`, `description?` | Create new task |
| `task_update` | `id`, `status?`, `title?`, `description?` | Update task |
| `task_get` | `id` | Get task details |
| `task_list` | `status?`, `level?` | List tasks |
| `task_log` | `task_id`, `limit?` | Get task event history |

### 2. Memory System - Use MCP tools

| Task | Use This (MCP) | NOT This (Bash) |
|------|----------------|-----------------|
| List memories | `mcp__cortex__memory_list` | `cx memory ls` |
| Save memory | `mcp__cortex__memory_save` | `cx memory diary` |
| Search memories | `mcp__cortex__memory_list(search="...")` | `cx memory search` |

**Example - Memory workflow:**
```
# ✅ CORRECT: Use MCP
mcp__cortex__memory_list(search="authentication")
mcp__cortex__memory_save(content="Learned that...", task_id="CX-69")

# ❌ WRONG: Bash commands
Bash("cx memory search 'authentication'")
Bash("cx memory diary --task CX-69")
```

### 3. Code Operations - Use LSP tools

| Task | Use This (MCP) | NOT This |
|------|----------------|----------|
| Find functions/classes | `lsp_symbols` | Grep for "func " |
| Find symbol definition | `lsp_definition` | Grep + Read |
| Find all usages | `lsp_references` | Grep for symbol name |
| Get type/docs info | `lsp_hover` | Read + guess |
| Rewrite function | `lsp_replace_symbol` | Edit with old/new |
| Rename symbol | `lsp_rename_symbol` | Multiple Edit calls |
| Read function source | `lsp_get_symbol_source` | Read with line numbers |
| Insert code | `lsp_insert_after/before_symbol` | Edit |
| Delete symbol | `lsp_delete_symbol` | Edit to remove |

**Example - Code workflow:**
```
# ✅ CORRECT: Use LSP
mcp__cortex__lsp_symbols(file="internal/mcp/server.go")
mcp__cortex__lsp_get_symbol_source(file="...", symbol_name="NewServer")
mcp__cortex__lsp_replace_symbol(file="...", symbol_name="NewServer", new_body="...")

# ❌ WRONG: Generic tools
Grep(pattern="func NewServer")
Read(file_path="...", offset=100, limit=20)
Edit(file_path="...", old_string="...", new_string="...")
```

#### LSP Tools Reference

| Tool | Purpose |
|------|---------|
| `lsp_status` | Check active language servers |
| `lsp_symbols` | List all symbols in a file |
| `lsp_definition` | Go to definition |
| `lsp_references` | Find all references |
| `lsp_hover` | Get type info and docs |
| `lsp_get_symbol_source` | Get full source code of symbol |
| `lsp_replace_symbol` | Replace entire symbol body |
| `lsp_rename_symbol` | Rename symbol across project |
| `lsp_insert_after_symbol` | Insert code after a symbol |
| `lsp_insert_before_symbol` | Insert code before a symbol |
| `lsp_delete_symbol` | Delete a symbol |

### 4. Thinking Tools - Pause and Reflect

**IMPORTANT:** Use thinking tools to pause and reflect at key moments. These help prevent mistakes and keep you focused.

| Tool | When to Call |
|------|--------------|
| `think_about_collected_information` | After gathering info (searching, reading symbols) |
| `think_about_task_adherence` | Before making significant code changes |
| `think_about_whether_you_are_done` | When you believe the task is complete |

**Example - Using thinking tools:**
```
# After exploring codebase
mcp__cortex__lsp_symbols(file="...")
mcp__cortex__lsp_references(...)
mcp__cortex__think_about_collected_information()  # ← Pause to reflect

# Before editing
mcp__cortex__think_about_task_adherence()  # ← Verify alignment
mcp__cortex__lsp_replace_symbol(...)

# When finishing
mcp__cortex__think_about_whether_you_are_done()  # ← Verify completion
mcp__cortex__task_update(id="CX-N", status="done")
```

#### When to use each thinking tool

**`think_about_collected_information`** - Call after:
- Multiple `lsp_symbols`, `lsp_references`, or `lsp_get_symbol_source` calls
- Exploring unfamiliar parts of the codebase
- Before starting implementation

**`think_about_task_adherence`** - Call before:
- Making significant code changes
- In long conversations with many back-and-forths
- When scope seems to be expanding

**`think_about_whether_you_are_done`** - Call when:
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
| Create task | `task_create(title="...")` | Before starting new work |
| Start task | `task_update(id="CX-N", status="progress")` | When beginning implementation |
| Complete task | `task_update(id="CX-N", status="done")` | When task is finished |
| List tasks | `task_list(status="progress")` | Check current work |
| Search memories | `memory_list(search="...")` | Before implementing |
| Save learning | `memory_save(content="...")` | At session end |
| Check LSP | `lsp_status()` | Before code operations |
| Find symbols | `lsp_symbols(file="...")` | When exploring code |
| Read function | `lsp_get_symbol_source(...)` | Before editing |
| Edit function | `lsp_replace_symbol(...)` | When modifying code |
| Rename symbol | `lsp_rename_symbol(...)` | When refactoring |

## NEVER DO THIS

- Never use `Bash("cx add ...")` when `task_create` works
- Never use `Bash("cx start/done ...")` when `task_update` works
- Never use `Bash("cx memory ...")` when `memory_list/save` works
- Never use `Edit` for function changes when `lsp_replace_symbol` works
- Never use `Grep` for finding functions when `lsp_symbols` works
- Never use `Read` to find function source when `lsp_get_symbol_source` works
- Never rename manually when `lsp_rename_symbol` works
- Never use markdown TODOs instead of `task_create`
- Never forget to set task to `progress` before working
- Never forget to set task to `done` after completing
