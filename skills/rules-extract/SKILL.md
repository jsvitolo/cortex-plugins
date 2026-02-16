---
name: rules
description: Interactive wizard to extract business rules from source code. Guides through scope selection, category filtering, and output preferences before running extraction.
argument-hint: [path]
user-invocable: true
allowed-tools: mcp__cortex__*
---

# Business Rules Extraction Wizard

This skill provides an **interactive setup wizard** that guides you through extracting business rules from source code using LSP navigation and pattern detection.

## Arguments

$ARGUMENTS

If no path is provided, the current working directory is used.

## Instructions

### Step 1: Determine the target path

If `$ARGUMENTS` contains a path, use it. Otherwise, ask the user:

> What directory or file would you like to extract business rules from?
> (Default: current project root)

### Step 2: Ask user preferences (interactive wizard)

Ask the user the following questions one at a time, providing sensible defaults:

1. **Scope**: "What scope should I use?"
   - `file` - Extract from a single file
   - `module` - Extract from a directory/module
   - `project` - Extract from the entire project
   - Default: auto-detect based on whether path is a file or directory

2. **Categories**: "Which rule categories are you interested in?"
   - `validation` - Input validation, data checks
   - `calculation` - Formulas, computations, transformations
   - `flow` - Workflow, state machines, process logic
   - `permission` - Authorization, access control
   - `all` - All categories (default)

3. **Detail level**: "How detailed should the output be?"
   - `summary` - Quick overview with counts and key findings
   - `detailed` - Full code chunks with pattern analysis (default)

4. **Include tests**: "Should I also analyze test files for corroborating evidence?"
   - `yes` (default) / `no`

5. **Cross-reference**: "Should I cross-reference test evidence with production code?"
   - `yes` (default if tests included) / `no`

6. **Output format**: "Where should I save the extracted rules?"
   - `memory` - Save as Cortex memories for semantic search (default)
   - `markdown` - Generate a Markdown catalog in docs/business-rules/
   - `both` - Save to both

7. **Task link** (optional): "Link extracted rules to a task? (e.g., CX-15)"
   - If a task is currently in progress, suggest it as default

### Step 3: Run extraction

Call the `rules_extract` MCP tool with the configured options:

```
mcp__cortex__rules_extract(
  path="<path>",
  scope="<scope>",
  categories=["<cat1>", "<cat2>"],
  detail_level="<level>",
  include_tests=<bool>,
  cross_reference=<bool>,
  output_memory=<bool>,
  output_markdown=<bool>,
  output_dir="docs/business-rules",
  task_id="<task_id>",
  max_chunks=50,
  strategy="smart"
)
```

### Step 4: Interpret chunks and save rules

The extraction returns structured code chunks with pattern hints. For each chunk:

1. **Analyze** the code and pattern hints to identify business rules
2. **Determine** if it is a real business rule (not just an implementation detail)
3. **For each identified rule**, call `business_rule_save`:

```
mcp__cortex__business_rule_save(
  title="<descriptive title>",
  description="<what the rule enforces>",
  category="<validation|calculation|flow|permission|constraint|state_transition|integration>",
  importance="<critical|high|medium|low>",
  confidence=<0.0-1.0>,
  source_file="<file path>",
  source_func="<function name>",
  source_start_line=<line>,
  source_end_line=<line>,
  code_snippet="<relevant excerpt>",
  domain="<package/module name>",
  tags=["<tag1>", "<tag2>"],
  extracted_by="lsp+llm",
  task_id="<task_id if provided>"
)
```

### Step 5: Generate catalog (if markdown requested)

If the user chose markdown or both output:

```
mcp__cortex__business_rule_catalog(
  output_dir="docs/business-rules",
  min_confidence=0
)
```

### Step 6: Report summary

Present a summary to the user:

- Total code chunks analyzed
- Number of business rules identified and saved
- Breakdown by category
- Breakdown by importance
- If markdown was generated, show the output directory
- Suggest next steps (e.g., "Use `cx catalog generate` to regenerate the catalog later")

## Example Session

```
User: /rules ./internal/payment/

Claude: I'll help you extract business rules from ./internal/payment/.
        Let me walk through a few preferences first.

        What scope should I use?
        - module (recommended for a directory)
        - file
        - project

User: module is fine

Claude: Which rule categories are you interested in?
        - all (default)
        - validation, calculation, flow, permission

User: all

Claude: Should I include test file analysis for corroborating evidence? (yes/no, default: yes)

User: yes

Claude: Where should I save the extracted rules?
        - memory (default) - for semantic search
        - markdown - generate docs/business-rules/
        - both

User: both

Claude: [Runs extraction, analyzes 23 chunks, identifies 8 business rules]

        Extraction complete!
        - Chunks analyzed: 23
        - Rules identified: 8
          - validation: 3 (2 high, 1 medium)
          - calculation: 2 (1 critical, 1 high)
          - flow: 2 (2 medium)
          - permission: 1 (1 high)
        - Catalog written to: docs/business-rules/
        - All rules saved to Cortex memory for semantic search

        Next steps:
        - View rules: cx catalog generate
        - Search rules: cx rules search "payment"
        - Link to task: business_rule_save with task_id
```

## Tips

- Start with a **module scope** for focused extraction
- Use **include_tests=true** for higher confidence scores
- The **cross_reference** option connects test evidence to production code
- Rules with confidence < 0.5 may be implementation details rather than business rules
- Use `/rules .` for a full project scan (may take longer)
