# Changelog

All notable changes to the Cursor Cognitive Boilerplate are documented here.

## [2.0.0] — 2026-02-23

Major overhaul focused on reducing ceremony and improving usability.

### Changed
- **AGENTS.md** slimmed from 79 lines to ~20 — thin dispatcher, no longer duplicates rule content
- **Workflow rule** (100): Plan/Act now only required for tasks touching 3+ files or architectural decisions. Small changes proceed directly.
- **Context preservation** (200): Removed rigid 6-field log format and 25-tool-call checkpoint. Log entries are now freeform. Keeps `logs/` directory with LOG_INDEX + numbered files, but lighter.
- **Self-improvement** (001): Raised correction threshold from 2 to 3. Removed "new dependency added" trigger.
- **creating-rules.mdc**: Changed from `alwaysApply: true` to `alwaysApply: false` — now only loads when editing rules.
- **Memory bank files**: Trimmed templates, marked 3 as required and 3 as optional.
- **.gitignore**: Trimmed to essentials with commented sections for common stacks.

### Added
- **Example tech rules**: `300-typescript-example.mdc` and `300-python-example.mdc` showing what a good rule looks like.
- **Filled-in example**: `examples/todo-app/` with realistic projectbrief, techContext, and activeContext for a sample project.
- **init.sh**: Interactive setup script that replaces placeholders with your project info.
- **CHANGELOG.md**: This file.

### Removed
- Redundant content from AGENTS.md that duplicated rule files.

## [1.0.0] — 2025-01-01

Initial release of the Cursor Cognitive Boilerplate.

- Memory bank system (6 template files)
- Rule system (4 core rules + meta-guidelines)
- Append-only log system
- AGENTS.md with full agent instructions
- README with documentation
