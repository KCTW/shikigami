#!/usr/bin/env bash
# preflight_check.sh — shikigami 環境驗證腳本（模板）
# 在 Agent 執行前驗證環境就緒，避免靜默失敗導致 Agent 幻覺
# 用法：bash scripts/preflight_check.sh
#
# [根據你的專案調整] 新增或移除檢查項目。
# 範例：API key、Docker、MCP Server、資料庫連線等。

set -euo pipefail

# --- Helpers ---
red()    { printf '\033[0;31m%s\033[0m\n' "$1"; }
green()  { printf '\033[0;32m%s\033[0m\n' "$1"; }
yellow() { printf '\033[0;33m%s\033[0m\n' "$1"; }

ERRORS=0
WARNINGS=0

# ============================================================
# CHECK 1: 必要環境變數
# ============================================================
echo "--- Check 1: 環境變數 ---"

# [根據你的專案調整] 列出必要的環境變數
REQUIRED_VARS="ANTHROPIC_API_KEY"
# 範例：REQUIRED_VARS="ANTHROPIC_API_KEY GITHUB_TOKEN DATABASE_URL"

for var in $REQUIRED_VARS; do
    if [ -z "${!var:-}" ]; then
        red "  ✗ $var 未設定"
        ERRORS=$((ERRORS + 1))
    else
        green "  ✓ $var 已設定"
    fi
done

# ============================================================
# CHECK 2: 外部服務連通性
# ============================================================
echo "--- Check 2: 外部服務 ---"

# [根據你的專案調整] Docker 可用性
if command -v docker &>/dev/null; then
    if docker info &>/dev/null 2>&1; then
        green "  ✓ Docker 可用"
    else
        red "  ✗ Docker 已安裝但無法連線（檢查 daemon 或 group 權限）"
        ERRORS=$((ERRORS + 1))
    fi
else
    yellow "  ⚠ Docker 未安裝（如不需要可忽略）"
    WARNINGS=$((WARNINGS + 1))
fi

# [根據你的專案調整] 其他服務檢查
# 範例：GitHub API 連通性
# if [ -n "${GITHUB_TOKEN:-}" ]; then
#     if curl -sf -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user >/dev/null 2>&1; then
#         green "  ✓ GitHub API 可連通"
#     else
#         red "  ✗ GitHub API 連線失敗（檢查 token 權限）"
#         ERRORS=$((ERRORS + 1))
#     fi
# fi

# ============================================================
# CHECK 3: 必要工具版本
# ============================================================
echo "--- Check 3: 工具版本 ---"

# [根據你的專案調整] Node.js 版本
if command -v node &>/dev/null; then
    NODE_VERSION=$(node --version)
    green "  ✓ Node.js $NODE_VERSION"
else
    yellow "  ⚠ Node.js 未安裝"
    WARNINGS=$((WARNINGS + 1))
fi

# ============================================================
# Summary
# ============================================================
echo ""
echo "--- Preflight Summary ---"
if [ "$ERRORS" -gt 0 ]; then
    red "BLOCKED: $ERRORS error(s). 修正後再執行 Agent。"
    [ "$WARNINGS" -gt 0 ] && yellow "另有 $WARNINGS 項警告。"
    exit 1
else
    if [ "$WARNINGS" -gt 0 ]; then
        yellow "PASSED（$WARNINGS 項警告）"
    else
        green "ALL CHECKS PASSED. 環境就緒。"
    fi
    exit 0
fi
