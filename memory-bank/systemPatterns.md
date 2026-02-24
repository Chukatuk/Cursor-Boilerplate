# System Patterns *(optional)*

> Architecture patterns, conventions, and structural decisions.
> Useful once your project has established conventions the AI should follow.
> Skip this file early on — fill it in as patterns emerge.

---

## Directory Structure

```
[project-root]/
├── [folder]/          # [what lives here]
├── [folder]/          # [what lives here]
└── [folder]/          # [what lives here]
```

## Naming Conventions

| Thing | Convention | Example |
|-------|-----------|---------|
| Files | [e.g., kebab-case] | [e.g., user-profile.ts] |
| Functions | [e.g., camelCase] | [e.g., getUserById()] |
| Classes | [e.g., PascalCase] | [e.g., UserRepository] |

## Architecture Patterns

### [Pattern Name]
[Brief description of how it's used]
- Reference: `[path/to/canonical/example]`

## Anti-Patterns

- [ANTI-PATTERN 1, e.g., "Never use `any` — use `unknown` + type guard"]

---

*Last updated: [DATE]*
