# Chat Summary Template

Copy the template below into a new file in `logs/chat-summaries/YYYYMMDD-brief-description.md`.

For guidelines on when to create summaries, naming, and categories, see `.cursor/rules/200-chat-summaries.mdc`.

---

```markdown
Last Updated: YYYY-MM-DD

# [Brief Title of What Was Done]

**Date:** YYYY-MM-DD
**Category:** [Feature | Bug Fix | Refactor | Performance | Security | Database | Configuration | Integration | UI/UX | Testing | Documentation | Investigation]
**Type:** Feature | Bug Fix | Refactor | Investigation | Configuration

---

## Overview

2–3 sentences summarizing what was accomplished.

---

## Problem / Objective

What problem were we solving, or what was the goal?

### Context

Any relevant background or previous attempts.

---

## Solution / Implementation

What approach was taken? What key decisions were made?

### Files Changed

#### Created
- `path/to/file` — what it does

#### Modified
- `path/to/file` — what changed and why

### Key Decisions

1. **Decision name** — rationale
2. **Another decision** — why this approach

---

## Issues Encountered

### Issue: [Problem description]
- **Cause:** why it happened
- **Solution:** how it was fixed

---

## Testing

- ✅ Test case 1
- ✅ Test case 2
- ⏳ Still pending

---

## Follow-up Tasks

- [ ] Task for later
- [ ] Improvement idea

---

## Notes

Any warnings, gotchas, or context future developers should know.
```
