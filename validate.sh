#!/usr/bin/env bash
# Cursor Cognitive Boilerplate — Validation Script
# Checks that the boilerplate is internally consistent.
# Exit 0 = all checks passed. Exit 1 = one or more checks failed.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PASS=0
FAIL=0

# ── Helpers ───────────────────────────────────────────────────────────────────

ok() {
  echo "  PASS  $1"
  PASS=$((PASS + 1))
}

fail() {
  echo "  FAIL  $1"
  FAIL=$((FAIL + 1))
}

check_file() {
  local path="$SCRIPT_DIR/$1"
  if [ -f "$path" ]; then
    ok "$1 exists"
  else
    fail "$1 is missing"
  fi
}

check_dir() {
  local path="$SCRIPT_DIR/$1"
  if [ -d "$path" ]; then
    ok "$1/ exists"
  else
    fail "$1/ directory is missing"
  fi
}

check_executable() {
  local path="$SCRIPT_DIR/$1"
  if [ -x "$path" ]; then
    ok "$1 is executable"
  else
    fail "$1 is not executable (run: chmod +x $1)"
  fi
}

check_frontmatter() {
  local path="$SCRIPT_DIR/$1"
  if [ ! -f "$path" ]; then
    fail "$1 is missing (can't check frontmatter)"
    return
  fi
  if head -1 "$path" | grep -q "^---"; then
    ok "$1 has valid frontmatter"
  else
    fail "$1 is missing YAML frontmatter (must start with ---)"
  fi
}

check_no_bak_files() {
  local count
  count=$(find "$SCRIPT_DIR" -name "*.bak" 2>/dev/null | wc -l | tr -d ' ')
  if [ "$count" -eq 0 ]; then
    ok "No leftover .bak files"
  else
    fail "$count leftover .bak file(s) found — run: find . -name '*.bak' -delete"
  fi
}

check_no_unfilled_placeholder() {
  local file="$SCRIPT_DIR/$1"
  local placeholder="$2"
  if [ ! -f "$file" ]; then
    return
  fi
  if grep -q "$placeholder" "$file"; then
    fail "$1 still contains placeholder: $placeholder"
  else
    ok "$1 has no '$placeholder' placeholder"
  fi
}

# ── Run checks ────────────────────────────────────────────────────────────────

echo ""
echo "  Cursor Cognitive Boilerplate — Validation"
echo "  ==========================================="
echo ""

# Required files
check_file "AGENTS.md"
check_file "README.md"
check_file "init.sh"
check_file "install.sh"
check_file ".gitignore"
check_file ".cursor/mcp.json"

# Scripts are executable
check_executable "init.sh"
check_executable "install.sh"
check_executable "validate.sh"

# Memory bank files
check_file "memory-bank/projectbrief.md"
check_file "memory-bank/techContext.md"
check_file "memory-bank/activeContext.md"
check_file "memory-bank/productContext.md"
check_file "memory-bank/systemPatterns.md"
check_file "memory-bank/progress.md"

# Logs structure
check_dir "logs"
check_dir "logs/chat-summaries"
check_file "logs/DEVELOPMENT_LOG.md"
check_file "logs/CHAT_SUMMARY_TEMPLATE.md"

# Rules
check_file ".cursor/rules/000-rule-management.mdc"
check_file ".cursor/rules/001-security.mdc"
check_file ".cursor/rules/001-self-improvement.mdc"
check_file ".cursor/rules/100-workflow-loop.mdc"
check_file ".cursor/rules/200-context-preservation.mdc"
check_file ".cursor/rules/creating-rules.mdc"

# Rule frontmatter
check_frontmatter ".cursor/rules/000-rule-management.mdc"
check_frontmatter ".cursor/rules/001-security.mdc"
check_frontmatter ".cursor/rules/001-self-improvement.mdc"
check_frontmatter ".cursor/rules/100-workflow-loop.mdc"
check_frontmatter ".cursor/rules/200-context-preservation.mdc"
check_frontmatter ".cursor/rules/creating-rules.mdc"

# No leftover sed backup files
check_no_bak_files

# Examples directory
check_dir "examples/todo-app"
check_file "examples/todo-app/projectbrief.md"
check_file "examples/todo-app/techContext.md"
check_file "examples/todo-app/activeContext.md"

# ── Results ───────────────────────────────────────────────────────────────────

echo ""
echo "  Results: $PASS passed, $FAIL failed"
echo ""

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
