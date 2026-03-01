# Product Backlog

**最後更新**：2026-03-01（Sprint 3 完成）
**管理者**：Product Owner

---

## 待選 Stories

### v0.2.0 自我感知 — 剩餘 Stories

| 排序 | Story | RICE | MoSCoW | Size | ADR |
|------|-------|------|--------|------|-----|
| 1 | US-08：Sprint Metrics（Velocity 追蹤） | 13.7 | Should | M | — |

### 測試框架 — v0.2.0 候選

| 排序 | Story | RICE | MoSCoW | Size | ADR |
|------|-------|------|--------|------|-----|
| 1 | US-T01：Skill 完整性驗證 | 54.0 | Must | S | ADR-002 |
| 2 | US-T02：Agent 完整性驗證 | 54.0 | Must | S | ADR-002 |
| 3 | US-T03：JSON Schema 驗證 | 36.0 | Must | S | ADR-002 |
| 4 | US-T05：交叉引用驗證 | 25.6 | Should | M | — |
| 5 | US-T07：CI Pipeline | 24.0 | Should | M | — |
| 6 | US-T06：Command 路由驗證 | 18.0 | Should | S | — |
| 7 | US-T09：孤兒文件清理規範 | 16.7 | Could | S | — |
| 8 | US-T08：Intent Routing 測試 | 6.0 | Could | L | — |

---

### US-08：Sprint Metrics（Velocity 追蹤與趨勢分析）

**User Story**
As a Scrum Master, I want Sprint Metrics automatically calculated and appended at the end of each Sprint Review, so that I can track Velocity trends across Sprints and make data-driven capacity decisions for Sprint Planning.

**Acceptance Criteria**

| # | 條件 | 通過標準 |
|---|------|----------|
| AC1 | 觸發整合 | `skills/sprint-review/SKILL.md` 最後一個步驟呼叫 Sprint Metrics 計算；Sprint Review 完成時 Metrics 自動附加，無需人工觸發 |
| AC2 | Velocity 計算 | 讀取當期 `docs/sprints/sprint_N.md`，統計 Sprint Backlog 中狀態為 Done 的 Story 數量；依 T-shirt Sizing（S=1, M=2, L=3）換算 Story Points；輸出「本期 Velocity：X points（Y Stories）」 |
| AC3 | 完成率計算 | 計算「計畫 Stories 數 vs 實際完成 Stories 數」；輸出完成率百分比；若有 Carry-over，列出未完成 Story 名稱 |
| AC4 | 累積記錄 | 每次 Sprint Review 後，將 Metrics 追加至 `docs/km/Metrics_Log.md`（若不存在則建立）；格式：Sprint 編號 + 日期 + Velocity + 完成率 + 備註 |
| AC5 | 趨勢分析（3+ Sprint 後啟用） | 當 `Metrics_Log.md` 累積 3 個以上 Sprint 記錄時，輸出趨勢判斷：「改善中（Velocity 連續上升）」、「退步中（Velocity 連續下降）」或「穩定（上下波動 ≤ 20%）」 |
| AC6 | 資料不足降級 | Sprint 1 或 Sprint 2 時，趨勢分析輸出「資料不足，需 3 個以上 Sprint 才能分析趨勢」；不報錯，其餘指標正常顯示 |
| AC7 | 歷史回溯 | 若 `sprint_1.md` 和 `sprint_2.md` 已存在，初次執行時可從既有 Sprint 文件回溯計算，補齊 `Metrics_Log.md` 的歷史空白 |

**RICE**：Reach 6 × Impact 2 × Confidence 80% ÷ Effort 0.7 = **13.7**
**MoSCoW**：Should
**Size**：M
**ADR**：—

---

### US-T01：Skill 完整性驗證

**User Story**
As a Developer, I want a script that verifies every skill directory has a valid SKILL.md with required frontmatter, so that I can catch missing or malformed skill definitions before pushing.

**Acceptance Criteria**
- AC1：掃描 `skills/` 下所有子目錄，驗證每個子目錄都有 `SKILL.md`
- AC2：驗證每個 SKILL.md 的 frontmatter 包含 `name` 和 `description` 欄位
- AC3：驗證 `name` 值與目錄名稱一致
- AC4：驗證空目錄報錯，而非靜默略過
- AC5：exit code 0 = 通過，非 0 = 失敗

**RICE**：Reach 10 × Impact 3 × Confidence 90% ÷ Effort 0.5 = **54.0**
**MoSCoW**：Must
**ADR**：ADR-002（測試框架技術選型）

---

### US-T02：Agent 完整性驗證

**User Story**
As a Developer, I want a script that verifies every agent file has correct frontmatter fields, so that plugin installation doesn't fail silently.

**Acceptance Criteria**
- AC1：掃描 `agents/` 下所有 `.md` 檔案
- AC2：驗證 frontmatter 包含 `name`、`description`、`model` 三個欄位
- AC3：驗證 `model` 值為合法值（`sonnet`、`haiku`、`opus`）
- AC4：驗證 `description` 欄位存在且非空

**RICE**：Reach 10 × Impact 3 × Confidence 90% ÷ Effort 0.5 = **54.0**
**MoSCoW**：Must
**ADR**：ADR-002

---

### US-T03：JSON Schema 驗證

**User Story**
As a Developer, I want automated validation of plugin.json and marketplace.json, so that malformed manifests are caught before users try to install.

**Acceptance Criteria**
- AC1：驗證 `plugin.json` 包含必填欄位：`name`、`version`、`description`、`author`
- AC2：驗證 `marketplace.json` 包含必填欄位：`name`、`plugins` 陣列
- AC3：驗證 `version` 格式符合 semver
- AC4：驗證 `plugin.json` 不包含多餘路徑欄位

**RICE**：Reach 10 × Impact 2 × Confidence 90% ÷ Effort 0.5 = **36.0**
**MoSCoW**：Must
**ADR**：ADR-002

---

### US-T05：交叉引用驗證

**User Story**
As a Developer, I want a script that verifies all `shikigami:xxx` references point to existing skills.

**Acceptance Criteria**
- AC1：掃描所有 `*.md` 中的 `shikigami:[a-z-]+` 引用
- AC2：驗證對應的 `skills/<name>/SKILL.md` 存在
- AC3：產出斷掉的引用報告（來源檔案 + 行號 + 引用名稱）

**RICE**：Reach 8 × Impact 2 × Confidence 80% ÷ Effort 0.5 = **25.6**
**MoSCoW**：Should

---

### US-T06：Command 路由驗證

**User Story**
As a Developer, I want to verify that each command correctly delegates to an existing skill.

**Acceptance Criteria**
- AC1：掃描 `commands/` 下所有 `.md` 檔案
- AC2：驗證引用的 `shikigami:xxx` skill 存在
- AC3：驗證 command frontmatter 包含 `description` 欄位

**RICE**：Reach 6 × Impact 1 × Confidence 90% ÷ Effort 0.3 = **18.0**
**MoSCoW**：Should

---

### US-T07：CI Pipeline

**User Story**
As a Developer, I want all structural validation scripts to run automatically on every push, so that broken commits never reach users.

**Acceptance Criteria**
- AC1：建立 `.github/workflows/validate.yml`
- AC2：Pipeline 依序執行 US-T01 到 US-T06 的驗證
- AC3：任一步驟失敗則整體失敗
- AC4：Pipeline 執行時間 < 30 秒

**RICE**：Reach 10 × Impact 3 × Confidence 80% ÷ Effort 1.0 = **24.0**
**MoSCoW**：Should

---

### US-T08：Intent Routing 測試（Prompt Evaluation）

**User Story**
As a Developer, I want a test suite that verifies scrum-master correctly routes user intents to expected skills.

**Acceptance Criteria**
- AC1：至少 20 個測試案例，覆蓋所有 14 個 skill
- AC2：包含邊界案例（模糊意圖、多意圖混合）
- AC3：支援離線 mock 模式
- AC4：結果以表格呈現

**RICE**：Reach 10 × Impact 3 × Confidence 60% ÷ Effort 3.0 = **6.0**
**MoSCoW**：Could（L1/L2 穩定後再做）

---

### US-T09：孤兒文件清理規範

**User Story**
As a Product Owner, I want a defined policy for handling orphan artifacts, so that the repo stays clean.

**Acceptance Criteria**
- AC1：定義「孤兒」判斷規則
- AC2：linter 輸出中標記孤兒（warning 等級）
- AC3：Retro Action Item 逾期問題裁定

**RICE**：Reach 5 × Impact 1 × Confidence 100% ÷ Effort 0.3 = **16.7**
**MoSCoW**：Could

---

## 設計決策：分級自治 + 專案等級

自治行為由**專案等級**決定，影響所有 Skill 的確認閘：

| 專案等級 | 低風險操作 | 高風險操作 | 適用場景 |
|----------|-----------|-----------|----------|
| **low** | 自動執行 | 自動執行，事後通知 | 個人專案、實驗 |
| **medium** | 自動執行 | QA subagent 審核後自動執行 | 一般開發專案 |
| **high** | 自動執行 | 人工確認後執行 | 重要產品、公開 repo |

**原則**：團隊自治優先。預設 medium — QA subagent 取代人工確認閘，確保品質不阻塞工作流程。

---

## 已完成 Stories

歸檔於 [`BACKLOG_DONE.md`](./BACKLOG_DONE.md)，按 Sprint 整理。
