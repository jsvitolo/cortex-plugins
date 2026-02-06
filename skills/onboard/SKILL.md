---
name: onboard
description: Analyze project and save context as Cortex memories (stack, architecture, database, testing)
argument-hint: [--refresh] [--only stack|architecture|database|testing] [--dry-run]
user-invocable: true
allowed-tools: Bash(ls *), Bash(cat *), Bash(head *), Bash(find *), Bash(wc *), Read, Glob, Grep, mcp__cortex__memory_save, mcp__cortex__memory_list
---

# Project Onboarding

Analyze the current project and save comprehensive context as Cortex memories.

## Arguments

$ARGUMENTS

## Flags

- `--refresh`: Update existing memories instead of creating new ones
- `--only <type>`: Analyze only specific aspect (stack, architecture, database, testing)
- `--dry-run`: Show what would be saved without actually saving

## Your Task

Analyze this project and generate memories for each aspect below. Use the tools available to explore the codebase.

### Step 1: Detect Project Type

Check for these files to identify the stack:

| File | Stack |
|------|-------|
| `go.mod` | Go |
| `mix.exs` | Elixir |
| `package.json` | Node.js |
| `requirements.txt` / `pyproject.toml` | Python |
| `Cargo.toml` | Rust |
| `Gemfile` | Ruby |

### Step 2: Analyze Each Aspect

#### 2.1 Stack Analysis (`implementation:project:stack`)

Gather:
- Language and version
- Framework (if any)
- Key dependencies (top 10-15 most important)
- Package manager
- Build commands

**Save as:**
```
mcp__cortex__memory_save(
  type="implementation",
  title="project:stack",
  content="..."
)
```

#### 2.2 Architecture Analysis (`architecture:project:structure`)

Gather:
- Directory structure (top 2-3 levels)
- Architectural pattern (MVC, DDD, Clean, Contexts, etc.)
- Entry points (main files, routers)
- Key modules/packages

**Save as:**
```
mcp__cortex__memory_save(
  type="architecture",
  title="project:structure",
  content="..."
)
```

#### 2.3 Database Analysis (`implementation:project:database`)

If database exists, gather:
- Database type (Postgres, MySQL, SQLite, MongoDB)
- ORM/Query builder
- Schema/Models location
- Key tables/collections with relationships
- Important indexes
- Migration commands

**Detection by stack:**
- **Ecto**: `priv/repo/migrations/`, `lib/**/schemas/`
- **GORM**: structs with `gorm:` tags
- **Prisma**: `prisma/schema.prisma`
- **TypeORM**: `**/entities/*.ts`
- **Rails**: `db/schema.rb`
- **Django**: `*/models.py`
- **SQLite raw**: check for `.db` files

**Save as:**
```
mcp__cortex__memory_save(
  type="implementation",
  title="project:database",
  content="..."
)
```

#### 2.4 Testing Analysis (`testing:project:testing`)

Gather:
- Test framework
- Test file locations
- How to run tests
- Coverage configuration (if any)
- CI/CD setup (GitHub Actions, etc.)

**Save as:**
```
mcp__cortex__memory_save(
  type="testing",
  title="project:testing",
  content="..."
)
```

#### 2.5 Project Overview (`context:project:overview`)

Create a summary with:
- Project name and purpose
- Main stack (1-2 lines)
- Key features/capabilities
- Quick start commands

**Save as:**
```
mcp__cortex__memory_save(
  type="context",
  title="project:overview",
  content="..."
)
```

### Step 3: Memory Content Templates

#### Stack Template
```markdown
# Stack: [Language] [Version]

## Framework
[Framework name and version]

## Package Manager
[npm/go mod/mix/pip/cargo]

## Key Dependencies
- [dep1]: [purpose]
- [dep2]: [purpose]
...

## Build Commands
- Build: `[command]`
- Run: `[command]`
- Install deps: `[command]`
```

#### Architecture Template
```markdown
# Architecture: [Pattern Name]

## Directory Structure
```
[tree output, 2-3 levels]
```

## Layers/Modules
- [layer1]: [purpose]
- [layer2]: [purpose]

## Entry Points
- [file]: [description]
```

#### Database Template
```markdown
# Database: [Type] + [ORM]

## Connection
- Config: [file path]
- Repo/Connection: [module/class name]

## Schema Overview ([N] tables)

### [Entity Group 1]
- table1 (field1, field2, field3)
  - FK: field_id -> other_table
- table2 (...)

### [Entity Group 2]
...

## Relationships
[ASCII diagram or description]

## Key Indexes
- table.field (unique/index)
...

## Commands
- Migrate: `[command]`
- Rollback: `[command]`
- Create migration: `[command]`
```

#### Testing Template
```markdown
# Testing: [Framework]

## Location
- Tests: [path pattern]
- Fixtures: [path]
- Mocks: [path or approach]

## Commands
- Run all: `[command]`
- Run single: `[command]`
- With coverage: `[command]`

## CI/CD
- Platform: [GitHub Actions/GitLab CI/etc]
- Config: [file path]
```

#### Overview Template
```markdown
# [Project Name]

[One paragraph description]

## Stack
- Language: [lang] [version]
- Framework: [framework]
- Database: [db]

## Quick Start
```bash
[clone]
[install]
[run]
```

## Key Commands
- `[cmd1]`: [description]
- `[cmd2]`: [description]
```

### Step 4: Output

After saving memories, show:

```
🔍 Analisando projeto...

📁 Detectado:
   Linguagem: [lang] [version]
   Framework: [framework]
   Banco: [database]

💾 Memórias salvas:
   ✓ context:project:overview
   ✓ architecture:project:structure
   ✓ implementation:project:stack
   ✓ implementation:project:database (se existir)
   ✓ testing:project:testing

🎉 Onboarding completo! O Claude Code agora conhece seu projeto.

Dica: Use "cx memory search 'como testar'" para verificar.
```

### Step 5: Handle Flags

**If `--refresh`:**
- Check existing memories with `mcp__cortex__memory_list`
- Update content instead of creating duplicates

**If `--only <type>`:**
- Only analyze and save the specified aspect
- Valid types: stack, architecture, database, testing, overview

**If `--dry-run`:**
- Show what would be saved
- Do NOT call `mcp__cortex__memory_save`
- Format output as preview

## Notes

- Be thorough but concise in memory content
- Focus on information useful for coding tasks
- Include actual file paths and commands
- For database, prioritize understanding relationships
- Adapt to the specific stack found
