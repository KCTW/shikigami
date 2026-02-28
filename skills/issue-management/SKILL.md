---
name: issue-management
description: "Use when managing GitHub Issues — listing, creating, closing, labeling, triaging, commenting, or syncing issues to backlog"
---

# Issue Management — GitHub Issue 管理

## 1. 概述

透過 `gh` CLI 管理 GitHub Issues 的完整生命週期。支援列出、建立、關閉、標記、指派、回覆與分類。

所有操作遵循**專案等級自治策略**（見 scrum-master 第 6 節）：
- 低風險操作（查詢、label、assign）→ 自動執行
- 高風險操作（公開留言、關閉、建立）→ 依專案等級決定確認方式

**主要執行者**：Product Owner subagent（需求分類）、QA subagent（高風險審核）

---

## 2. 前置檢查

每次執行前，必須先確認 `gh` CLI 認證狀態：

```bash
gh auth status
```

若認證失效，中止流程並提示：「請執行 `gh auth login` 完成認證後重試。」

確認目標 Repo：

```bash
gh repo view --json nameWithOwner -q '.nameWithOwner'
```

所有操作預設針對當前 Git Repo。操作非當前 Repo 時，必須顯示目標 Repo 全名並依專案等級決定確認方式。

---

## 3. 操作選單

根據使用者意圖，進入對應子流程：

```
使用者意圖分析：
├── 列出/查詢 Issues → 第 4 節 List
├── 建立新 Issue → 第 5 節 Create
├── 關閉 Issue → 第 6 節 Close
├── 標記/移除 Label → 第 7 節 Label
├── 指派/取消指派 → 第 8 節 Assign
├── 回覆 Issue 留言 → 第 9 節 Comment
├── 分類無標籤 Issues → 第 10 節 Triage
└── Issue 轉 Backlog User Story → 第 11 節 Backlog Bridge
```

---

## 4. List — 列出 Issues

**風險等級**：低（自動執行）

```bash
# 預設：列出所有 open issues
gh issue list --state open --json number,title,labels,assignees,createdAt

# 篩選（AND 邏輯，同時滿足所有條件）
gh issue list --state <open|closed|all> --label <name> --assignee <user> --limit <N>
```

未指定篩選條件時，預設返回所有 open issues。

輸出格式：以表格呈現 issue 編號、標題、labels、assignee、建立日期。

---

## 5. Create — 建立 Issue

**風險等級**：高（影響外部可見狀態）

```bash
gh issue create --title "<title>" --body "<body>" --label "<label>" --assignee "<user>"
```

**流程**：
1. 根據使用者描述生成 issue 標題與內容草稿
2. 依專案等級決定確認方式：
   - `low`：自動建立，事後通知
   - `medium`：QA subagent 審核草稿品質後自動建立
   - `high`：顯示草稿，人工確認後建立
3. 執行 `gh issue create`
4. 回報建立結果（issue URL）

---

## 6. Close — 關閉 Issue

**風險等級**：高（改變 Issue 公開狀態）

```bash
# 附理由留言後關閉
gh issue comment <number> --body "<reason>"
gh issue close <number> --reason <completed|"not planned">
```

**流程**：
1. 先讀取 issue 內容（`gh issue view <number>`）
2. 生成關閉理由
3. 依專案等級決定確認方式：
   - `low`：自動關閉，事後通知
   - `medium`：QA subagent 審核關閉理由後自動關閉
   - `high`：顯示關閉理由，人工確認後關閉
4. 留言說明關閉原因，然後關閉 issue

---

## 7. Label — 標記管理

**風險等級**：低（自動執行）

```bash
# 新增 label
gh issue edit <number> --add-label "<label1>,<label2>"

# 移除 label
gh issue edit <number> --remove-label "<label>"
```

**預檢**：執行前先確認 label 存在：

```bash
gh label list --json name -q '.[].name'
```

若目標 label 不存在，提示使用者是否建立新 label（`gh label create "<name>" --color "<hex>"`）。

---

## 8. Assign — 指派管理

**風險等級**：低（自動執行）

```bash
# 指派
gh issue edit <number> --add-assignee "<user>"

# 取消指派
gh issue edit <number> --remove-assignee "<user>"
```

---

## 9. Comment — 回覆留言

**風險等級**：高（公開發布 AI 生成內容）

```bash
gh issue comment <number> --body "<comment>"
```

**流程**：
1. 讀取 issue 內容與既有留言（`gh issue view <number> --comments`）
2. 根據場景生成回覆草稿：

| 場景 | 回覆模板方向 |
|------|-------------|
| 確認收到 | 感謝回報，已收到，團隊將評估處理 |
| 要求補充資訊 | 需要更多資訊以便排查（重現步驟、環境資訊等） |
| 說明已修復 | 已在 PR #N 修復，將於下次版本釋出 |
| Won't Fix | 說明原因，感謝回報 |

3. 依專案等級決定確認方式：
   - `low`：自動發布，事後通知
   - `medium`：QA subagent 審核留言品質與語氣後自動發布
   - `high`：顯示完整草稿，人工確認後發布
4. 執行 `gh issue comment`

---

## 10. Triage — 批次分類

**風險等級**：混合（查詢=低，標記=低，留言=高）
**分類標準與留言模板**：見 `triage-prompt.md`

**流程**：
1. 列出所有無 label 的 open issues：
   ```bash
   gh issue list --search "no:label" --state open --json number,title,body
   ```
2. 讀取 repo 現有 labels，確認目標 labels 存在：
   ```bash
   gh label list --json name,description
   ```
   若 `bug`、`feature-request`、`question`、`documentation`、`invalid` 任一不存在，自動建立（低風險）。
3. 對每個 issue 依 `triage-prompt.md` 的分類規則判定類型（按優先順序匹配）：

| 類型 | 對應 Label | 判定依據 |
|------|-----------|----------|
| Bug 回報 | `bug` | 描述異常行為、錯誤訊息、重現步驟 |
| 功能請求 | `feature-request` | 期望新功能、改進建議 |
| 問題諮詢 | `question` | 使用方式、配置問題 |
| 文件相關 | `documentation` | 文件錯誤、缺少說明 |
| 無效 | `invalid` | 無法理解、明顯非本專案範圍 |

4. 生成分類建議清單（批次分析，一次呈現摘要表格）
5. 套用 labels（低風險，自動執行）
6. 若 bug 類型缺少重現步驟，或 feature-request 缺少驗收標準：
   - 依 `triage-prompt.md` 的留言模板生成補充資訊請求
   - 依專案等級處理留言（高風險操作）
7. 輸出 Triage 摘要報告：

```
Triage 結果摘要：
| # | Issue | 分類 | Label | 留言 |
|---|-------|------|-------|------|
| 1 | #123 修復登入問題 | Bug | bug | 已要求補充重現步驟 |
| 2 | #124 希望支援 dark mode | Feature | feature-request | — |
```

---

## 11. Backlog Bridge — Issue 轉 User Story

**風險等級**：混合（讀取=低，寫入 Backlog=低，留言=高）
**架構決策**：ADR-001 — 採用委派模式（issue-management 擷取 + backlog-management 評分）

**流程**：
1. 讀取指定 issue 內容：
   ```bash
   gh issue view <number> --json title,body,labels,comments
   ```
2. **PO subagent** 轉換為 Shikigami User Story 草稿：
   ```
   Story 標題：[從 issue title 提取]
   User Story：As a [role], I want [goal], so that [benefit]
   Acceptance Criteria：[從 issue body 提取或生成]
   MoSCoW：[PO 初步判斷]
   RICE：待評分
   來源：GitHub Issue #<number>
   ```
3. 追加草稿至 `docs/prd/PRODUCT_BACKLOG.md`，標記為「待評分」（低風險，本地檔案）
4. **委派 backlog-management**：觸發 `invoke shikigami:backlog-management`，由 PO subagent 執行 RICE 評分，完成正式 Backlog 寫入
5. 在 issue 上留言說明已轉入 Backlog（高風險，依專案等級處理）：
   - `low`：自動發布
   - `medium`：QA subagent 審核後自動發布
   - `high`：人工確認後發布
6. 套用 `in-backlog` label（低風險，自動執行）

**批次模式**：可一次指定多個 issue 編號，逐一轉換後統一觸發一次 backlog-management 評分。

---

## 12. Hard Gates

<HARD-GATE>
操作預設僅針對當前 Git Repo。操作非當前 Repo 時，無論專案等級，必須顯示目標 Repo 全名（OWNER/REPO）並取得確認。
</HARD-GATE>

<HARD-GATE>
gh CLI 認證失效時，不得嘗試任何寫入操作。必須中止流程並提示使用者重新認證。
</HARD-GATE>

---

## 13. 與其他 Skill 的關係

| 情境 | 觸發 |
|------|------|
| Issue 轉 Backlog 後需要 RICE 評分 | 觸發 `backlog-management`（Grooming 流程） |
| Triage 發現安全漏洞相關 issue | 升級至 `security-review` |
| Issue 對應的 Story 完成後 | `sprint-execution` 結束時建議關閉對應 issue |
| `security-review` 需建立追蹤 Issue | 呼叫 `issue-management` Create 子流程 |
| Issue 需要技術評估 | 升級至 `architecture-decision` |
| `sprint-review` Retrospective Action Items | 呼叫 `issue-management` Create 子流程（`retro-action` label） |
| Sprint Review 檢查上期 Action Items | 呼叫 `issue-management` List 子流程（`--label retro-action`） |

---

## 14. Subagent 派遣

| 子流程 | 主要 Agent | 審核 Agent |
|--------|-----------|-----------|
| List | 主 Agent 直接執行 | — |
| Create | PO subagent | QA subagent（medium/high 等級） |
| Close | 主 Agent 直接執行 | QA subagent（medium/high 等級） |
| Label / Assign | 主 Agent 直接執行 | — |
| Comment | PO subagent（生成草稿） | QA subagent（medium/high 等級） |
| Triage | PO subagent（分類判定） | QA subagent（審核留言） |
| Backlog Bridge | PO subagent（格式轉換） | QA subagent（審核留言） |
