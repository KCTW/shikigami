# Shikigami 取代 Superpowers 設計文件

> 日期：2026-02-28
> 狀態：已核准

## 目標

讓 Shikigami 能完全取代 superpowers plugin，使用者安裝 shikigami 後不需要 superpowers 即可獲得所有工作流程支援。

## 現況分析

### 已涵蓋的 superpowers 功能

| superpowers skill | shikigami 對應 |
|---|---|
| brainstorming | `backlog-management`（PO 主導需求探索） |
| writing-plans | `sprint-planning`（Story 拆分 + 計畫） |
| executing-plans | `sprint-execution`（Subagent 驅動開發） |
| test-driven-development | `sprint-execution` 內建 TDD Hard Gate |
| requesting-code-review | `quality-gate` + 雙階段 QA review |
| receiving-code-review | `sprint-execution` 開發者與審查者互動 |
| verification-before-completion | `quality-gate` + Definition of Done |
| subagent-driven-development | `sprint-execution` Subagent 驅動 |
| using-superpowers | `scrum-master`（核心路由） |

### 需要補齊的缺口

| 缺口 | 對應 superpowers skill |
|---|---|
| 系統化除錯 | systematic-debugging |
| Git 工作流 | using-git-worktrees + finishing-a-development-branch |
| 平行派遣 | dispatching-parallel-agents |

---

## 新增 Skill 設計

### 1. `systematic-debugging`

**觸發時機：** 遇到 bug、測試失敗、非預期行為

**流程：**

1. **Developer** subagent 收集症狀 — 錯誤訊息、重現步驟、相關 log
2. **Developer** 形成假設 → 驗證 → 縮小範圍（二分法）
3. 找到根因後，走 `sprint-execution` 的 TDD 修復流程（寫測試 → 修復 → QA review）
4. 如果是架構層問題 → 升級給 **Architect** 評估是否需要 ADR

**核心原則：**

- 先觀察再假設，先假設再動手
- 每次只改一個變數
- 用 git stash 保護現場
- 禁止「猜測性修復」— 必須有證據支持

### 2. `git-workflow`

**觸發時機：** 需要分支隔離、開發完成後的合併/PR 決策

**流程：**

1. **開始開發時** — 建立 worktree 或 feature branch，與主線隔離
2. **開發過程中** — 遵循 conventional commits 規範
3. **開發完成後** — 提供三個選項：
   - **Merge to main** — 直接合併（適合個人專案）
   - **Create PR** — 建立 PR（適合團隊協作）
   - **保留分支** — 暫時不合併，留待後續處理

**核心原則：**

- Worktree 使用 `.claude/worktrees/` 目錄
- Branch 命名：`feat/`, `fix/`, `refactor/` prefix
- 完成後清理 worktree

### 3. `parallel-dispatch`

**觸發時機：** 有 2+ 個獨立任務可以同時進行（不互相依賴）

**流程：**

1. **Scrum Master** 分析任務依賴關係
2. 識別可平行的任務組合 → 同時派遣多個 Subagent
3. 各 Subagent 獨立完成後，收集結果
4. 如果任一 Subagent 失敗 → 回到順序處理

**常見平行場景：**

- `sprint-execution` 中多個獨立 Story 同時開發
- `deployment-readiness` 中 SRE + Security 同時檢查
- `architecture-decision` 中 Architect 設計 + QA 準備 challenge

---

## 更新 `scrum-master` 路由

新增路由規則，完整涵蓋所有使用者意圖：

| 使用者意圖 | 觸發 Skill |
|---|---|
| 新功能、新點子、需求討論 | `backlog-management` |
| Bug、錯誤、測試失敗、非預期行為 | `systematic-debugging` |
| 開始新分支、worktree 隔離 | `git-workflow` |
| 開發完成、準備合併/PR | `git-workflow` |
| 多個獨立任務同時處理 | `parallel-dispatch` |
| Sprint 規劃 | `sprint-planning` |
| Story 實作 | `sprint-execution` |
| Sprint 回顧 | `sprint-review` |
| 技術決策、架構設計 | `architecture-decision` |
| 代碼審查、品質檢查 | `quality-gate` |
| 安全掃描 | `security-review` |
| 部署準備 | `deployment-readiness` |
| 衝突升級 | `escalation` |
| 日常小修改（不需 Sprint） | Scrum Master 直接處理 |

**關鍵：** scrum-master 的 skill description 需強化，確保 Claude Code 路由時優先選擇 shikigami 的 skill 而非 superpowers。

---

## 不納入的 superpowers 功能

| superpowers skill | 原因 |
|---|---|
| writing-skills | 僅用於撰寫 skill 本身，非一般開發需求 |

---

## 預期成果

- 新增 3 個 skill（共 13 個）
- 更新 scrum-master 路由表
- 使用者可安全移除 superpowers plugin，所有工作流程由 shikigami 接管
