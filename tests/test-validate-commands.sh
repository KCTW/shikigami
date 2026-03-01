#!/usr/bin/env bash
# tests/test-validate-commands.sh
# US-T06：Command 路由驗證 — 測試套件
# 覆蓋 AC1（掃描範圍）/ AC2（引用存在性）/ AC3（frontmatter description）/ AC4（exit code）

set -uo pipefail

# ---------------------------------------------------------------------------
# 測試框架（輕量）
# ---------------------------------------------------------------------------
PASS_COUNT=0
FAIL_COUNT=0

pass() {
  echo "PASS: $1"
  PASS_COUNT=$((PASS_COUNT + 1))
}

fail() {
  echo "FAIL: $1"
  FAIL_COUNT=$((FAIL_COUNT + 1))
}

assert_exit_code() {
  local expected="$1"
  local actual="$2"
  local label="$3"
  if [ "$actual" -eq "$expected" ]; then
    pass "$label"
  else
    fail "$label (期望 exit=$expected，實際 exit=$actual)"
  fi
}

assert_output_contains() {
  local needle="$1"
  local haystack="$2"
  local label="$3"
  if echo "$haystack" | grep -qF "$needle"; then
    pass "$label"
  else
    fail "$label (輸出中找不到「$needle」)"
  fi
}

assert_output_not_contains() {
  local needle="$1"
  local haystack="$2"
  local label="$3"
  if echo "$haystack" | grep -qF "$needle"; then
    fail "$label (輸出中不應出現「$needle」)"
  else
    pass "$label"
  fi
}

# ---------------------------------------------------------------------------
# 輔助：取得腳本路徑
# ---------------------------------------------------------------------------
SCRIPT_UNDER_TEST="$(cd "$(dirname "$0")/.." && pwd)/scripts/validate-commands.sh"

# ---------------------------------------------------------------------------
# 輔助：建立隔離的臨時測試環境
# 建立 commands/ 和 skills/ 目錄結構
# ---------------------------------------------------------------------------
setup_env() {
  local tmpdir
  tmpdir=$(mktemp -d)
  mkdir -p "$tmpdir/commands"
  mkdir -p "$tmpdir/skills"
  echo "$tmpdir"
}

write_command() {
  # $1 = tmpdir, $2 = filename, $3 = frontmatter (description or empty), $4 = body
  local dir="$1"
  local filename="$2"
  local description="$3"
  local body="$4"

  if [ -n "$description" ]; then
    cat > "$dir/commands/$filename" <<EOF
---
description: "$description"
---

$body
EOF
  else
    cat > "$dir/commands/$filename" <<EOF
---
disable-model-invocation: true
---

$body
EOF
  fi
}

write_skill() {
  # $1 = tmpdir, $2 = skill name (directory name under skills/)
  local dir="$1"
  local skill_name="$2"
  mkdir -p "$dir/skills/$skill_name"
}

run_script() {
  # 在指定目錄下執行腳本，捕捉 exit code 與輸出
  local dir="$1"
  if LAST_OUTPUT=$(cd "$dir" && bash "$SCRIPT_UNDER_TEST" 2>&1); then
    LAST_EXIT_CODE=0
  else
    LAST_EXIT_CODE=$?
  fi
}

# ---------------------------------------------------------------------------
# TC-01：全部通過（3 個 commands 皆合規），exit 0
# AC1：掃描到 3 個檔案；AC2：引用存在；AC3：有 description；AC4：exit 0
# ---------------------------------------------------------------------------
test_tc01_all_pass() {
  local tmpdir
  tmpdir=$(setup_env)

  # 建立兩個有 shikigami:xxx 引用的 command
  write_command "$tmpdir" "review.md"  "執行 Sprint 回顧" \
    "Invoke the shikigami:sprint-review skill and follow it exactly as presented to you"
  write_command "$tmpdir" "sprint.md"  "啟動 Sprint 規劃" \
    "Invoke the shikigami:sprint-planning skill and follow it exactly as presented to you"
  # 建立一個無 shikigami:xxx 引用的 command（允許，只有 INFO）
  write_command "$tmpdir" "standup.md" "執行每日站立會議" \
    "執行 Daily Standup，依序完成以下三個區塊"

  # 建立對應的 skills
  write_skill "$tmpdir" "sprint-review"
  write_skill "$tmpdir" "sprint-planning"

  run_script "$tmpdir"

  assert_exit_code 0 "$LAST_EXIT_CODE" "TC-01：全部合規 exit 0"
  assert_output_contains "[PASS]" "$LAST_OUTPUT" "TC-01：輸出含 [PASS] 標記"
  assert_output_contains "review.md" "$LAST_OUTPUT" "TC-01：輸出包含 review.md"
  assert_output_contains "sprint.md" "$LAST_OUTPUT" "TC-01：輸出包含 sprint.md"
  assert_output_contains "standup.md" "$LAST_OUTPUT" "TC-01：輸出包含 standup.md"

  rm -rf "$tmpdir"
}

# ---------------------------------------------------------------------------
# TC-02：引用不存在的 skill → ERROR，exit 1
# AC2：shikigami:xxx 引用指向不存在的 skill
# ---------------------------------------------------------------------------
test_tc02_missing_skill() {
  local tmpdir
  tmpdir=$(setup_env)

  write_command "$tmpdir" "broken.md" "測試壞引用" \
    "Invoke the shikigami:nonexistent-skill skill and follow it"
  # 故意不建立 skills/nonexistent-skill

  run_script "$tmpdir"

  assert_exit_code 1 "$LAST_EXIT_CODE" "TC-02：缺少 skill 引用 exit 1"
  assert_output_contains "[ERROR]" "$LAST_OUTPUT" "TC-02：輸出含 [ERROR] 標記"
  assert_output_contains "nonexistent-skill" "$LAST_OUTPUT" "TC-02：輸出指出缺少的 skill 名稱"

  rm -rf "$tmpdir"
}

# ---------------------------------------------------------------------------
# TC-03：缺少 frontmatter description → ERROR，exit 1
# AC3：command frontmatter 必須含 description 欄位
# ---------------------------------------------------------------------------
test_tc03_missing_description() {
  local tmpdir
  tmpdir=$(setup_env)

  # 刻意使用 write_command 空字串 description → 生成無 description 的 frontmatter
  write_command "$tmpdir" "nodesc.md" "" \
    "Invoke the shikigami:sprint-planning skill"
  write_skill "$tmpdir" "sprint-planning"

  run_script "$tmpdir"

  assert_exit_code 1 "$LAST_EXIT_CODE" "TC-03：缺少 description exit 1"
  assert_output_contains "[ERROR]" "$LAST_OUTPUT" "TC-03：輸出含 [ERROR] 標記"
  assert_output_contains "nodesc.md" "$LAST_OUTPUT" "TC-03：輸出指出問題檔案"

  rm -rf "$tmpdir"
}

# ---------------------------------------------------------------------------
# TC-04：無 shikigami:xxx 引用 → INFO（不是 ERROR），exit 0
# AC2：無引用只輸出 INFO，不影響 exit code
# ---------------------------------------------------------------------------
test_tc04_no_skill_ref_is_info_not_error() {
  local tmpdir
  tmpdir=$(setup_env)

  # standup.md 風格：有 description，但無 shikigami:xxx 引用
  write_command "$tmpdir" "standalone.md" "獨立指令，無需 skill" \
    "直接執行某些操作，不使用任何 skill 引用"

  run_script "$tmpdir"

  assert_exit_code 0 "$LAST_EXIT_CODE" "TC-04：無引用 exit 0"
  assert_output_contains "[INFO]" "$LAST_OUTPUT" "TC-04：無引用輸出 [INFO] 而非 [ERROR]"
  assert_output_not_contains "[ERROR]" "$LAST_OUTPUT" "TC-04：不含 [ERROR] 標記"

  rm -rf "$tmpdir"
}

# ---------------------------------------------------------------------------
# TC-05：空 commands/ 目錄 → exit 0（不視為錯誤）
# AC1：掃描結果為空，但不應報錯
# ---------------------------------------------------------------------------
test_tc05_empty_commands_dir() {
  local tmpdir
  tmpdir=$(setup_env)
  # commands/ 目錄存在但無任何 .md 檔案

  run_script "$tmpdir"

  assert_exit_code 0 "$LAST_EXIT_CODE" "TC-05：空目錄 exit 0"
  assert_output_not_contains "[ERROR]" "$LAST_OUTPUT" "TC-05：空目錄不輸出 [ERROR]"

  rm -rf "$tmpdir"
}

# ---------------------------------------------------------------------------
# 執行所有測試
# ---------------------------------------------------------------------------
echo "=============================="
echo " US-T06 Command 路由驗證 測試套件"
echo "=============================="
echo ""

test_tc01_all_pass
test_tc02_missing_skill
test_tc03_missing_description
test_tc04_no_skill_ref_is_info_not_error
test_tc05_empty_commands_dir

echo ""
echo "=============================="
echo " 結果：PASS=$PASS_COUNT  FAIL=$FAIL_COUNT"
echo "=============================="

if [ "$FAIL_COUNT" -gt 0 ]; then
  exit 1
fi
exit 0
