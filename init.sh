#!/usr/bin/env bash
set -euo pipefail

# Cursor Cognitive Boilerplate — Quick Setup
# Replaces placeholders in memory-bank and log files with your project info.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=false
AUTO_YES=false
PROJECT_NAME_ARG=""
CORE_VISION_ARG=""
TARGET_AUDIENCE_ARG=""
PLACEHOLDER_REGEX='\[(PROJECT NAME|DESCRIBE THE CORE IDEA|WHO IS THIS FOR|DATE)\]'

# ── Help ──────────────────────────────────────────────────────────────────────

usage() {
  cat <<EOF

  Cursor Cognitive Boilerplate — Setup
  =====================================

  Usage:
    ./init.sh [flags]

  Interactive setup that replaces placeholders in all memory-bank and log files
  with your project name, vision, and audience.

  Flags:
    --project-name <name>      Project name (non-interactive)
    --vision <text>            One-sentence project description (non-interactive)
    --audience <text>          Target audience (non-interactive)
    --yes, -y                  Accept defaults for missing values and prompts
    --dry-run                  Show planned changes without writing files
    --help, -h                 Show this message and exit

  Notes:
    - Run this once, from the project root where memory-bank/ lives.
    - Safe to re-run: exits early if placeholders have already been replaced
      across memory-bank/ and logs/DEVELOPMENT_LOG.md.
    - Does NOT modify any .cursor/rules/ files.
    - Does NOT modify .env.example.

EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h)
      usage
      exit 0
      ;;
    --project-name)
      PROJECT_NAME_ARG="${2:-}"
      shift 2
      ;;
    --project-name=*)
      PROJECT_NAME_ARG="${1#*=}"
      shift
      ;;
    --vision)
      CORE_VISION_ARG="${2:-}"
      shift 2
      ;;
    --vision=*)
      CORE_VISION_ARG="${1#*=}"
      shift
      ;;
    --audience)
      TARGET_AUDIENCE_ARG="${2:-}"
      shift 2
      ;;
    --audience=*)
      TARGET_AUDIENCE_ARG="${1#*=}"
      shift
      ;;
    --yes|-y)
      AUTO_YES=true
      shift
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    *)
      echo ""
      echo "  Error: unknown flag '$1'"
      echo "  Run ./init.sh --help for usage."
      echo ""
      exit 1
      ;;
  esac
done

# ── Portable in-place sed ─────────────────────────────────────────────────────
# macOS sed requires an extension argument (-i ''), GNU sed uses -i without one.

sed_inplace() {
  local pattern="$1"
  local file="$2"
  if sed --version 2>/dev/null | grep -q GNU; then
    sed -i "$pattern" "$file"
  else
    sed -i '' "$pattern" "$file"
  fi
}

# ── Escape a string for use as a sed replacement ─────────────────────────────
# Escapes &, \, and the delimiter / so user input can't break the sed command.

escape_for_sed() {
  printf '%s' "$1" | sed 's/[&/\]/\\&/g'
}

# ── Idempotency check ─────────────────────────────────────────────────────────

has_unfilled_placeholders() {
  local files=(
    "$SCRIPT_DIR/memory-bank/projectbrief.md"
    "$SCRIPT_DIR/memory-bank/techContext.md"
    "$SCRIPT_DIR/memory-bank/activeContext.md"
    "$SCRIPT_DIR/memory-bank/productContext.md"
    "$SCRIPT_DIR/memory-bank/systemPatterns.md"
    "$SCRIPT_DIR/memory-bank/progress.md"
    "$SCRIPT_DIR/logs/DEVELOPMENT_LOG.md"
  )
  grep -Eq "$PLACEHOLDER_REGEX" "${files[@]}"
}

if ! has_unfilled_placeholders; then
  echo ""
  echo "  It looks like init.sh has already been run (no placeholders found)."
  echo "  Edit memory-bank/ files directly if you need to update project info."
  echo ""
  exit 0
fi

# ── Prompts ───────────────────────────────────────────────────────────────────

echo ""
echo "  Cursor Cognitive Boilerplate — Setup"
echo "  ====================================="
echo ""

PROJECT_NAME="$PROJECT_NAME_ARG"
CORE_VISION="$CORE_VISION_ARG"
TARGET_AUDIENCE="$TARGET_AUDIENCE_ARG"

if [[ -z "$PROJECT_NAME" && "$AUTO_YES" == true ]]; then
  PROJECT_NAME="$(basename "$PWD")"
fi
if [[ -z "$CORE_VISION" && "$AUTO_YES" == true ]]; then
  CORE_VISION="A project built with the Cursor Cognitive Boilerplate."
fi
if [[ -z "$TARGET_AUDIENCE" && "$AUTO_YES" == true ]]; then
  TARGET_AUDIENCE="The development team"
fi

if [[ -z "$PROJECT_NAME" ]]; then
  read -rp "  Project name: " PROJECT_NAME
fi
if [ -z "$PROJECT_NAME" ]; then
  echo "  Error: project name is required."
  exit 1
fi

if [ -z "$CORE_VISION" ]; then
  read -rp "  One-sentence description: " CORE_VISION
  if [ -z "$CORE_VISION" ]; then
    CORE_VISION="A project built with the Cursor Cognitive Boilerplate."
  fi
fi

if [ -z "$TARGET_AUDIENCE" ]; then
  read -rp "  Target audience (who is this for?): " TARGET_AUDIENCE
  if [ -z "$TARGET_AUDIENCE" ]; then
    TARGET_AUDIENCE="The development team"
  fi
fi

TODAY=$(date +%Y-%m-%d)

# Escape values for safe sed substitution
SAFE_PROJECT_NAME="$(escape_for_sed "$PROJECT_NAME")"
SAFE_CORE_VISION="$(escape_for_sed "$CORE_VISION")"
SAFE_TARGET_AUDIENCE="$(escape_for_sed "$TARGET_AUDIENCE")"
SAFE_TODAY="$(escape_for_sed "$TODAY")"

# ── Replace placeholders ──────────────────────────────────────────────────────

if [[ "$DRY_RUN" == true ]]; then
  echo "  DRY RUN: no files will be modified."
  echo "  Planned replacements:"
  echo "    - [PROJECT NAME] -> $PROJECT_NAME"
  echo "    - [DESCRIBE THE CORE IDEA] -> $CORE_VISION"
  echo "    - [WHO IS THIS FOR] -> $TARGET_AUDIENCE"
  echo "    - [DATE] -> $TODAY"
else
  # projectbrief.md — project name, vision, audience, and date
  sed_inplace "s/\[PROJECT NAME\]/$SAFE_PROJECT_NAME/g" "$SCRIPT_DIR/memory-bank/projectbrief.md"
  sed_inplace "s/\[DESCRIBE THE CORE IDEA\]/$SAFE_CORE_VISION/g" "$SCRIPT_DIR/memory-bank/projectbrief.md"
  sed_inplace "s/\[WHO IS THIS FOR\]/$SAFE_TARGET_AUDIENCE/g" "$SCRIPT_DIR/memory-bank/projectbrief.md"

  # All memory-bank files — replace [DATE]
  for f in "$SCRIPT_DIR"/memory-bank/*.md; do
    sed_inplace "s/\[DATE\]/$SAFE_TODAY/g" "$f"
  done

  # Log files — replace [DATE]
  for f in "$SCRIPT_DIR"/logs/DEVELOPMENT_LOG.md; do
    [ -f "$f" ] && sed_inplace "s/\[DATE\]/$SAFE_TODAY/g" "$f"
  done
fi

# ── Reset activeContext to a clean project-start state ────────────────────────

if [[ "$DRY_RUN" != true ]]; then
  cat > "$SCRIPT_DIR/memory-bank/activeContext.md" << ACTIVE
# Active Context *(required)*

> The AI's working memory. Reflects the current state of work.
> Updated at the end of every work session and after significant tasks.
> The AI reads this at the start of every session.

---

## Current Focus

Project just initialized. Fill in the remaining memory bank files and start building.

## Work in Progress

- [ ] Fill in \`memory-bank/techContext.md\` with the technology stack
- [ ] (Optional) Fill in \`memory-bank/systemPatterns.md\`, \`memory-bank/productContext.md\`, \`memory-bank/progress.md\`

## Recently Completed

- [x] Initialized project from Cursor Cognitive Boilerplate — $TODAY

## Immediate Next Steps

1. Fill in \`memory-bank/techContext.md\` with your tech stack
2. Delete or adapt the example rules in \`.cursor/rules/300-*-example.mdc\`
3. Start building

## Notes / Decisions Made

- $TODAY: Project initialized from Cursor Cognitive Boilerplate

---

*Last updated: $TODAY*
ACTIVE
else
  echo "  DRY RUN: would reset memory-bank/activeContext.md to a fresh project-start template."
fi

# ── Git Init ──────────────────────────────────────────────────────────────────

if [ ! -d ".git" ]; then
  if command -v git >/dev/null 2>&1; then
    echo ""
    if [[ "$AUTO_YES" == true ]]; then
      INIT_GIT="y"
      echo "  Initialize git repository? (y/N) y  (--yes)"
    else
      read -rp "  Initialize git repository? (y/N) " INIT_GIT
    fi
    if [[ "$INIT_GIT" =~ ^[Yy]$ ]]; then
      if [[ "$DRY_RUN" == true ]]; then
        echo "  DRY RUN: would run git init"
      else
        git init
        echo "  Initialized git repository."
      fi
    fi
  fi
fi

# ── Done ──────────────────────────────────────────────────────────────────────

echo ""
if [[ "$DRY_RUN" == true ]]; then
  echo "  Dry run completed."
  echo "  No files were modified."
else
  echo "  Done! Files updated:"
  echo "    - memory-bank/projectbrief.md  (name, vision, audience filled in)"
  echo "    - memory-bank/activeContext.md  (reset for fresh start)"
  echo "    - All [DATE] placeholders set to $TODAY"
fi
echo ""
echo "  Next steps:"
echo "    1. Fill in memory-bank/techContext.md with your tech stack"
echo "    2. Delete or adapt the example rules: .cursor/rules/300-*-example.mdc"
echo "    3. Add real values to .env.example for first-time integrations"
echo "    4. Open Cursor and start building!"
echo ""
