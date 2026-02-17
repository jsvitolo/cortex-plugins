---
name: review
description: Interactive code review with educational quiz. Shows code, explains it, then quizzes you to verify understanding.
argument-hint: [PR number] (optional, defaults to current branch PR)
user-invocable: true
allowed-tools: Bash(git *), Bash(gh *), AskUserQuestion
---

# Interactive Code Review

Educational code review that ensures you understand the changes before approving.

## Context

- Current branch: !`git branch --show-current`
- PR status: !`gh pr view --json number,title,state 2>/dev/null || echo "No PR found for current branch"`

## Arguments

$ARGUMENTS

## Your Task

Conduct an **interactive educational code review** with the following flow:

### Step 1: Get the PR Diff

If a PR number is provided in arguments, use that. Otherwise, detect from current branch:

```bash
# If PR number provided:
gh pr diff <number>

# If no number, get current branch PR:
gh pr diff
```

### Step 2: Identify Significant Code Chunks

Break the diff into meaningful chunks:
- New functions/methods
- Modified logic blocks
- Configuration changes
- Important refactors

Skip trivial changes (whitespace, imports only, etc).

### Step 3: For Each Significant Chunk

#### 3a. Show the Code

Display the code snippet with context:
```
📝 **Chunk 1/N: [Brief description]**

File: `path/to/file.go`

\`\`\`diff
[the actual diff]
\`\`\`
```

#### 3b. Explain the Code

Provide a clear explanation:
- **What** the code does
- **Why** this change was made
- **How** it works (key logic points)

Example:
> "Este código verifica se o arquivo CLAUDE.md já tem as regras do Cortex.
> Se a string 'REGRAS OBRIGATÓRIAS' não existir, ele adiciona a seção completa
> no final do arquivo. Isso garante que projetos existentes recebam todas as
> regras sem perder o conteúdo original."

#### 3c. Ask if Understood

Use AskUserQuestion:
```
❓ Entendeu essa parte?

Options:
- "Sim, entendi" → Go to quiz
- "Não entendi, explica melhor" → Provide more detailed explanation, then ask again
```

#### 3d. Quiz to Verify (if user said they understood)

Create a multiple choice question about what was just explained:

```
🧠 Quiz: [Question about the code]

Options:
- [Correct answer]
- [Plausible but wrong answer]
- [Another wrong answer]
- "Não sei, me explica"
```

**If correct:**
- "✅ Correto! [Brief reinforcement]"
- Move to next chunk

**If wrong:**
- "❌ Não exatamente. [Explain the correct answer and why]"
- Ask if they want to continue or review again

**If "Não sei":**
- Provide detailed explanation
- Then move to next chunk

### Step 4: Final Summary

After all chunks reviewed:

```
## 📋 Review Summary

**PR:** #[number] - [title]
**Chunks reviewed:** N
**Quiz score:** X/Y correct

### Changes Understood:
- [List of key changes the user now understands]

### Ready to approve?
```

Use AskUserQuestion:
- "Sim, pode aprovar" → Run `gh pr review --approve`
- "Preciso revisar mais" → Offer to go through again
- "Não vou aprovar agora" → End without action

## Guidelines

1. **Be educational** - The goal is learning, not just approval
2. **Use Portuguese** - Match the user's language
3. **Be patient** - If they don't understand, explain differently
4. **Make quizzes fair** - Wrong answers should be plausible but clearly wrong once you understand
5. **Celebrate learning** - Positive reinforcement when they get it right
6. **Skip trivial chunks** - Don't quiz on obvious changes like formatting
