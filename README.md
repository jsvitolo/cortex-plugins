# Cortex Plugin for Claude Code

Task management, semantic memory, and agent orchestration for Claude Code.

## Prerequisites

Install the `cx` CLI:

```bash
# From source
go install github.com/jsvitolo/cortex/cmd/cx@latest

# Or build from repo
git clone https://github.com/jsvitolo/cortex && cd cortex && make install
```

Initialize Cortex in your project:

```bash
cx init
```

## Installation

```bash
# Add the marketplace
/plugin marketplace add jsvitolo/cortex-plugins

# Install the plugin
/plugin install cortex@cortex-plugins
```

## What's Included

### MCP Server

Automatically connects Claude Code to your Cortex instance via `cx mcp serve`.

### Skills (slash commands)

| Skill | Description |
|-------|-------------|
| `/cortex:implement` | 3-agent workflow (research -> implement -> verify) |
| `/cortex:pr` | Create PR and move task to review |
| `/cortex:merge` | Merge PR and move task to done |
| `/cortex:start` | Start working on a task |
| `/cortex:brainstorm` | Explore ideas before committing |
| `/cortex:plan` | Create implementation plan |
| `/cortex:review` | Interactive code review |
| `/cortex:onboard` | Analyze project and save context |
| `/cortex:sync` | Sync task progress to GitHub Issue |
| `/cortex:memory-system` | Capture learnings, search context |
| `/cortex:session-end` | Save session context before ending |

### Commands

| Command | Description |
|---------|-------------|
| `/cortex:create` | Create a new task |
| `/cortex:list` | List tasks |
| `/cortex:delete` | Delete a task |
| `/cortex:done` | Mark task as completed |
| `/cortex:start` | Start working on a task |
| `/cortex:mv` | Move task to different status |
| `/cortex:ui` | Open TUI application |
| `/cortex:init` | Initialize Cortex |
| `/cortex:setup-hooks` | Setup automation hooks |

### Hooks (automatic)

- **SessionStart**: Shows Cortex status on startup
- **PreToolUse**: Task tracking enforcement, branch checks
- **PostToolUse**: PR/merge suggestions, brainstorm/plan guidance
- **PreCompact**: Context reinjection before compaction
- **Stop**: Session diary capture

## License

MIT
