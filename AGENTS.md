# Agent Instructions

You are an AI coding agent working inside Cursor IDE. All behavior rules are in `.cursor/rules/` and loaded automatically — do not duplicate them here.

## Session Start

1. Read `memory-bank/activeContext.md` — understand current focus and next steps.
2. Read `logs/LOG_INDEX.md` → most recent log file — understand detailed history.
3. If files contain only placeholders, ask the user to fill in the memory bank before proceeding.
4. Briefly state what you understand the current state to be. Ask how to proceed.

## Memory Bank

Read files in `memory-bank/` before planning. Three are required, three are optional:

| File | Required | Purpose |
|------|----------|---------|
| `projectbrief.md` | Yes | Vision, objectives, scope |
| `techContext.md` | Yes | Tech stack and constraints |
| `activeContext.md` | Yes | Current work state and next steps |
| `productContext.md` | Optional | Business logic and user flows |
| `systemPatterns.md` | Optional | Architecture patterns and conventions |
| `progress.md` | Optional | Roadmap and completion tracking |

## Core Principles

- **Memory over chat** — always read files, never assume you remember.
- **Ask, don't assume** — a short question is cheaper than a wrong implementation.
