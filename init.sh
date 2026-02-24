#!/usr/bin/env bash
set -euo pipefail

# Cursor Cognitive Boilerplate — Quick Setup
# Replaces placeholders in memory-bank files with your project info.

echo ""
echo "  Cursor Cognitive Boilerplate — Setup"
echo "  ====================================="
echo ""

# Get project name
read -rp "  Project name: " PROJECT_NAME
if [ -z "$PROJECT_NAME" ]; then
  echo "  Error: project name is required."
  exit 1
fi

# Get core vision
read -rp "  One-sentence description: " CORE_VISION
if [ -z "$CORE_VISION" ]; then
  CORE_VISION="[DESCRIBE THE CORE IDEA]"
fi

# Get target audience
read -rp "  Target audience (who is this for?): " TARGET_AUDIENCE
if [ -z "$TARGET_AUDIENCE" ]; then
  TARGET_AUDIENCE="[WHO IS THIS FOR]"
fi

TODAY=$(date +%Y-%m-%d)

# Replace placeholders in projectbrief.md
sed -i.bak "s/\[PROJECT NAME\]/$PROJECT_NAME/g" memory-bank/projectbrief.md
sed -i.bak "s/\[DESCRIBE THE CORE IDEA\]/$CORE_VISION/g" memory-bank/projectbrief.md
sed -i.bak "s/\[WHO IS THIS FOR\]/$TARGET_AUDIENCE/g" memory-bank/projectbrief.md

# Set dates across all memory bank files
for f in memory-bank/*.md; do
  sed -i.bak "s/\[DATE\]/$TODAY/g" "$f"
done

# Clean up sed backup files
rm -f memory-bank/*.md.bak

# Reset activeContext to show project just started
cat > memory-bank/activeContext.md << ACTIVE
# Active Context *(required)*

> The AI's working memory. Reflects the current state of work.
> Updated at the end of every work session and after significant tasks.
> The AI reads this at the start of every session.

---

## Current Focus

Project just initialized. Fill in remaining memory bank files and start building.

## Work in Progress

- [ ] Fill in techContext.md with the technology stack
- [ ] (Optional) Fill in systemPatterns.md, productContext.md, progress.md

## Recently Completed

- [x] Initialized project from Cursor Cognitive Boilerplate — $TODAY

## Immediate Next Steps

1. Fill in memory-bank/techContext.md with your tech stack
2. Delete example rules in .cursor/rules/300-*-example.mdc (or adapt them)
3. Start building

## Notes / Decisions Made

- $TODAY: Project initialized from Cursor Cognitive Boilerplate

---

*Last updated: $TODAY*
ACTIVE

echo ""
echo "  Done! Files updated:"
echo "    - memory-bank/projectbrief.md  (name, vision, audience filled in)"
echo "    - memory-bank/activeContext.md  (reset for fresh start)"
echo "    - All dates set to $TODAY"
echo ""
echo "  Next steps:"
echo "    1. Fill in memory-bank/techContext.md with your tech stack"
echo "    2. Delete or adapt the example rules: .cursor/rules/300-*-example.mdc"
echo "    3. Open Cursor and start building!"
echo ""
