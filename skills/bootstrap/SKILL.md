---
name: bootstrap
description: Deep-index all source files using Claude Code analysis (no external LLM). Reads each file, generates semantic descriptions, saves to KB. Resumable.
argument-hint: [--reset] [--ext .go,.ts]
user-invocable: true
allowed-tools: Bash(cx kb bootstrap*), Read, mcp__cortex__kb
---

# Bootstrap: Deep Code Indexing

Analyze every source file in the project and save rich semantic descriptions to the KB.
Uses Claude Code's own intelligence — no external API required.

## Arguments

$ARGUMENTS

## Flags

- `--reset`: Clear existing bootstrap state and start fresh
- `--ext .go,.ts`: Override which file extensions to index

## Your Task

### Step 1: Handle flags

If `--reset` was passed, run:
```bash
cx kb bootstrap --reset
```

If `--ext` was passed (e.g. `--ext .go,.ts`), note the extensions — you will pass them
when running `cx kb bootstrap --list` later.

### Step 2: Show current status

```bash
cx kb bootstrap
```

Print the output for the user to see progress.

### Step 3: Get pending files

```bash
cx kb bootstrap --list
```

This outputs one file path per line. If the output is empty, all files are already indexed —
show "Already up to date!" and stop.

### Step 4: Process each file

For each pending file (process ALL of them, one at a time):

1. **Read the file** using the Read tool with the absolute path.

2. **Analyze** — generate two descriptions:
   - `description_technical`: What does this file do technically? Key types, functions,
     interfaces, patterns used. Be specific (2-3 sentences).
   - `description_business`: What business responsibility does this file own? What problem
     does it solve? Plain language (1-2 sentences).

3. **Save to KB**:
   ```
   mcp__cortex__kb(
     action="upsert",
     kind="file",
     name=<relative_path>,
     description_technical=<technical description>,
     description_business=<business description>,
     source_file=<relative_path>
   )
   ```

4. **Mark as done**:
   ```bash
   cx kb bootstrap --done <relative_path>
   ```

5. **Show progress**: Print a brief line like `[N/total] path/to/file.go`

### Step 5: Final summary

After all files are processed:

```bash
cx kb bootstrap
```

Show the final status and a tip:
```
Bootstrap complete!
Run: cx kb search "query" to search the catalog.
```

## Notes

- Process files **one at a time** — don't batch multiple files into one call
- For trivial files (empty, only imports, generated code): write a minimal description
  and mark as done — don't skip
- Keep descriptions **concise** — 2-4 sentences per field is enough
- Focus on **purpose and responsibility**, not listing every symbol
- If a file is very large (>500 lines), read the first 200 lines and the last 50 for context
- The state is automatically saved after each `--done` call, so Ctrl+C is safe
