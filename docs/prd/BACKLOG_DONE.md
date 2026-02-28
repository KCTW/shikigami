# Backlog Done — 已完成 Stories 歸檔

按 Sprint 整理，保留完整 RICE 評分與驗收標準。

---

## Sprint 1（2026-02-28）

**Sprint Goal**：建立 Issue Management Skill 基礎 + 專案等級自治框架

| Story | RICE | MoSCoW | ADR | 完成狀態 |
|-------|------|--------|-----|----------|
| Story 5：專案等級自治策略 | 24.0 | Must | — | Done |
| Story 1：Issue Lifecycle Management | 8.0 | Must | — | Done |
| ADR-001：Backlog Bridge 編排模式 | — | — | Accepted | Done |
| Story 2：Backlog Bridge | 8.4 | Must | ADR-001 | Done |
| Story 3：Issue Comment | 6.0 | Should | — | Done |
| Story 4：Issue Triage | 5.6 | Should | — | Done |

---

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

**RICE 評分**
| 維度 | 分數 |
|------|------|
| Reach | 10 |
| Impact | 3 |
| Confidence | 80% |
| Effort | 1 人週 |
| **RICE Score** | **24.0** |

**MoSCoW**：Must

---

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
**ADR**：ADR-001 — 採用委派模式

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

---

---

## Sprint 2（2026-02-28）

**Sprint Goal**：讓框架能感知自己的狀態

| Story | RICE | MoSCoW | ADR | 完成狀態 |
|-------|------|--------|-----|----------|
| US-07：Health Check Skill | 27.0 | Must | — | Done |
| US-S01：Standup 遠端差距感知 | 63.3 | Must | — | Done |

---

### US-07：Health Check Skill

**標題**：框架自我診斷

**User Story**
As a Scrum Master, I want to check the framework's health status with a single command, so that I can immediately identify broken configurations, orphan artifacts, and overdue action items without manually inspecting each file.

**Acceptance Criteria**
- AC1：skills/health-check/SKILL.md 存在且含有效 frontmatter；scrum-master 決策樹含 health-check 路由
- AC2：檢查 ./CLAUDE.md、docs/PROJECT_BOARD.md、docs/prd/PRODUCT_BACKLOG.md；缺失或為空標記 FAIL
- AC3：掃描 sprint_N.md 中的 Story，反向驗證存在於 PRODUCT_BACKLOG.md 或 BACKLOG_DONE.md
- AC4：ADR 欄位非「—」的 Story，驗證 ADR 文件存在且狀態為 Accepted
- AC5：Retrospective_Log.md 中 Open Action Items，超 14 天標記 OVERDUE
- AC6：報告含 Overall Status + 4 項檢查 + 修復建議
- AC7：4 項檢查全部出現，即使通過亦顯示 PASS

**RICE 評分**
| 維度 | 分數 |
|------|------|
| Reach | 10 |
| Impact | 3 |
| Confidence | 90% |
| Effort | 1.0 |
| **RICE Score** | **27.0** |

**MoSCoW**：Must

---

### US-S01：Standup 遠端差距感知

**標題**：Standup 報告新增 Git 同步狀態

**User Story**
As a Developer, I want the daily standup to show the git sync status between local and remote, so that I can immediately know if I need to pull or push before starting work.

**Acceptance Criteria**
- AC1：standup 報告新增 Git 同步狀態區塊；顯示未推送 commits；無 tracking branch 時顯示提示
- AC2：先 git fetch（超時 5 秒），顯示未拉取 commits；N > 0 附警告
- AC3：git remote 為空時靜默略過
- AC4：git fetch 超時/失敗時降級顯示

**RICE 評分**
| 維度 | 分數 |
|------|------|
| Reach | 10 |
| Impact | 2 |
| Confidence | 95% |
| Effort | 0.3 |
| **RICE Score** | **63.3** |

**MoSCoW**：Must

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
