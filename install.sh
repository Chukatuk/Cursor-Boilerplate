#!/usr/bin/env bash
set -euo pipefail

# Cursor Cognitive Boilerplate — Install into Existing Project
# Safely copies boilerplate files without overwriting anything that already exists.

BOILERPLATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=false

# ── Help ──────────────────────────────────────────────────────────────────────

usage() {
  cat <<EOF

  Cursor Cognitive Boilerplate — Install into Existing Project
  =============================================================

  Usage: ./install.sh [--dry-run] <target-directory>

  Copies boilerplate files into <target-directory> without overwriting any
  files that already exist there. Safe to run multiple times.

  What gets copied:
    .cursor/rules/          All rule files (skipped if already present)
    .cursor/mcp.json        MCP server config (skipped if already present)
    memory-bank/            All template files (skipped if already present)
    logs/                   DEVELOPMENT_LOG.md, CHAT_SUMMARY_TEMPLATE.md, chat-summaries/
    .env.example            Environment variable template (skipped if already present)
    AGENTS.md               Agent instructions (skipped if already present)
    .gitignore entries      Missing lines are appended, nothing overwritten

  What does NOT get copied:
    README.md, CHANGELOG.md, LICENSE, install.sh, validate.sh, init.sh, examples/

  After install, run:
    cd <target-directory> && bash <path-to-boilerplate>/init.sh

  Flags:
    --dry-run  Show planned copy/merge operations without writing files
    --help     Show this message and exit

EOF
}

TARGET=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h)
      usage
      exit 0
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    -*)
      echo ""
      echo "  Error: unknown flag '$1'"
      echo "  Run ./install.sh --help for usage."
      echo ""
      exit 1
      ;;
    *)
      if [ -n "$TARGET" ]; then
        echo ""
        echo "  Error: only one target directory is allowed."
        echo ""
        exit 1
      fi
      TARGET="$1"
      shift
      ;;
  esac
done

# ── Validate target ───────────────────────────────────────────────────────────

if [ -z "$TARGET" ]; then
  echo ""
  echo "  Error: target directory is required."
  echo "  Usage: ./install.sh [--dry-run] <target-directory>"
  echo "  Run ./install.sh --help for more info."
  echo ""
  exit 1
fi

if [ ! -d "$TARGET" ]; then
  echo ""
  echo "  Error: '$TARGET' is not a directory or does not exist."
  echo ""
  exit 1
fi

TARGET="$(cd "$TARGET" && pwd)"

echo ""
echo "  Cursor Cognitive Boilerplate — Installing into:"
echo "  $TARGET"
echo ""

COPIED=0
SKIPPED=0

# ── Helper: copy a single file safely ────────────────────────────────────────

copy_file() {
  local src="$1"
  local dest="$2"

  if [ -f "$dest" ]; then
    echo "  SKIP   $dest  (already exists)"
    SKIPPED=$((SKIPPED + 1))
  else
    if [ "$DRY_RUN" = true ]; then
      echo "  PLAN   $dest  (would copy)"
    else
      mkdir -p "$(dirname "$dest")"
      cp "$src" "$dest"
      echo "  COPY   $dest"
    fi
    COPIED=$((COPIED + 1))
  fi
}

# ── Helper: copy all files in a directory recursively ────────────────────────

copy_dir() {
  local src_dir="$1"
  local dest_dir="$2"

  if [ ! -d "$src_dir" ]; then
    return
  fi

  while IFS= read -r src_file; do
    local relative="${src_file#$src_dir/}"
    local dest_file="$dest_dir/$relative"
    copy_file "$src_file" "$dest_file"
  done < <(find "$src_dir" -type f)
}

# ── Copy .cursor config ───────────────────────────────────────────────────────

copy_dir "$BOILERPLATE_DIR/.cursor/rules" "$TARGET/.cursor/rules"
copy_file "$BOILERPLATE_DIR/.cursor/mcp.json" "$TARGET/.cursor/mcp.json"

# ── Copy memory-bank templates ────────────────────────────────────────────────

copy_dir "$BOILERPLATE_DIR/memory-bank" "$TARGET/memory-bank"

# ── Copy logs structure ───────────────────────────────────────────────────────

copy_file "$BOILERPLATE_DIR/logs/DEVELOPMENT_LOG.md" "$TARGET/logs/DEVELOPMENT_LOG.md"
copy_file "$BOILERPLATE_DIR/logs/CHAT_SUMMARY_TEMPLATE.md" "$TARGET/logs/CHAT_SUMMARY_TEMPLATE.md"
if [ "$DRY_RUN" = true ]; then
  if [ ! -f "$TARGET/logs/chat-summaries/.gitkeep" ]; then
    echo "  PLAN   $TARGET/logs/chat-summaries/.gitkeep  (would create)"
    COPIED=$((COPIED + 1))
  fi
else
  mkdir -p "$TARGET/logs/chat-summaries"
  if [ ! -f "$TARGET/logs/chat-summaries/.gitkeep" ]; then
    touch "$TARGET/logs/chat-summaries/.gitkeep"
    echo "  COPY   $TARGET/logs/chat-summaries/.gitkeep"
    COPIED=$((COPIED + 1))
  fi
fi

# ── Copy AGENTS.md ────────────────────────────────────────────────────────────

copy_file "$BOILERPLATE_DIR/AGENTS.md" "$TARGET/AGENTS.md"

# ── Copy .env.example ─────────────────────────────────────────────────────────

copy_file "$BOILERPLATE_DIR/.env.example" "$TARGET/.env.example"

# ── Copy .editorconfig ────────────────────────────────────────────────────────

copy_file "$BOILERPLATE_DIR/.editorconfig" "$TARGET/.editorconfig"

# ── Merge .gitignore ──────────────────────────────────────────────────────────
# Appends lines from the boilerplate .gitignore that don't already exist
# in the target's .gitignore. Never removes or overwrites existing lines.

if [ -f "$BOILERPLATE_DIR/.gitignore" ]; then
  TARGET_GITIGNORE="$TARGET/.gitignore"

  if [ ! -f "$TARGET_GITIGNORE" ]; then
    if [ "$DRY_RUN" = true ]; then
      echo "  PLAN   $TARGET_GITIGNORE  (would create new)"
    else
      cp "$BOILERPLATE_DIR/.gitignore" "$TARGET_GITIGNORE"
      echo "  COPY   $TARGET_GITIGNORE  (created new)"
    fi
    COPIED=$((COPIED + 1))
  else
    ADDED=0
    while IFS= read -r line; do
      # Skip empty lines and comment lines when checking for duplicates
      if [[ -z "$line" || "$line" == \#* ]]; then
        continue
      fi
      if ! grep -qxF "$line" "$TARGET_GITIGNORE"; then
        if [ "$DRY_RUN" = false ]; then
          echo "$line" >> "$TARGET_GITIGNORE"
        fi
        ADDED=$((ADDED + 1))
      fi
    done < "$BOILERPLATE_DIR/.gitignore"

    if [ "$ADDED" -gt 0 ]; then
      if [ "$DRY_RUN" = true ]; then
        echo "  PLAN   $TARGET_GITIGNORE  (would add $ADDED lines)"
      else
        echo "  MERGE  $TARGET_GITIGNORE  ($ADDED lines added)"
      fi
      COPIED=$((COPIED + 1))
    else
      echo "  SKIP   $TARGET_GITIGNORE  (.gitignore already has all entries)"
      SKIPPED=$((SKIPPED + 1))
    fi
  fi
fi

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
if [ "$DRY_RUN" = true ]; then
  echo "  Dry run completed."
  echo "    Planned: $COPIED items"
else
  echo "  Done."
  echo "    Copied:  $COPIED items"
fi
echo "    Skipped: $SKIPPED items (already existed)"
echo ""
echo "  Next steps:"
echo "    1. cd $TARGET"
echo "    2. Run: bash $BOILERPLATE_DIR/init.sh"
echo "       (or copy init.sh to your project first)"
echo "    3. Fill in memory-bank/techContext.md with your tech stack"
echo ""
