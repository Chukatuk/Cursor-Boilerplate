# Cursor Cognitive Boilerplate

A universal, technology-agnostic scaffolding system for Cursor IDE. Not a code framework — a **cognitive framework** that gives your AI agent persistent memory, structured workflows, self-improvement capability, and protection against context degradation.

Works for any project type: web apps, CLIs, games, APIs, data pipelines, embedded systems, anything.

---

## The Problem It Solves

LLMs are stateless. Every new chat session, the agent starts with zero memory of your project. As sessions grow long, the context window fills up and the agent starts "forgetting" earlier decisions and patterns — leading to inconsistent code, circular fixes, and constant re-explanation.

This boilerplate solves that by giving the agent an **external memory system** stored in plain markdown files in your repo, combined with **governing rules** that tell it exactly how to use that memory.

---

## How to Use This Boilerplate

1. **Copy** the entire boilerplate into your project root (or clone it as your starting point).
2. **Fill in the memory bank files** in `memory-bank/` — start with `projectbrief.md`, then the others. Each file has placeholder sections guiding you on what to write.
3. **That's it.** The rules and `AGENTS.md` are already wired up. The agent will read them automatically.

When you start a new chat in Cursor, the agent will orient itself from the memory bank and log files before doing anything else.

---

## File Structure

```
your-project/
│
├── AGENTS.md                    # Primary agent instructions — read first every session
│
├── memory-bank/                 # Persistent project memory
│   ├── projectbrief.md          # Vision, objectives, scope (rarely changes)
│   ├── productContext.md        # Business logic, user flows, domain rules
│   ├── techContext.md           # Tech stack, constraints, env vars
│   ├── systemPatterns.md        # Architecture patterns, naming conventions
│   ├── activeContext.md         # Current work focus and next steps (updated often)
│   └── progress.md              # What's done, what remains, known debt
│
├── logs/                        # Append-only development log
│   ├── LOG_INDEX.md             # Index: one row per log file, links to detail files
│   ├── LOG_001.md               # First log file — grows until ~5000 chars, then new file
│   └── LOG_002.md ...           # Subsequent log files, created automatically as needed
│
└── .cursor/
    └── rules/
        ├── creating-rules.mdc           # How to write good rules
        ├── 000-rule-management.mdc      # Naming, frontmatter, governance for new rules
        ├── 001-self-improvement.mdc     # When/how the agent proposes new rules
        ├── 100-workflow-loop.mdc        # Plan-then-Act workflow enforcement
        └── 200-context-preservation.mdc # Log update triggers, session-start protocol
```

---

## The Workflow Loop

Every non-trivial task follows this loop:

```
Human makes request
       |
       v
  [PLAN MODE]
  Agent reads memory bank
  Agent drafts step-by-step plan
  Agent presents plan → no code written yet
       |
       v
  Human approves
       |
       v
  [ACT MODE]
  Agent executes plan
  Agent updates activeContext.md + progress.md
  Agent appends to active log file
       |
       v
  Back to waiting for next request
```

The agent is **blocked from writing code** until the human approves the plan. This prevents wasted effort from misunderstood requirements.

---

## The Memory Bank

Six markdown files that act as the agent's long-term memory. The agent reads these before planning, and updates them after acting.

| File | Update Frequency | Purpose |
|------|-----------------|---------|
| `projectbrief.md` | Rarely | Immutable project constitution |
| `productContext.md` | Low | Business logic and UX goals |
| `techContext.md` | Low-Medium | Stack and constraints |
| `systemPatterns.md` | Medium | Architecture and conventions |
| `activeContext.md` | Every session | Current state and next steps |
| `progress.md` | Per task | Roadmap and completion status |

---

## The Log System

The `logs/` directory is an **append-only, growing history** of everything the agent does.

- `LOG_INDEX.md` — a small index file: date, one-sentence summary, link per log file. Always scannable.
- `LOG_001.md`, `LOG_002.md`, ... — detail files. Each entry records files changed, commands run, errors, and next steps. When a file fills up (~5000 chars), the agent creates the next numbered file and adds a row to the index. **Old files are never modified.**

When you start a fresh chat, the agent reads the index to find the latest log, reads that log file, then reads `activeContext.md`. It knows exactly where things stand.

---

## The Rules

Four core rules govern agent behavior:

| Rule | Purpose |
|------|---------|
| `000-rule-management.mdc` | How to create valid new rules — naming, frontmatter, content |
| `001-self-improvement.mdc` | When to propose new rules based on observed patterns |
| `100-workflow-loop.mdc` | The Plan/Act loop — no code without an approved plan |
| `200-context-preservation.mdc` | When to write to logs, how to handle log rotation, session-start steps |

---

## Self-Improvement

The boilerplate is designed to grow with your project. The `001-self-improvement.mdc` rule instructs the agent to:

- Watch for repeated patterns that aren't yet documented
- Propose new rules when it notices the same correction being made twice
- Propose usage rules when new dependencies are added

All proposals require human approval. The agent never writes rules autonomously.

---

## Customization

- **Add tech-stack rules**: Once you know your stack, add numbered rules like `300-typescript.mdc`, `301-react.mdc`, `400-api-patterns.mdc`. Use `000-rule-management.mdc` as a guide.
- **Adjust log rotation threshold**: Change the ~5000 char threshold in `200-context-preservation.mdc` to suit your preference.
- **Skip the 6-file memory bank**: For small/solo projects, you can reduce to just `activeContext.md` and `progress.md`. Update `AGENTS.md` to reflect what you're using.

---

## Starting a New Project with This Boilerplate

1. Copy this folder structure into your project root.
2. Open `memory-bank/projectbrief.md` — fill in your project name, vision, objectives, and scope.
3. Fill in `memory-bank/techContext.md` with your tech stack.
4. Fill in `memory-bank/systemPatterns.md` as you establish conventions.
5. Leave `memory-bank/activeContext.md` and `memory-bank/progress.md` — the agent updates these.
6. Start a Cursor chat and begin working. The agent will orient from your files.
