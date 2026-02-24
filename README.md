# Cursor Cognitive Boilerplate

A technology-agnostic scaffolding system for Cursor IDE. Not a code framework — a **cognitive framework** that gives your AI agent persistent memory, structured workflows, and self-improvement capability.

Works for any project: web apps, CLIs, APIs, data pipelines, anything.

---

## The Problem

LLMs are stateless. Every new chat session starts with zero memory. As sessions grow long, the context window fills up and the agent "forgets" earlier decisions — leading to inconsistent code and constant re-explanation.

This boilerplate gives the agent an **external memory system** in plain markdown files, combined with **rules** that tell it how to use that memory.

---

## Quick Start

### New project

```bash
# 1. Copy the boilerplate into your project root
cp -r cursor-boilerplate/* your-project/

# 2. Run the setup script
cd your-project
./init.sh

# 3. Fill in memory-bank/techContext.md with your stack

# 4. Delete or adapt the example rules
rm .cursor/rules/300-*-example.mdc   # or edit them for your stack

# 5. Open Cursor and start building
```

### Install into an existing project

```bash
# Safely copies boilerplate files without overwriting anything that exists
./install.sh /path/to/your/project

# Then run init from the target project
cd /path/to/your/project
bash /path/to/cursor-boilerplate/init.sh
```

`install.sh` skips files that already exist, merges `.gitignore` entries, and never overwrites.

---

## File Structure

```
your-project/
├── AGENTS.md                           # Agent entry point — session start instructions
├── init.sh                             # Interactive setup script (new projects)
├── install.sh                          # Install into existing project
├── validate.sh                         # Checks boilerplate is internally consistent
├── CHANGELOG.md                        # Boilerplate version history
│
├── memory-bank/                        # Persistent project memory
│   ├── projectbrief.md                 # Vision, objectives, scope (required)
│   ├── techContext.md                  # Tech stack and constraints (required)
│   ├── activeContext.md                # Current work state, updated often (required)
│   ├── productContext.md               # Business logic and user flows (optional)
│   ├── systemPatterns.md               # Architecture patterns (optional)
│   └── progress.md                     # Roadmap and completion tracking (optional)
│
├── logs/
│   ├── DEVELOPMENT_LOG.md              # Reverse-chronological index of all sessions
│   ├── CHAT_SUMMARY_TEMPLATE.md        # Template + guidelines for chat summaries
│   └── chat-summaries/                 # One file per significant work session
│       └── YYYYMMDD-description.md
│
├── examples/                           # Filled-in examples for reference
│   └── todo-app/
│       ├── projectbrief.md
│       ├── techContext.md
│       ├── activeContext.md
│       └── chat-summary-example.md
│
└── .cursor/
    ├── mcp.json                        # MCP servers (Context7 + sequential thinking)
    └── rules/
        ├── 000-rule-management.mdc     # How to create new rules
        ├── 001-security.mdc            # Never commit secrets or hardcode credentials
        ├── 001-self-improvement.mdc    # When the agent proposes new rules
        ├── 100-workflow-loop.mdc       # Plan/Act for large tasks
        ├── 200-context-preservation.mdc # How and when to log changes
        ├── creating-rules.mdc          # Meta-guidelines for rule authoring
        ├── 300-typescript-example.mdc  # EXAMPLE — delete or adapt
        └── 300-python-example.mdc      # EXAMPLE — delete or adapt
```

---

## How It Works

### Memory Bank (3 required + 3 optional files)

The agent reads these before planning and updates them after acting.

| File | Required | Update Frequency | Purpose |
|------|----------|-----------------|---------|
| `projectbrief.md` | Yes | Rarely | Project vision and scope |
| `techContext.md` | Yes | When stack changes | Technology and constraints |
| `activeContext.md` | Yes | Every session | Current state and next steps |
| `productContext.md` | No | When product changes | Business logic and user flows |
| `systemPatterns.md` | No | As patterns emerge | Architecture conventions |
| `progress.md` | No | Per task | Roadmap tracking |

### Development Log

The `logs/` directory is the long-term history of your project. Two components:

**`logs/DEVELOPMENT_LOG.md`** — a reverse-chronological index. Each entry is 2–3 bullet points and a link to a chat summary. The agent reads this at the start of every session to understand recent history quickly.

**`logs/chat-summaries/YYYYMMDD-description.md`** — one file per significant work session. Created using the template in `logs/CHAT_SUMMARY_TEMPLATE.md`. Contains the full context: what was done, why, what was tried, what failed, what to do next.

The agent only reads individual summary files when investigating a specific past decision — not at every session start.

### Workflow

The agent uses Plan/Act **only for large tasks** (3+ files or architectural decisions). Small changes proceed directly.

```
Request comes in
      │
      ├─ Small task (1-2 files) ──→ Just do it
      │
      └─ Large task (3+ files) ──→ PLAN → human approves → ACT
                                                              │
                                                              └─ Update activeContext.md + create chat summary
```

### Rules

Five always-on rules govern behavior:

| Rule | What it does |
|------|-------------|
| `000-rule-management` | Naming, structure, and governance for new rules |
| `001-security` | Never commit secrets; always use environment variables |
| `001-self-improvement` | Proposes new rules when it sees repeated patterns (3+ times) |
| `100-workflow-loop` | Plan/Act for large tasks; small tasks proceed freely |
| `200-context-preservation` | When and how to log changes to the chat-summaries system |

`creating-rules.mdc` is also always-on — it defines authoring standards for any new rule.

---

## MCP Servers

The boilerplate ships `.cursor/mcp.json` with two servers that work out of the box:

| Server | Purpose | Prerequisite |
|--------|---------|--------------|
| **Context7** | Up-to-date docs for any library | None (remote) |
| **Sequential thinking** | Structured step-by-step reasoning | Node.js |

Restart Cursor after changing `mcp.json`.

### Optional MCP Servers

Add these to `.cursor/mcp.json` as needed:

**Git** (requires [uv](https://docs.astral.sh/uv/) or Python):
```json
"git": {
  "command": "uvx",
  "args": ["mcp-server-git", "--repository", "."]
}
```

**Filesystem** (requires Node.js):
```json
"filesystem": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-filesystem", "."]
}
```

**Playwright browser** (for frontend/web testing):
```json
"playwright": {
  "command": "npx",
  "args": ["-y", "@playwright/mcp"]
}
```

---

## Customization

- **Add tech rules**: Create `300-your-stack.mdc` following the examples. Use `globs` to scope them to relevant file types.
- **Skip optional memory files**: For small projects, just use the 3 required files.
- **Adjust the plan threshold**: Edit `100-workflow-loop.mdc` if you want more or less planning ceremony.
- **Add chat summary categories**: Edit `logs/CHAT_SUMMARY_TEMPLATE.md` to add project-specific categories.

---

## Examples

The `examples/todo-app/` directory contains filled-in memory bank files and a sample chat summary for a fictional "TaskFlow" todo app. Use it as a reference when filling in your own files.

---

## Validation

Run `./validate.sh` to check that the boilerplate is internally consistent: all required files exist, scripts are executable, rule files have valid frontmatter, and no leftover `.bak` files.

---

## Versioning

See `CHANGELOG.md` for version history.
