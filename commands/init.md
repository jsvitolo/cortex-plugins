---
description: Initialize cortex in the current project
argument-hint:
---

Initialize Cortex in the current directory with an interactive wizard.

Run the initialization wizard:
```bash
cx init
```

The wizard will:
1. Detect the project name from git or directory
2. Ask for project name and description
3. Create .cortex/ directory and database
4. Show next steps and Ollama status

If Cortex is already initialized, inform the user and suggest running `cx status` or `cx ui`.
