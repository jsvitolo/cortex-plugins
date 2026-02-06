---
description: Initialize cortex in the current project
argument-hint: [--with-hooks] [--minimal]
---

Initialize Cortex in the current directory with an interactive wizard.

## Arguments

$ARGUMENTS

## Flags

- `--with-hooks`: Also configure Claude Code hooks for automation
- `--minimal`: Skip hooks setup, only initialize Cortex database

## Your Task

### Step 1: Check if already initialized

```bash
ls -la .cortex/ 2>/dev/null
```

If `.cortex/` exists, inform the user:
```
Cortex já está inicializado neste projeto.

Comandos úteis:
  cx status    - Ver status do projeto
  cx ui        - Abrir interface TUI
  cx ls        - Listar tasks

Para reinicializar hooks: /init --with-hooks
```

### Step 2: Initialize Cortex

Run the initialization:
```bash
cx init
```

This will:
1. Detect project name from git or directory
2. Create `.cortex/` directory and database
3. Show Ollama status for embeddings

### Step 3: Setup Claude Code Hooks (unless --minimal)

Create hooks directory and scripts:

```bash
mkdir -p .claude/hooks
```

Create the hook scripts:

#### 3.1 cortex-status.sh (SessionStart)
```bash
cat > .claude/hooks/cortex-status.sh << 'HOOK'
#!/bin/bash
# Loads Cortex status at session start
if ! command -v cx &> /dev/null; then
    echo "Cortex not installed. Run: go install github.com/jonesvitolo/cortex/cmd/cx@latest"
    exit 0
fi
if [ ! -d ".cortex" ]; then
    echo "Cortex not initialized. Run: cx init"
    exit 0
fi
cx status 2>/dev/null || echo "Cortex: Unable to get status"
exit 0
HOOK
chmod +x .claude/hooks/cortex-status.sh
```

#### 3.2 check-task-tracking.sh (PreToolUse)
```bash
cat > .claude/hooks/check-task-tracking.sh << 'HOOK'
#!/bin/bash
# Warns if committing without a task in progress
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
if ! echo "$COMMAND" | grep -qE '^git commit'; then
    exit 0
fi
if ! command -v cx &> /dev/null || [ ! -d ".cortex" ]; then
    exit 0
fi
TASKS=$(cx ls --status progress 2>/dev/null | grep -c "CX-" || echo "0")
if [ "$TASKS" = "0" ]; then
    cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "additionalContext": "WARNING: No Cortex task in progress. Consider 'cx add' and 'cx start CX-N' before committing."
  }
}
EOF
fi
exit 0
HOOK
chmod +x .claude/hooks/check-task-tracking.sh
```

#### 3.3 reinject-context.sh (PreCompact)
```bash
cat > .claude/hooks/reinject-context.sh << 'HOOK'
#!/bin/bash
# Reinjects Cortex context after compaction
if ! command -v cx &> /dev/null || [ ! -d ".cortex" ]; then
    exit 0
fi
echo "=== Cortex Context (Post-Compaction) ==="
TASK=$(cx ls --status progress 2>/dev/null | head -5)
if [ -n "$TASK" ]; then
    echo "Current Task:"
    echo "$TASK"
fi
echo "Remember: Use 'cx done CX-N' when complete."
exit 0
HOOK
chmod +x .claude/hooks/reinject-context.sh
```

### Step 4: Configure settings.json

Check if `.claude/settings.json` exists:

```bash
cat .claude/settings.json 2>/dev/null
```

If it doesn't exist or doesn't have hooks, create/update it:

```bash
cat > .claude/settings.json << 'SETTINGS'
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/cortex-status.sh",
            "statusMessage": "Loading Cortex status..."
          }
        ]
      },
      {
        "matcher": "compact",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/reinject-context.sh",
            "statusMessage": "Reinjecting context..."
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/check-task-tracking.sh"
          }
        ]
      }
    ]
  }
}
SETTINGS
```

### Step 5: Update .gitignore

Ensure `.cortex/` is gitignored but hooks are not:

```bash
if ! grep -q "^.cortex/$" .gitignore 2>/dev/null; then
    echo ".cortex/" >> .gitignore
fi
```

### Step 6: Show completion message

```
✅ Cortex inicializado com sucesso!

📁 Estrutura criada:
   .cortex/          - Database e configurações (gitignored)
   .claude/hooks/    - Scripts de automação
   .claude/settings.json - Configuração de hooks

🪝 Hooks configurados:
   • SessionStart    - Carrega status do Cortex
   • PreToolUse      - Avisa sobre commits sem task
   • PreCompact      - Reinjeta contexto após compactação

📋 Próximos passos:
   1. cx add "Primeira task"     - Criar uma task
   2. cx start CX-1              - Iniciar trabalho
   3. cx done CX-1               - Marcar como concluída

💡 Dica: Use /onboard para analisar o projeto automaticamente.
```

## Notes

- Hooks require `jq` for JSON parsing (install with `brew install jq` or `apt install jq`)
- The Stop hook (prompt-based) is optional and can be added manually via `/hooks` menu
- For existing projects with hooks, only update if requested with `--with-hooks`
