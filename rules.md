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

**User:** "Adiciona um botão de logout"
**Claude:** Uses `/implement Adicionar botão de logout`

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
| Create task | `mcp__cortex__task_create` | `cx add` |
| Update task | `mcp__cortex__task_update` | `cx start/done/mv` |
| Search memory | `mcp__cortex__memory_list(search=)` | `cx memory search` |
| Save memory | `mcp__cortex__memory_save` | `cx memory diary` |

## Rule 3: Task Tracking

- Every piece of work needs a Cortex task (CX-N)
- Tasks are created via MCP tools, not internal Claude tasks
- Status updates go through MCP: `task_update(status="progress|done")`

## Rule 4: Learnings System - Continuous Improvement

O Cortex tem um sistema de learnings que extrai padrões de sucesso/falha automaticamente.

### Como funciona:

1. **Extração automática**: Quando `cx done` ou agents completam tasks com reward extremo (≥80% ou ≤40%), o sistema extrai learnings via GPT-4o-mini
2. **Storage**: Learnings são salvos no SQLite com tipo, confiança, domínio e tags
3. **Uso pelos agents**: Agents buscam learnings relevantes antes de executar

### Agents DEVEM buscar learnings:

```
# Research Agent - início do workflow
mcp__cortex__learnings_relevant task_type="feature" domain="go"

# Implement Agent - antes de implementar
mcp__cortex__learnings_relevant task_type="feature"

# Verify Agent - conhecer padrões de falha
mcp__cortex__learnings_list type="failure_pattern" limit=5
```

### Tipos de learnings:

| Tipo | Descrição |
|------|-----------|
| `success_pattern` | Padrões que levaram a sucesso |
| `failure_pattern` | Padrões que causaram falhas |
| `domain_knowledge` | Conhecimento específico do domínio |
| `user_feedback` | Feedback do usuário |

### MCP Tools disponíveis:

- `learnings_list` - Listar com filtros (type, domain, limit)
- `learnings_search` - Busca por texto
- `learnings_get` - Buscar por ID
- `learnings_relevant` - Buscar relevantes para task_type/domain

### Requer:

- `OPENAI_API_KEY` configurada para extração automática
- Sem a key, extração é silenciosamente ignorada
