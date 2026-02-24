# System Patterns *(optional)*

> Architecture patterns, conventions, and structural decisions.
> Useful once your project has established conventions the AI should follow.
> Skip this file early on — fill it in as patterns emerge.

---

## Directory Structure

<!-- Show the top-level layout. Describe what each folder is for.
     Don't paste the full tree — just the meaningful top-level structure. -->
```
project-root/
├── src/           # source files
├── tests/         # test files
└── ...
```

## Naming Conventions

<!-- List the conventions in use. The AI will follow these when creating new files. -->

| Thing | Convention | Example |
|-------|-----------|---------|
| Files | kebab-case | `user-profile.ts` |
| Functions | camelCase | `getUserById()` |
| Classes | PascalCase | `UserRepository` |

## Architecture Patterns

<!-- Describe the main structural patterns in use. For each, link to a canonical example
     in the codebase rather than pasting code here. -->

### Pattern Name
Brief description of how it works in this project.
- Reference: `path/to/canonical/example`

## Anti-Patterns

<!-- Things the AI should never do in this codebase. Be specific. -->
- Never do X — use Y instead
- Avoid Z because it causes [problem]

---

*Last updated: [DATE]*
