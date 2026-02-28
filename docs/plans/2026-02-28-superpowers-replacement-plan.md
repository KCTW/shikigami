# Shikigami 取代 Superpowers — 實作計畫

> **For Claude:** REQUIRED SUB-SKILL: Use shikigami:sprint-execution to implement this plan task-by-task.

**Goal:** 新增 3 個 skill + 更新 scrum-master 路由，讓 shikigami 完全取代 superpowers plugin。

**Architecture:** 新增 `systematic-debugging`、`git-workflow`、`parallel-dispatch` 三個 skill 目錄，各含 SKILL.md。更新 scrum-master 路由表涵蓋所有意圖。更新 README 反映新增 skill。

**Tech Stack:** Markdown（YAML frontmatter + 流程定義）

---

### Task 1: 建立 `systematic-debugging` skill

**Files:**
- Create: `skills/systematic-debugging/SKILL.md`

**Step 1: 建立目錄**

```bash
mkdir -p skills/systematic-debugging
```

**Step 2: 撰寫 SKILL.md**

建立 `skills/systematic-debugging/SKILL.md`，內容要點：

- YAML frontmatter:
  ```yaml
  ---
  name: systematic-debugging
  description: "Use when encountering bugs, test failures, or unexpected behavior - 系統化除錯流程"
  ---
  ```
- 標題：`# Systematic Debugging — 系統化除錯`
- 概述：遇到 bug 時的標準流程，禁止猜測性修復
- 核心原則（Iron Law）：`沒有根因調查，不得提出修復方案`
- 四個階段：
  1. **Phase 1: 根因調查** — 讀錯誤訊息、穩定重現、檢查近期變更、追蹤資料流
  2. **Phase 2: 模式分析** — 找到可運作的類似代碼、比較差異
  3. **Phase 3: 假設與驗證** — 形成單一假設、最小變更測試、一次只改一個變數
  4. **Phase 4: 實作修復** — 寫失敗測試、實作修復、驗證通過
- Hard Gate：連續失敗 3 次 → 升級 Architect 評估架構問題
- Subagent 派遣：Developer subagent 主導除錯，QA subagent 驗證修復
- 與其他 skill 的關係：修復完成後走 `quality-gate` 驗證

參考 superpowers 的 `systematic-debugging` 吸收以下重點：
- 四階段流程（Root Cause → Pattern → Hypothesis → Implementation）
- Red Flags 表格（識別猜測性修復的思維模式）
- 多元件系統的診斷儀器化（在每個元件邊界加 log）
- 反向追蹤技術（從壞值往回追到源頭）
- 3 次修復失敗 → 質疑架構

融入 shikigami 特色：
- 用 Subagent 派遣模式（Developer 除錯 + QA 驗證）
- 連結 `architecture-decision` skill（架構問題升級）
- 連結 `sprint-execution` 的 TDD 修復流程

**Step 3: Commit**

```bash
git add skills/systematic-debugging/SKILL.md
git commit -m "feat: 新增 systematic-debugging skill"
```

---

### Task 2: 建立 `git-workflow` skill

**Files:**
- Create: `skills/git-workflow/SKILL.md`

**Step 1: 建立目錄**

```bash
mkdir -p skills/git-workflow
```

**Step 2: 撰寫 SKILL.md**

建立 `skills/git-workflow/SKILL.md`，內容要點：

- YAML frontmatter:
  ```yaml
  ---
  name: git-workflow
  description: "Use when starting feature work needing branch isolation, or when development is complete and ready to merge/PR"
  ---
  ```
- 標題：`# Git Workflow — 分支隔離與完成流程`
- 概述：涵蓋開發的 Git 生命週期 — 從建立隔離環境到完成合併
- 兩個主要流程：
  1. **開始開發：建立隔離環境**
     - 目錄選擇優先順序：`.worktrees/` > `worktrees/` > CLAUDE.md 設定 > 詢問使用者
     - 安全驗證：確認目錄已被 .gitignore 忽略
     - 建立 worktree + feature branch
     - 自動偵測專案類型、安裝依賴
     - 執行基線測試確認乾淨起點
  2. **完成開發：整合工作成果**
     - 前提：測試必須全部通過
     - 四個選項：
       - Merge to base branch（本地合併）
       - Create PR（推送 + 建立 PR）
       - Keep as-is（保留分支）
       - Discard（丟棄，需確認）
     - Worktree 清理規則
- Branch 命名慣例：`feat/`, `fix/`, `refactor/` prefix
- Conventional Commits 規範

參考 superpowers 吸收：
- `using-git-worktrees`：目錄選擇邏輯、安全驗證、基線測試
- `finishing-a-development-branch`：四選項模式、測試驗證、worktree 清理

融入 shikigami 特色：
- 與 `sprint-execution` 整合（Story 開發時自動建立隔離環境）
- 與 `sprint-review` 整合（Sprint 結束時處理分支）

**Step 3: Commit**

```bash
git add skills/git-workflow/SKILL.md
git commit -m "feat: 新增 git-workflow skill"
```

---

### Task 3: 建立 `parallel-dispatch` skill

**Files:**
- Create: `skills/parallel-dispatch/SKILL.md`

**Step 1: 建立目錄**

```bash
mkdir -p skills/parallel-dispatch
```

**Step 2: 撰寫 SKILL.md**

建立 `skills/parallel-dispatch/SKILL.md`，內容要點：

- YAML frontmatter:
  ```yaml
  ---
  name: parallel-dispatch
  description: "Use when facing 2+ independent tasks that can be worked on without shared state or sequential dependencies"
  ---
  ```
- 標題：`# Parallel Dispatch — 平行 Subagent 派遣`
- 概述：識別獨立任務、同時派遣多個 Subagent 加速執行
- 適用判斷流程圖：
  - 多個任務？→ 任務之間獨立？→ 無共享狀態？→ 平行派遣
  - 否則 → 順序執行
- 派遣流程：
  1. **識別獨立領域** — 按問題域分組
  2. **撰寫聚焦的 Agent Prompt** — 每個 agent 有明確範圍、目標、限制、預期產出
  3. **使用 Task tool 平行派遣** — 同一個訊息中多個 Task 呼叫
  4. **收集結果、檢查衝突、整合變更**
- Agent Prompt 結構：範圍 + 目標 + 限制 + 預期產出
- 常見錯誤：太廣泛、缺脈絡、無限制、模糊產出
- 何時不用：失敗有關聯、需要全局脈絡、共享狀態、探索性除錯

參考 superpowers 吸收：
- `dispatching-parallel-agents`：判斷流程圖、Agent Prompt 結構、常見錯誤
- `subagent-driven-development`：Subagent 派遣 + 審查模式

融入 shikigami 特色：
- 平行場景對應 shikigami 角色（Developer × N、SRE + Security 同時檢查）
- 與 `sprint-execution` 整合（多個獨立 Story 可平行開發）

**Step 3: Commit**

```bash
git add skills/parallel-dispatch/SKILL.md
git commit -m "feat: 新增 parallel-dispatch skill"
```

---

### Task 4: 更新 `scrum-master` 路由表

**Files:**
- Modify: `skills/scrum-master/SKILL.md`

**Step 1: 更新 Skills 清單（第 2 節）**

在現有的 Skills 表格中新增三行：

```markdown
| `systematic-debugging` | Bug、測試失敗、非預期行為、錯誤排查 |
| `git-workflow` | 建立分支隔離、開發完成合併/PR、worktree 管理 |
| `parallel-dispatch` | 多個獨立任務需同時處理 |
```

**Step 2: 更新流程觸發規則（第 5 節）**

在決策樹中新增三個分支：

```
├── Bug/錯誤/測試失敗 → invoke shikigami:systematic-debugging
├── 分支隔離/worktree → invoke shikigami:git-workflow
├── 開發完成/合併/PR → invoke shikigami:git-workflow
├── 多個獨立任務 → invoke shikigami:parallel-dispatch
```

**Step 3: 驗證完整路由表**

確認所有 13 個 skill 都在路由表中有對應的觸發規則，無遺漏。

**Step 4: Commit**

```bash
git add skills/scrum-master/SKILL.md
git commit -m "feat: 更新 scrum-master 路由表，新增 3 個 skill 觸發規則"
```

---

### Task 5: 更新 README

**Files:**
- Modify: `README.md`
- Modify: `README.en.md`（如果存在）

**Step 1: 更新 Skills 表格**

在「可用 Skills」表格中新增三行，總數從 10 → 13：

```markdown
| **systematic-debugging** | Bug 排查、測試失敗分析、系統化除錯流程 |
| **git-workflow** | 分支隔離、Worktree 管理、開發完成後的合併/PR 流程 |
| **parallel-dispatch** | 多個獨立任務的平行 Subagent 派遣 |
```

更新描述中的 skill 數量（10 → 13）。

**Step 2: 同步更新英文版**

如果 `README.en.md` 存在，同步更新英文版本。

**Step 3: Commit**

```bash
git add README.md README.en.md
git commit -m "docs: 更新 README，新增 3 個 skill 說明"
```

---

### Task 6: 驗證 plugin 載入

**Step 1: 確認目錄結構完整**

```bash
ls -la skills/systematic-debugging/SKILL.md
ls -la skills/git-workflow/SKILL.md
ls -la skills/parallel-dispatch/SKILL.md
```

**Step 2: 確認 YAML frontmatter 格式正確**

每個新 SKILL.md 的 frontmatter 都有 `name` 和 `description` 欄位。

**Step 3: 確認 scrum-master 路由表涵蓋 13 個 skill**

讀取 `skills/scrum-master/SKILL.md`，逐一核對所有 skill 都有觸發規則。

**Step 4: Commit（如有修正）**

```bash
git add -A
git commit -m "fix: 修正 plugin 載入問題"
```
