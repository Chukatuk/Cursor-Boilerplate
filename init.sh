#!/usr/bin/env bash
set -euo pipefail

# Cursor Cognitive Boilerplate — Quick Setup
# Replaces placeholders in memory-bank and log files with your project info.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Help ──────────────────────────────────────────────────────────────────────

usage() {
  cat <<EOF

  Cursor Cognitive Boilerplate — Setup
  =====================================

  Usage: ./init.sh [--help]

  Interactive setup that replaces placeholders in all memory-bank and log files
  with your project name, vision, and audience.

  Flags:
    --help    Show this message and exit

  Notes:
    - Run this once, from the project root where memory-bank/ lives.
    - Safe to re-run: exits early if placeholders have already been replaced.
    - Does NOT modify any .cursor/rules/ files.

EOF
}

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  usage
  exit 0
fi

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

if ! grep -q "\[PROJECT NAME\]" "$SCRIPT_DIR/memory-bank/projectbrief.md" 2>/dev/null; then
  echo ""
  echo "  It looks like init.sh has already been run (placeholders are gone)."
  echo "  Edit memory-bank/ files directly if you need to update your project info."
  echo ""
  exit 0
fi

# ── Prompts ───────────────────────────────────────────────────────────────────

echo ""
echo "  Cursor Cognitive Boilerplate — Setup"
echo "  ====================================="
echo ""

read -rp "  Project name: " PROJECT_NAME
if [ -z "$PROJECT_NAME" ]; then
  echo "  Error: project name is required."
  exit 1
fi

read -rp "  One-sentence description: " CORE_VISION
if [ -z "$CORE_VISION" ]; then
  CORE_VISION="A project built with the Cursor Cognitive Boilerplate."
fi

read -rp "  Target audience (who is this for?): " TARGET_AUDIENCE
if [ -z "$TARGET_AUDIENCE" ]; then
  TARGET_AUDIENCE="The development team"
fi

TODAY=$(date +%Y-%m-%d)

# Escape values for safe sed substitution
SAFE_PROJECT_NAME="$(escape_for_sed "$PROJECT_NAME")"
SAFE_CORE_VISION="$(escape_for_sed "$CORE_VISION")"
SAFE_TARGET_AUDIENCE="$(escape_for_sed "$TARGET_AUDIENCE")"
SAFE_TODAY="$(escape_for_sed "$TODAY")"

# ── Replace placeholders ──────────────────────────────────────────────────────

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

# ── Reset activeContext to a clean project-start state ────────────────────────

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

# ── Git Init ──────────────────────────────────────────────────────────────────

if [ ! -d ".git" ]; then
  if command -v git >/dev/null 2>&1; then
    echo ""
    read -rp "  Initialize git repository? (y/N) " INIT_GIT
    if [[ "$INIT_GIT" =~ ^[Yy]$ ]]; then
      git init
      echo "  Initialized git repository."
    fi
  fi
fi

# ── Done ──────────────────────────────────────────────────────────────────────

echo ""
echo "  Done! Files updated:"
echo "    - memory-bank/projectbrief.md  (name, vision, audience filled in)"
echo "    - memory-bank/activeContext.md  (reset for fresh start)"
echo "    - All [DATE] placeholders set to $TODAY"
echo ""
echo "  Next steps:"
echo "    1. Fill in memory-bank/techContext.md with your tech stack"
echo "    2. Delete or adapt the example rules: .cursor/rules/300-*-example.mdc"
echo "    3. Open Cursor and start building!"
echo ""
