# Product Backlog

**最後更新**：2026-02-28
**管理者**：Product Owner

---

## Issue Management Skill — 候選 Stories

### Story 1：Issue Lifecycle Management

**標題**：完整 GitHub Issue 生命週期管理

**User Story**
As a Product Owner, I want to list, create, close, and label GitHub issues using the Shikigami framework, so that I can manage the full issue lifecycle without leaving the AI workflow.

**Acceptance Criteria**
- AC1：支援 `list`（列出 issue，可篩選 state / label / assignee）
- AC2：支援 `create`（新增 issue，帶 title / body / label / assignee）
- AC3：支援 `close`（關閉 issue，可附理由留言）
- AC4：支援 `label`（新增或移除 label）
- AC5：支援 `assign`（指派處理人）
- AC6：低風險操作（label、assign）自動執行；高風險操作（close）由 QA subagent 審核後自動執行

**RICE 評分**
| 維度 | 分數 |
|------|------|
| Reach | 8 |
| Impact | 2 |
| Confidence | 100% |
| Effort | 2 人週 |
| **RICE Score** | **8.0** |

**MoSCoW**：Must
**ADR**：不需要

---

### Story 2：Backlog Bridge（Issue 轉 Backlog）

**標題**：將 GitHub Issue 轉換為 Backlog User Story

**User Story**
As a Product Owner, I want to convert a GitHub issue into a formatted User Story in the product backlog, so that external feature requests and bug reports are automatically captured in the Sprint planning process.

**Acceptance Criteria**
- AC1：讀取指定 issue 的內容，生成符合 Shikigami 格式的 User Story（含 RICE 評分建議與 MoSCoW 分類）
- AC2：由 QA subagent 審核生成品質後自動寫入 `docs/prd/PRODUCT_BACKLOG.md`
- AC3：在對應的 GitHub Issue 上留言，說明「已轉入 Backlog」（由 QA subagent 審核留言內容後自動發布）
- AC4：在 issue 加上 `in-backlog` label（自動執行，低風險）

**RICE 評分**
| 維度 | 分數 |
|------|------|
| Reach | 7 |
| Impact | 3 |
| Confidence | 80% |
| Effort | 2 人週 |
| **RICE Score** | **8.4** |

**MoSCoW**：Must
**ADR**：需要 — Backlog Bridge 跨 Skill 編排模式選型（自包含 vs 委派 vs 草稿移交）

---

### Story 3：Issue Comment（自動回覆）

**標題**：對 GitHub Issue 留言回覆

**User Story**
As a Developer or Product Owner, I want to post comments on GitHub issues in response to user reports, so that issue reporters receive timely feedback.

**Acceptance Criteria**
- AC1：根據 issue 內容自動生成回覆草稿
- AC2：由 QA subagent 審核草稿品質後自動發布（高風險操作，公開留言）
- AC3：支援常見回覆場景：確認收到、要求補充資訊、說明已修復、Won't Fix 說明
- AC4：留言中可帶入 issue 編號、相關 PR 連結等動態內容

**RICE 評分**
| 維度 | 分數 |
|------|------|
| Reach | 6 |
| Impact | 1 |
| Confidence | 100% |
| Effort | 1 人週 |
| **RICE Score** | **6.0** |

**MoSCoW**：Should
**ADR**：不需要

---

### Story 4：Issue Triage（自動分類）

**標題**：自動 Triage 新進 GitHub Issue

**User Story**
As a Product Owner, I want to automatically triage new GitHub issues by classifying them and applying labels, so that issues are actionable without manual overhead.

**Acceptance Criteria**
- AC1：列出指定 repo 中所有 open、無 label 的 issues
- AC2：對每個 issue 分析標題與描述，判定類型（bug / feature-request / question / docs / invalid）
- AC3：自動套用對應 label（低風險，自動執行）
- AC4：若 issue 缺少重現步驟（bug 類型）或驗收標準（feature-request 類型），由 QA subagent 審核留言後自動發布補充資訊請求
- AC5：Triage 結果以摘要表格呈現給團隊知會

**RICE 評分**
| 維度 | 分數 |
|------|------|
| Reach | 7 |
| Impact | 2 |
| Confidence | 80% |
| Effort | 2 人週 |
| **RICE Score** | **5.6** |

**MoSCoW**：Should
**ADR**：不需要

---

## 優先級排序總覽

| 排序 | Story | RICE | MoSCoW | ADR | 交付階段 |
|------|-------|------|--------|-----|---------|
| 1 | Backlog Bridge | 8.4 | Must | 需要 | v1 |
| 2 | Issue Lifecycle Management | 8.0 | Must | — | v1 |
| 3 | Issue Comment | 6.0 | Should | — | v2 |
| 4 | Issue Triage | 5.6 | Should | — | v2 |

---

## 框架級 Story

### Story 5：專案等級自治策略

**標題**：依專案等級決定自治程度

**User Story**
As a Scrum Master, I want the framework to adjust autonomy level based on project importance, so that low-stakes projects move fast while critical projects maintain quality gates.

**Acceptance Criteria**
- AC1：在 scrum-master Skill 中定義三個專案等級（low / medium / high）
- AC2：專案等級可在 CLAUDE.md 中設定（`shikigami.project_level: medium`）
- AC3：各等級自治策略如下表
- AC4：未設定時預設為 `medium`
- AC5：所有 Skill 的確認閘行為依專案等級調整

| 專案等級 | 自治策略 | 確認閘行為 |
|----------|----------|------------|
| **low** | 完全自治 | 所有操作自動執行，僅事後通知 |
| **medium** | 分級自治 | 低風險自動；高風險由 QA subagent 審核後自動執行 |
| **high** | Critical Gate | 低風險自動；高風險需人工確認 |

**RICE 評分**
| 維度 | 分數 |
|------|------|
| Reach | 10 |
| Impact | 3 |
| Confidence | 80% |
| Effort | 1 人週 |
| **RICE Score** | **24.0** |

**MoSCoW**：Must
**ADR**：不需要（純流程設計，無技術選型）

---

## 優先級排序總覽（含新增 Story）

| 排序 | Story | RICE | MoSCoW | ADR | 交付階段 |
|------|-------|------|--------|-----|---------|
| 1 | 專案等級自治策略 | 24.0 | Must | — | v1 |
| 2 | Backlog Bridge | 8.4 | Must | 需要 | v1 |
| 3 | Issue Lifecycle Management | 8.0 | Must | — | v1 |
| 4 | Issue Comment | 6.0 | Should | — | v2 |
| 5 | Issue Triage | 5.6 | Should | — | v2 |

---

## 設計決策：分級自治 + 專案等級

自治行為由**專案等級**決定，影響所有 Skill 的確認閘：

| 專案等級 | 低風險操作 | 高風險操作 | 適用場景 |
|----------|-----------|-----------|----------|
| **low** | 自動執行 | 自動執行，事後通知 | 個人專案、實驗 |
| **medium** | 自動執行 | QA subagent 審核後自動執行 | 一般開發專案 |
| **high** | 自動執行 | 人工確認後執行 | 重要產品、公開 repo |

**原則**：團隊自治優先。預設 medium — QA subagent 取代人工確認閘，確保品質不阻塞工作流程。
