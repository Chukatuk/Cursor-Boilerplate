# Changelog

All notable changes to the Cursor Cognitive Boilerplate are documented here.

## [3.2.0] — 2026-02-23

Improved setup safety, added script automation flags, and strengthened validation.

### Added
- **`.env.example`**: New first-time integration template for environment variables.
- **`init.sh` flags**: Added `--project-name`, `--vision`, `--audience`, `--yes`, and `--dry-run` for non-interactive or preview setup.
- **`install.sh --dry-run`**: Preview copy/merge operations without writing files.
- **`validate.sh --strict`**: Extra checks that fail when required files still contain unfilled placeholders.

### Changed
- **Quick start copy command in `README.md`** now uses a dotfile-safe copy command (`cp -R source/. target/`) so `.cursor/` and other dotfiles are included.
- **`init.sh` idempotency check** now verifies placeholders across all required memory files plus `logs/DEVELOPMENT_LOG.md`, not just one file.
- **`install.sh`** now copies `.env.example` into target projects.
- **`validate.sh`** now checks that `.env.example` exists.

## [3.1.0] — 2026-02-23

Reduced context window overhead, added code quality rule, improved separation of concerns.

### Added
- **`100-quality.mdc`**: New always-on rule — run tests after logic changes, check lints after edits, don't leave broken imports.
- **`200-chat-summaries.mdc`**: New on-demand rule — guidelines for creating chat summaries (naming, categories, format, best practices). Extracted from the old 179-line `CHAT_SUMMARY_TEMPLATE.md`.
- **`LICENSE`**: MIT license file.
- **`install.sh`** now copies `.cursor/mcp.json` to the target project (was previously missing).

### Changed
- **Reduced `alwaysApply: true` rules from 6 to 3.** Only `001-security`, `100-workflow-loop`, and `100-quality` are always-on. The rest activate on demand via description matching or globs:
  - `000-rule-management` and `000-creating-rules`: glob-triggered on `.cursor/rules/**`
  - `001-self-improvement`: description-triggered
  - `200-context-preservation` and `200-chat-summaries`: description-triggered
- **`creating-rules.mdc`** renamed to **`000-creating-rules.mdc`** to follow the numeric prefix convention.
- **`AGENTS.md`** slimmed further — removed the duplicated memory bank table (already documented in the workflow rule and README). Added step to read `techContext.md` at session start.
- **`logs/CHAT_SUMMARY_TEMPLATE.md`** reduced from 179 lines to ~75 — now contains only the copy-paste template. All guidelines moved to `200-chat-summaries.mdc`.

### Removed
- `creating-rules.mdc` (unnumbered) — replaced by `000-creating-rules.mdc`.

## [3.0.0] — 2026-02-23

Major overhaul: safer scripts, richer history system, tighter rules.

### Added
- **`install.sh`**: New script to safely install the boilerplate into an existing project. Uses `--ignore-existing` semantics — never overwrites files, merges `.gitignore` entries.
- **`validate.sh`**: New script that checks the boilerplate is internally consistent (all files exist, scripts executable, rule frontmatter valid, no `.bak` files). 36 checks, exits 1 on failure.
- **`001-security.mdc`**: New always-on rule — never commit secrets, never hardcode credentials, always use environment variables.
- **`logs/DEVELOPMENT_LOG.md`**: Reverse-chronological index of all significant sessions, replacing `LOG_INDEX.md`.
- **`logs/CHAT_SUMMARY_TEMPLATE.md`**: Full guidelines and template for creating per-session summaries (inspired by structured chat-summary workflows). Includes naming convention, categories, best practices, and a copy-paste template.
- **`logs/chat-summaries/`**: Directory for individual session summary files (`YYYYMMDD-description.md`).
- **Optional MCP servers** documented in README with copy-paste JSON blocks (git, filesystem, Playwright).
- **`examples/todo-app/chat-summary-example.md`**: Filled-in example of a chat summary for the todo app.

### Changed
- **`init.sh`** fully rewritten: cross-platform `sed` (macOS + Linux), input escaping for special characters, replaces `[DATE]` in ALL memory-bank and log files (not just 2), `--help` flag, idempotency check.
- **`logs/` system** replaced: `LOG_001.md` + `LOG_INDEX.md` rotation replaced by the `chat-summaries/` + `DEVELOPMENT_LOG.md` system. Summaries are richer, more searchable, and designed for long-term history.
- **`200-context-preservation.mdc`**: Updated to reference the new chat-summaries system. Session-start behavior removed (lives only in `AGENTS.md` now).
- **`AGENTS.md`**: Session start now references `DEVELOPMENT_LOG.md` instead of `LOG_INDEX.md`. Deduplicated from `200-context-preservation.mdc`.
- **`creating-rules.mdc`**: Changed from `alwaysApply: false` (glob-triggered) to `alwaysApply: true` — it's small and should always be active.
- **`300-typescript-example.mdc`** and **`300-python-example.mdc`**: Error-handling patterns reframed as "this project's approach" rather than universal best practice.
- **`mcp.json`**: Slimmed to 2 zero-friction servers (`context7` + `sequential-thinking`). `git` and `filesystem` moved to README as optional copy-paste blocks.
- **Memory bank templates**: All 6 files rewritten. Rigid `[PLACEHOLDER]` tables replaced with `<!-- instructional comments -->` that explain what to write. Section headers preserved for AI parsing.

### Removed
- `logs/LOG_INDEX.md` — replaced by `DEVELOPMENT_LOG.md`
- `logs/LOG_001.md` — replaced by `logs/chat-summaries/`

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
