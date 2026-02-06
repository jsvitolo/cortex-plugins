---
description: Setup Claude Code hooks for Cortex automation
argument-hint: [--force]
---

Configure Claude Code hooks for Cortex integration in the current project.

## Arguments

$ARGUMENTS

## Flags

- `--force`: Overwrite existing hooks

## Prerequisites

- Cortex must be initialized (`cx init`)
- `jq` must be installed for JSON parsing

## Your Task

### Step 1: Verify Prerequisites

```bash
# Check if Cortex is initialized
if [ ! -d ".cortex" ]; then
    echo "Error: Cortex not initialized. Run 'cx init' first."
    exit 1
fi

# Check if jq is available
if ! command -v jq &> /dev/null; then
    echo "Warning: jq not installed. Some hooks may not work."
    echo "Install with: brew install jq (macOS) or apt install jq (Linux)"
fi
```

### Step 2: Create Hooks Directory

```bash
mkdir -p .claude/hooks
```

### Step 3: Create Hook Scripts

Create all three hook scripts as defined in the `/init` command.

### Step 4: Configure settings.json

If `.claude/settings.json` exists, merge hooks into it. Otherwise create new file.

**Important:** Don't overwrite existing settings, merge the hooks section.

### Step 5: Show Summary

```
✅ Hooks configurados!

🪝 Hooks ativos:
   • SessionStart (startup)  - Carrega cx status
   • SessionStart (compact)  - Reinjeta contexto
   • PreToolUse (Bash)       - Avisa commits sem task

📝 Arquivos criados:
   .claude/hooks/cortex-status.sh
   .claude/hooks/check-task-tracking.sh
   .claude/hooks/reinject-context.sh
   .claude/settings.json (atualizado)

💡 Use /hooks no Claude Code para ver e gerenciar hooks.
```

## Optional: Add Stop Hook

Ask the user if they want to add a prompt-based Stop hook:

```
Deseja adicionar um hook Stop para verificar completude de tasks?
Este hook usa LLM para avaliar se a task foi concluída antes de parar.

[Sim] / [Não]
```

If yes, add to settings.json:

```json
"Stop": [
  {
    "hooks": [
      {
        "type": "prompt",
        "prompt": "Check if the current task is complete. Context: $ARGUMENTS. Respond {\"ok\": true} if complete, or {\"ok\": false, \"reason\": \"what remains\"} if not.",
        "timeout": 15
      }
    ]
  }
]
```
