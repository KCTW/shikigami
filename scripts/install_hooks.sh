#!/usr/bin/env bash
# install_hooks.sh — Install shikigami git hooks
# Idempotent: safe to run multiple times

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HOOKS_DIR="$REPO_ROOT/.git/hooks"

# Ensure we're in a git repo
if [ ! -d "$REPO_ROOT/.git" ]; then
    echo "Error: $REPO_ROOT is not a git repository."
    exit 1
fi

# Create hooks directory if missing
mkdir -p "$HOOKS_DIR"

# Install pre-commit hook
PRE_COMMIT="$HOOKS_DIR/pre-commit"
VALIDATE_SCRIPT="$SCRIPT_DIR/validate_commit.sh"

if [ ! -f "$VALIDATE_SCRIPT" ]; then
    echo "Error: validate_commit.sh not found at $VALIDATE_SCRIPT"
    exit 1
fi

# Write the hook (overwrites any existing one)
cat > "$PRE_COMMIT" << 'HOOK'
#!/usr/bin/env bash
# shikigami pre-commit hook — installed by scripts/install_hooks.sh
# To bypass in emergencies: git commit --no-verify

REPO_ROOT="$(git rev-parse --show-toplevel)"
exec bash "$REPO_ROOT/scripts/validate_commit.sh"
HOOK

chmod +x "$PRE_COMMIT"
chmod +x "$VALIDATE_SCRIPT"

echo "pre-commit hook installed successfully."
echo "  Hook: $PRE_COMMIT"
echo "  Script: $VALIDATE_SCRIPT"
echo ""
echo "To bypass in emergencies: git commit --no-verify"
