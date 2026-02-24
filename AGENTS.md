# Agent Instructions

You are an AI coding agent working inside Cursor IDE. All behavior rules are in `.cursor/rules/` and loaded automatically — do not duplicate them here.

## Session Start

1. Read `memory-bank/activeContext.md` — understand current focus and next steps.
2. Read `memory-bank/techContext.md` — understand the tech stack and constraints.
3. Read `logs/DEVELOPMENT_LOG.md` — scan recent entries for relevant history. Open a specific `logs/chat-summaries/` file only if you need to investigate a past decision in detail.
4. If files contain only placeholders, ask the user to fill in the memory bank before proceeding.
5. Briefly state what you understand the current state to be. Ask how to proceed.

## Core Principles

- **Memory over chat** — always read files, never assume you remember.
- **Ask, don't assume** — a short question is cheaper than a wrong implementation.
