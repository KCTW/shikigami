#!/usr/bin/env bash
# scripts/validate-commands.sh
# US-T06：Command 路由驗證
#
# 驗證 commands/ 下所有 .md 檔案的路由正確性：
#   AC1：掃描 commands/ 下所有 .md，輸出檔案清單，數量與實際一致
#   AC2：shikigami:xxx 引用指向存在的 skill；無引用 → INFO 而非 ERROR
#   AC3：command frontmatter 含 description 欄位
#   AC4：exit 0 = 全通過，非 0 = 有 ERROR（INFO 不影響 exit code）
#
# 使用方式：
#   bash scripts/validate-commands.sh
#   （在專案根目錄下執行；commands/ 與 skills/ 目錄相對於 cwd）
#
# Exit code:
#   0 = 全部通過（PASS / INFO）
#   1 = 有 ERROR
#
# 依賴：bash >= 4, grep

set -uo pipefail

# ---------------------------------------------------------------------------
# 常數
# ---------------------------------------------------------------------------
readonly COMMANDS_DIR="commands"
readonly SKILLS_DIR="skills"

# ---------------------------------------------------------------------------
# 狀態追蹤
# ---------------------------------------------------------------------------
EXIT_CODE=0
ERROR_COUNT=0
FILE_COUNT=0

# ---------------------------------------------------------------------------
# 輔助函式
# ---------------------------------------------------------------------------
print_pass() {
  echo "[PASS] $1"
}

print_error() {
  echo "[ERROR] $1"
  EXIT_CODE=1
  ERROR_COUNT=$((ERROR_COUNT + 1))
}

print_info() {
  echo "[INFO] $1"
}

print_section() {
  echo ""
  echo "--- $1"
}

# ---------------------------------------------------------------------------
# 前置檢查：commands/ 目錄必須存在；skills/ 目錄不存在時給出提示
# ---------------------------------------------------------------------------
preflight_check() {
  if [ ! -d "$COMMANDS_DIR" ]; then
    echo "[ERROR] 找不到目錄：$COMMANDS_DIR"
    exit 1
  fi

  if [ ! -d "$SKILLS_DIR" ]; then
    print_info "找不到 $SKILLS_DIR/ 目錄，所有 shikigami:xxx 引用將視為不存在"
  fi
}

# ---------------------------------------------------------------------------
# AC1：掃描 commands/ 下所有 .md，輸出清單與數量
# 回傳值：將檔案路徑逐行寫入 stdout（供呼叫端讀取）
# ---------------------------------------------------------------------------
scan_commands() {
  find "$COMMANDS_DIR" -maxdepth 1 -name "*.md" | sort
}

# ---------------------------------------------------------------------------
# AC3：檢查 frontmatter 是否含 description 欄位
# 參數：$1 = 檔案路徑
# 回傳：0 = 有 description，1 = 無
# ---------------------------------------------------------------------------
has_description() {
  local filepath="$1"
  # frontmatter 位於 --- 和 --- 之間；description 欄位需在此範圍內
  # 使用 awk 抽取第一個 frontmatter 區塊後，再用 grep 搜尋
  awk '/^---/{c++; if(c==2) exit} c==1' "$filepath" \
    | grep -qE '^description[[:space:]]*:'
}

# ---------------------------------------------------------------------------
# AC2：從檔案內容提取所有 shikigami:xxx 引用
# 參數：$1 = 檔案路徑
# 輸出：每行一個 skill 名稱（去除 shikigami: 前綴）
# ---------------------------------------------------------------------------
extract_skill_refs() {
  local filepath="$1"
  # 匹配 shikigami:skill-name 格式（skill 名稱由英文字母、數字、連字號組成）
  grep -oE 'shikigami:[a-zA-Z0-9_-]+' "$filepath" \
    | sed 's/shikigami://' \
    || true  # grep 無匹配時 exit 1，使用 || true 避免 pipefail 中止
}

# ---------------------------------------------------------------------------
# AC2：驗證 skill 是否存在於 skills/ 目錄
# 參數：$1 = skill 名稱
# 回傳：0 = 存在，1 = 不存在
# ---------------------------------------------------------------------------
skill_exists() {
  local skill_name="$1"
  [ -d "$SKILLS_DIR/$skill_name" ]
}

# ---------------------------------------------------------------------------
# 驗證單一 command 檔案（AC2 + AC3）
# 參數：$1 = 檔案路徑
# 副作用：可能修改全域 EXIT_CODE 與 ERROR_COUNT
# ---------------------------------------------------------------------------
validate_command_file() {
  local filepath="$1"
  local filename
  filename=$(basename "$filepath")

  # AC3：frontmatter 必須含 description 欄位
  if has_description "$filepath"; then
    print_pass "$filename：frontmatter 含 description 欄位"
  else
    print_error "$filename：frontmatter 缺少 description 欄位"
  fi

  # AC2：提取並驗證 shikigami:xxx 引用
  local skill_refs
  skill_refs=$(extract_skill_refs "$filepath")

  if [ -z "$skill_refs" ]; then
    # 無引用 → INFO，不影響 exit code（AC2 規格：無引用 → INFO 而非 ERROR）
    print_info "$filename：無 shikigami:xxx 引用（直接內嵌指令）"
  else
    # 逐一驗證每個引用是否有對應 skill 目錄
    while IFS= read -r skill_name; do
      [ -z "$skill_name" ] && continue
      if skill_exists "$skill_name"; then
        print_pass "$filename：引用 shikigami:$skill_name 存在"
      else
        print_error "$filename：引用 shikigami:$skill_name 但 skills/$skill_name 不存在"
      fi
    done <<< "$skill_refs"
  fi
}

# ---------------------------------------------------------------------------
# 驗證所有 command 檔案並輸出清單（AC1 + AC2 + AC3）
# 參數：$1 = 換行分隔的檔案路徑字串
# ---------------------------------------------------------------------------
validate_all_commands() {
  local command_files="$1"

  FILE_COUNT=$(echo "$command_files" | wc -l | tr -d ' ')
  echo "  找到 $FILE_COUNT 個 command 檔案："
  while IFS= read -r f; do
    echo "    - $f"
  done <<< "$command_files"

  while IFS= read -r filepath; do
    print_section "驗證 $(basename "$filepath")"
    validate_command_file "$filepath"
  done <<< "$command_files"
}

# ---------------------------------------------------------------------------
# 主流程
# ---------------------------------------------------------------------------
main() {
  echo "=============================="
  echo " validate-commands.sh"
  echo " commands/ 路由驗證"
  echo "=============================="

  preflight_check

  # AC1：掃描所有 .md 檔案
  print_section "AC1：掃描 $COMMANDS_DIR/ 目錄"

  local command_files
  command_files=$(scan_commands)

  if [ -z "$command_files" ]; then
    print_info "$COMMANDS_DIR/ 目錄中無 .md 檔案"
    echo ""
    echo "=============================="
    echo " 總結：無 command 檔案，驗證跳過"
    echo "=============================="
    exit 0
  fi

  # AC1 + AC2 + AC3：輸出清單並逐一驗證
  validate_all_commands "$command_files"

  # 總結（顯示 file 數與 error 數）
  echo ""
  echo "=============================="
  if [ "$EXIT_CODE" -eq 0 ]; then
    echo " 總結：Command 路由驗證全部通過（共 $FILE_COUNT 個檔案）"
  else
    echo " 總結：Command 路由驗證發現 $ERROR_COUNT 個 ERROR，請修正後重試"
  fi
  echo "=============================="

  exit "$EXIT_CODE"
}

main
