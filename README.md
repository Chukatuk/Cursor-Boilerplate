# Cursor Cognitive Boilerplate

A technology-agnostic scaffolding system for Cursor IDE. Not a code framework — a **cognitive framework** that gives your AI agent persistent memory, structured workflows, and self-improvement capability.

Works for any project: web apps, CLIs, APIs, data pipelines, anything.

---

## The Problem

LLMs are stateless. Every new chat session starts with zero memory. As sessions grow long, the context window fills up and the agent "forgets" earlier decisions — leading to inconsistent code and constant re-explanation.

This boilerplate gives the agent an **external memory system** in plain markdown files, combined with **rules** that tell it how to use that memory.

---

## Quick Start

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

The `init.sh` script walks you through setting the project name, vision, and audience — replacing all the placeholders automatically.

---

## File Structure

```
your-project/
├── AGENTS.md                           # Lean agent entry point (~20 lines)
├── init.sh                             # Interactive setup script
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
├── logs/                               # Append-only development history
│   ├── LOG_INDEX.md                    # Index of all log files
│   └── LOG_001.md                      # Detail log, rotated at ~5000 chars
│
├── examples/                           # Filled-in example for reference
│   └── todo-app/                       # What good memory bank files look like
│       ├── projectbrief.md
│       ├── techContext.md
│       └── activeContext.md
│
└── .cursor/
    ├── mcp.json                        # Recommended MCP servers (language-agnostic)
    └── rules/
        ├── 000-rule-management.mdc     # How to create new rules
        ├── 001-self-improvement.mdc    # When the agent proposes new rules
        ├── 100-workflow-loop.mdc       # Plan/Act workflow (large tasks only)
        ├── 200-context-preservation.mdc # Logging major changes
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

### Workflow

The agent uses Plan/Act **only for large tasks** (3+ files or architectural decisions). Small changes proceed directly.

```
Request comes in
      │
      ├─ Small task (1-2 files) ──→ Just do it
      │
      └─ Large task (3+ files) ──→ PLAN → human approves → ACT
                                                              │
                                                              └─ Update activeContext.md
```

### Rules

Four core rules govern behavior. They're loaded automatically via `alwaysApply: true`:

| Rule | What it does |
|------|-------------|
| `000-rule-management` | Naming, structure, and governance for new rules |
| `001-self-improvement` | Proposes new rules when it sees repeated patterns (3+ times) |
| `100-workflow-loop` | Plan/Act for large tasks; small tasks proceed freely |
| `200-context-preservation` | Log major changes to activeContext.md and logs/ |

### Development Log

The `logs/` directory is an append-only history of significant changes.

- `LOG_INDEX.md` — small index: one row per log file, always scannable.
- `LOG_001.md`, `LOG_002.md`, ... — detail files with freeform entries. When a file hits ~5000 chars, the agent creates the next one and updates the index. Old files are never modified.

The agent writes a log entry after major changes — not after every edit. Entries are freeform (date + title + what happened), not a rigid template.

### MCP Servers

The boilerplate ships `.cursor/mcp.json` with recommended MCP servers that work for any language:

| Server | Purpose | Prerequisite |
|--------|---------|--------------|
| **Context7** | Up-to-date docs for any library (no training-data guesswork) | None (remote) |
| **Git** | Status, diff, commit, history | [uv](https://docs.astral.sh/uv/) or Python + `mcp-server-git` |
| **Filesystem** | Read/write files, list dirs | Node.js (for `npx`) |
| **Sequential thinking** | Structured step-by-step reasoning | Node.js (for `npx`) |

- **Context7** uses the remote server; no API key needed (optional key for higher limits).
- If you don't use **uv** or Python, remove the `git` entry from `.cursor/mcp.json` to avoid startup errors.
- For **web/frontend** work, add a Browser MCP (e.g. Playwright or cursor-ide-browser) in Cursor Settings → MCP.

Restart Cursor after changing `mcp.json` for changes to apply.

### Example Tech Rules

The boilerplate ships two example tech rules (`300-typescript-example.mdc`, `300-python-example.mdc`) showing what a project-specific rule looks like. These are **not loaded by default** — they use `alwaysApply: false` with file globs. Delete them or adapt them for your stack.

---

## Customization

- **Add your own tech rules**: Create `300-your-stack.mdc` files following the examples. Use `globs` to scope them to relevant file types.
- **Skip optional memory files**: For small projects, just use the 3 required files. The agent will work fine.
- **Adjust the plan threshold**: Edit `100-workflow-loop.mdc` if you want more or less planning ceremony.

---

## Examples

The `examples/todo-app/` directory contains filled-in memory bank files for a fictional "TaskFlow" todo app. Use it as a reference when filling in your own files.

---

## Versioning

See `CHANGELOG.md` for version history. When the boilerplate improves, you can diff against your copy to see what changed.
