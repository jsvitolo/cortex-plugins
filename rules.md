# Cortex Project Rules

## Rule 1: Use `/implement` for ALL coding tasks

When the user asks to implement, fix, add, or change code:

1. **ALWAYS** use the `/implement` skill
2. **NEVER** start coding directly without the agent workflow
3. **NEVER** skip the research phase

### Trigger words that REQUIRE `/implement`:

- "implement", "implementar", "implementa"
- "add feature", "adicionar", "adiciona"
- "fix bug", "corrigir", "corrige", "fix"
- "refactor", "refatorar"
- "create", "criar" (when referring to code)
- "build", "construir"
- "write code", "escrever código"

### Example responses:

**User:** "Add a logout button"
**Claude:** Uses `/implement Add logout button`

**User:** "Fix the authentication bug"
**Claude:** Uses `/implement CX-N` (if task exists) or `/implement Fix authentication bug`

**User:** "Implement dark mode"
**Claude:** Uses `/implement Implement dark mode`

### Exceptions (do NOT use `/implement`):

- Answering questions about code
- Explaining how something works
- Small documentation updates
- Typo fixes in non-code files
- Configuration changes

## Rule 2: MCP-First Approach

Always prefer Cortex MCP tools over Bash commands:

| Action | Use This | NOT This |
|--------|----------|----------|
| Create task | `mcp__cortex__task(action="create")` | `cx add` |
| Update task | `mcp__cortex__task(action="update")` | `cx start/done/mv` |
| Search memory | `mcp__cortex__memory(action="list", search=...)` | `cx memory search` |
| Save memory | `mcp__cortex__memory(action="save")` | `cx memory diary` |

## Rule 3: Task Tracking

- Every piece of work needs a Cortex task (CX-N)
- Tasks are created via MCP tools, not internal Claude tasks
- Status updates go through MCP: `mcp__cortex__task(action="update", status="progress|done")`

## Rule 4: Code Graph — Use for Code Understanding

If the project has a built code graph (`codegraph:status` shows nodes > 0), use it:

### Research phase — FIRST STEP:
```
# Ultra-compact overview (~100 tokens) — ALWAYS call this first
mcp__cortex__codegraph(action="context", task="what you are doing")

# Find symbols by name (substring match)
mcp__cortex__codegraph(action="query", name="SymbolName")

# Understand dependencies
mcp__cortex__codegraph(action="edges", node_id="cn-xxx")

# Check blast radius before changes
mcp__cortex__codegraph(action="impact", node_id="cn-xxx")
```

### Before PR / code review:
```
# Get review hints
mcp__cortex__codegraph(action="review_hints", since="HEAD")

# Risk-scored changes
mcp__cortex__codegraph(action="detect_changes", since="HEAD")
```

### Build / maintain the graph:
```
mcp__cortex__codegraph(action="build")     # first time (full)
mcp__cortex__codegraph(action="update")    # after changes (incremental)
```

### Additional analysis:
```
mcp__cortex__codegraph(action="dead_code")          # unreferenced symbols
mcp__cortex__codegraph(action="communities")         # module structure
mcp__cortex__codegraph(action="refactor")            # refactoring suggestions
mcp__cortex__codegraph(action="rename_preview", node_id="cn-xxx", new_name="NewName")
mcp__cortex__codegraph(action="visualize")           # D3.js HTML graph
mcp__cortex__codegraph(action="wiki")                # markdown docs
```

Supported languages: Go, Elixir, TypeScript, Rust, Python

## Rule 5: Learnings System - Continuous Improvement

Cortex has a learnings system that automatically extracts success/failure patterns.

### How it works:

1. **Automatic extraction**: When `cx done` or agents complete tasks with extreme reward (≥80% or ≤40%), the system extracts learnings via GPT-4o-mini
2. **Storage**: Learnings are saved in SQLite with type, confidence, domain and tags
3. **Usage by agents**: Agents fetch relevant learnings before executing

### Agents MUST fetch learnings:

```
# Research Agent - start of workflow
mcp__cortex__learnings(action="relevant", task_type="feature", domain="go")

# Implement Agent - before implementing
mcp__cortex__learnings(action="relevant", task_type="feature")

# Verify Agent - know failure patterns
mcp__cortex__learnings(action="list", type="failure_pattern", limit=5)
```

### Learning types:

| Type | Description |
|------|-------------|
| `success_pattern` | Patterns that led to success |
| `failure_pattern` | Patterns that caused failures |
| `domain_knowledge` | Domain-specific knowledge |
| `user_feedback` | User feedback |

### Available MCP Tools:

- `mcp__cortex__learnings(action="list")` - List with filters (type, domain, limit)
- `mcp__cortex__learnings(action="relevant")` - Fetch relevant for task_type/domain

### Requires:

- `OPENAI_API_KEY` configured for automatic extraction
- Without the key, extraction is silently ignored
