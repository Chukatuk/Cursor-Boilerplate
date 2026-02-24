# System Patterns

> Documents the architectural patterns, conventions, and structural decisions in use.
> The AI checks this before proposing any structural changes to ensure consistency.
> Update when new patterns are established or old ones are retired.

---

## Directory Structure

<!-- Show the top-level folder layout and what each directory is responsible for -->

```
[project-root]/
├── [folder]/          # [what lives here]
├── [folder]/          # [what lives here]
└── [folder]/          # [what lives here]
```

## Naming Conventions

<!-- Be explicit. The AI will follow these exactly. -->

| Thing | Convention | Example |
|-------|-----------|---------|
| [e.g., Files] | [e.g., kebab-case] | [e.g., user-profile.ts] |
| [e.g., Functions] | [e.g., camelCase] | [e.g., getUserById()] |
| [e.g., Classes] | [e.g., PascalCase] | [e.g., UserRepository] |
| [e.g., Constants] | [e.g., SCREAMING_SNAKE_CASE] | [e.g., MAX_RETRY_COUNT] |
| [e.g., DB tables] | [e.g., snake_case plural] | [e.g., user_sessions] |

## Architecture Patterns

<!-- What architectural patterns does this project follow? -->

### [Pattern Name, e.g., Repository Pattern]
[Brief description of how it's used in this project]
- [Key rule or constraint]
- Reference: `[path/to/canonical/example/file]`

### [Pattern Name, e.g., Event-Driven Updates]
[Brief description]
- [Key rule or constraint]

## Error Handling

<!-- How are errors handled in this project? -->
- [RULE 1, e.g., "All async functions must use try/catch and return a Result type"]
- [RULE 2, e.g., "User-facing errors are mapped to error codes defined in errors.ts"]

## State Management

<!-- How is state managed? (if applicable) -->
- [DESCRIBE APPROACH]

## Code Style and Linting

<!-- Point to config files rather than duplicating rules -->
- Linter config: `[path to .eslintrc / .pylintrc / etc.]`
- Formatter config: `[path to .prettierrc / pyproject.toml / etc.]`
- Key non-obvious rule: [any style rule not captured by the linter]

## Anti-Patterns

<!-- Things the AI must never do in this codebase -->
- [ANTI-PATTERN 1, e.g., "Never use any type in TypeScript — use unknown + type guard"]
- [ANTI-PATTERN 2]

---

*Last updated: [DATE]*
