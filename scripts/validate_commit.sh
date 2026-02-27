#!/usr/bin/env bash
# validate_commit.sh — shikigami pre-commit validation
# Enforces: secret detection, snake_case filenames, SDD references
# Language-agnostic: pure shell, no npm/pip dependency

set -euo pipefail

# --- Configuration ---

# Files allowed to use UPPER_CASE names (convention)
UPPERCASE_WHITELIST="CLAUDE\.md|CLAUDE\.md\.template|README\.md|README\..*\.md|LICENSE|Makefile|Dockerfile|PLAYBOOK\.md|RACI\.md|ROADMAP\.md|PRODUCT_BACKLOG\.md|DISCOVERY\.md|DISCOVERY_RETRO\.md|BUSINESS_PLAN\.md|UI_STYLE_GUIDE\.md|Retrospective_Log\.md|PROJECT_BOARD\.md|CHANGELOG\.md|CONTRIBUTING\.md|SECURITY\.md"

# Directories excluded from filename checks (vendor, generated)
EXCLUDED_DIRS="node_modules/|\.git/|dist/|build/|vendor/|\.venv/"

# Source file extensions that should have SDD references
SDD_EXTENSIONS="\.(ts|py|go|rs|java|js|tsx|jsx)$"

# Secret patterns (blocking)
SECRET_PATTERNS="sk-ant-|ghp_|gho_|github_pat_|AKIA[A-Z0-9]"

# --- State ---
ERRORS=0
WARNINGS=0

# --- Helpers ---

red()    { printf '\033[0;31m%s\033[0m\n' "$1"; }
yellow() { printf '\033[0;33m%s\033[0m\n' "$1"; }
green()  { printf '\033[0;32m%s\033[0m\n' "$1"; }

# --- Detect context ---
# If running as a git hook, check staged files; otherwise check all tracked files
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM 2>/dev/null || true)
    if [ -z "$STAGED_FILES" ]; then
        # Not in a commit context — validate all tracked files
        STAGED_FILES=$(git ls-files 2>/dev/null || true)
    fi
else
    echo "Not in a git repository. Exiting."
    exit 1
fi

if [ -z "$STAGED_FILES" ]; then
    green "No files to validate."
    exit 0
fi

# ============================================================
# CHECK 1: .env files must never be committed
# ============================================================
echo "--- Check 1: .env files ---"

ENV_FILES=$(echo "$STAGED_FILES" | grep -E '(^|/)\.env($|\.)' | grep -vE '\.(example|sample|template)$' || true)
if [ -n "$ENV_FILES" ]; then
    red "BLOCKED: .env file(s) detected in commit:"
    echo "$ENV_FILES" | while read -r f; do red "  - $f"; done
    ERRORS=$((ERRORS + 1))
else
    green "  OK: No .env files."
fi

# ============================================================
# CHECK 2: Secret patterns in file contents
# ============================================================
echo "--- Check 2: Secret patterns ---"

for file in $STAGED_FILES; do
    # Skip binary files and deleted files
    [ ! -f "$file" ] && continue

    # Skip this script itself (contains patterns as definitions, not secrets)
    if [ "$(basename "$file")" = "validate_commit.sh" ]; then
        continue
    fi

    # Only check text files
    if file --brief --mime-type "$file" 2>/dev/null | grep -qv '^text/'; then
        continue
    fi

    # For staged context, check the staged version; fallback to working copy
    CONTENT=$(git show ":$file" 2>/dev/null || cat "$file" 2>/dev/null || true)
    MATCHES=$(echo "$CONTENT" | grep -nE "$SECRET_PATTERNS" 2>/dev/null || true)

    if [ -n "$MATCHES" ]; then
        red "BLOCKED: Potential secret found in $file:"
        echo "$MATCHES" | head -5 | while read -r line; do red "  $line"; done
        ERRORS=$((ERRORS + 1))
    fi
done

if [ "$ERRORS" -eq 0 ]; then
    green "  OK: No secret patterns detected."
fi

# ============================================================
# CHECK 3: Filename must be snake_case (English)
# ============================================================
echo "--- Check 3: Filename convention (snake_case) ---"

FILENAME_ERRORS=0
for file in $STAGED_FILES; do
    # Skip excluded directories
    if echo "$file" | grep -qE "$EXCLUDED_DIRS"; then
        continue
    fi

    # Get just the filename (basename)
    basename=$(basename "$file")

    # Skip whitelisted uppercase files
    if echo "$basename" | grep -qE "^($UPPERCASE_WHITELIST)$"; then
        continue
    fi

    # Skip hidden files (dotfiles like .gitignore, .eslintrc)
    if echo "$basename" | grep -qE '^\.' ; then
        continue
    fi

    # Skip files with only extensions (e.g., no basename before extension)
    # Allow: snake_case with optional dots for extensions, digits, hyphens in config files
    # Pattern: must be ASCII, lowercase + underscore + digits + hyphens + dots
    if ! echo "$basename" | grep -qE '^[a-z0-9][a-z0-9_.-]*$'; then
        red "BLOCKED: Non-snake_case filename: $file"
        FILENAME_ERRORS=$((FILENAME_ERRORS + 1))
        ERRORS=$((ERRORS + 1))
    fi
done

if [ "$FILENAME_ERRORS" -eq 0 ]; then
    green "  OK: All filenames follow snake_case convention."
fi

# ============================================================
# CHECK 4: SDD references in source files (warning only)
# ============================================================
echo "--- Check 4: SDD references (warning) ---"

SDD_WARNINGS=0
for file in $STAGED_FILES; do
    [ ! -f "$file" ] && continue

    # Only check source files
    if ! echo "$file" | grep -qE "$SDD_EXTENSIONS"; then
        continue
    fi

    # Skip excluded directories
    if echo "$file" | grep -qE "$EXCLUDED_DIRS"; then
        continue
    fi

    # Skip test files and config files
    if echo "$file" | grep -qE '(test|spec|config|\.config)\.' ; then
        continue
    fi

    CONTENT=$(git show ":$file" 2>/dev/null || cat "$file" 2>/dev/null || true)
    if ! echo "$CONTENT" | grep -qE '\[REF: SDD-' 2>/dev/null; then
        yellow "  WARNING: No [REF: SDD-xxx] found in $file"
        SDD_WARNINGS=$((SDD_WARNINGS + 1))
        WARNINGS=$((WARNINGS + 1))
    fi
done

if [ "$SDD_WARNINGS" -eq 0 ]; then
    green "  OK: All source files have SDD references."
fi

# ============================================================
# Summary
# ============================================================
echo ""
echo "--- Summary ---"
if [ "$ERRORS" -gt 0 ]; then
    red "COMMIT BLOCKED: $ERRORS error(s) found."
    if [ "$WARNINGS" -gt 0 ]; then
        yellow "Also: $WARNINGS warning(s)."
    fi
    exit 1
else
    if [ "$WARNINGS" -gt 0 ]; then
        yellow "PASSED with $WARNINGS warning(s)."
    else
        green "ALL CHECKS PASSED."
    fi
    exit 0
fi
