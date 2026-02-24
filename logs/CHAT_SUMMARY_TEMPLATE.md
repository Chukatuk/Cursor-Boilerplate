# Chat Summary Guidelines

This file explains how to create chat summaries and maintain the development log.
Reference it at the end of any significant work session.

---

## When to Create a Chat Summary

Create one when you:

- Implement a new feature (even small ones)
- Fix a bug, especially a non-obvious one
- Make an architectural decision
- Refactor existing code
- Resolve a problem that took multiple attempts
- Make database or schema changes
- Update configurations that affect system behavior

Skip it for: trivial typo fixes, simple doc updates, quick questions without implementation.

**Rule of thumb:** if it took more than 15 minutes, or future-you would want to know why, document it.

---

## Naming Convention

Files go in `logs/chat-summaries/` and follow this format:

```
YYYYMMDD-brief-description.md
```

Examples:
- `20260223-add-user-auth.md`
- `20260222-fix-payment-race-condition.md`
- `20260220-refactor-api-layer.md`

Rules: lowercase, kebab-case, start with date, 3–7 words describing what was done.

---

## Template

Copy this into a new file in `logs/chat-summaries/`:

```markdown
Last Updated: YYYY-MM-DD

# [Brief Title of What Was Done]

**Date:** YYYY-MM-DD
**Category:** [see categories below]
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

## Approaches Tried (if relevant)

1. **Attempted:** [approach]
   - **Result:** failed because...
   - **Lesson:** what to remember

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

---

## Categories

Pick the most relevant:

- **Feature** — new functionality added
- **Bug Fix** — problem diagnosed and resolved
- **Refactor** — code restructured without behavior change
- **Performance** — speed or resource improvements
- **Security** — security fixes or hardening
- **Database** — schema changes, migrations, data fixes
- **Configuration** — environment, deployment, tooling changes
- **Integration** — external API or service work
- **UI/UX** — frontend design or interaction changes
- **Testing** — test creation or QA process changes
- **Documentation** — significant doc improvements
- **Investigation** — research or debugging session, even without a final fix

---

## Adding to the Development Log

After creating a summary, add an entry to `logs/DEVELOPMENT_LOG.md` at the top:

```markdown
## YYYY-MM-DD

### [Category] Brief description
→ [chat-summaries/YYYYMMDD-description.md](chat-summaries/YYYYMMDD-description.md)
- Key point 1
- Key point 2
```

---

## Best Practices

**Be concise but complete**
- Good: "Added email resend with rate limiting (max 3/hour)"
- Too vague: "Fixed email stuff"
- Too detailed: wall-of-text describing every line changed

**Explain the why, not just the what**
- Good: "Used debouncing (300ms) on search input to reduce API calls"
- Missing why: "Added debouncing to search"

**Capture failed attempts** — they're as valuable as the solution.

**Link related work** — connect this summary to related past summaries.
