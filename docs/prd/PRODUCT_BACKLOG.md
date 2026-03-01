# Product Backlog

**最後更新**：2026-03-08（Sprint 5 Planning 完成）
**管理者**：Product Owner

---

## 進行中 Stories（Sprint 5）

**Sprint 週期**：2026-03-08 ~ 2026-03-15

| Story | RICE | MoSCoW | Size | Points |
|-------|------|--------|------|--------|
| ADR-002：測試框架技術選型 | 90.0 | Must | S | 1 |
| US-10：Tech Debt Registry | 19.4 | Must | M | 2 |
| US-T01：Skill 完整性驗證 | 54.0 | Must | S | 1 |
| US-FIX-01：修復審計發現 | 90.0 | Must | M | 2 |

---

### ADR-002：測試框架技術選型

**背景**
測試框架（US-T01 ~ US-T09）技術選型決策缺失，為 US-T01 執行的硬性前置條件（Hard Gate）。

**Acceptance Criteria**
- AC1：建立 `docs/adr/ADR-002.md`；格式與 ADR-001 一致（使用本專案 ADR 格式：標題、狀態、背景、決策問題、選項分析、決策、實作方式）
- AC2：至少列出 2 個技術選項，每個選項含優缺點分析
- AC3：Decision 區段需含：選定工具名稱、選擇理由（≥1 點）、排除方案說明（≥1 個替代方案及排除原因）
- AC4：包含「實作方式」區段，說明測試框架的目錄結構或命名規範，使 US-T01 可據此實作

**RICE**：Reach 10 × Impact 3 × Confidence 90% ÷ Effort 0.3 = **90.0**
**MoSCoW**：Must（Hard Gate for US-T01）
**Size**：S / **Points**：1

---

### US-10：Tech Debt Registry

**User Story**
As a Developer, I want a structured Tech Debt Registry that captures and tracks technical debt across Sprints, so that the team can make informed decisions about when to address shortcuts and prevent debt accumulation from degrading system quality.

**修改目標**：`skills/sprint-execution/developer-prompt.md`（新增 Tech Debt 操作指引）；新建 `docs/km/Tech_Debt_Registry.md`；`skills/sprint-execution/SKILL.md` DoD 自檢區塊新增引用

**Acceptance Criteria**
- AC1：`docs/km/Tech_Debt_Registry.md` 建立且包含標準表格格式；表頭說明需含欄位定義（至少包含 ID/描述/引入 Story/解決 Story/嚴重度/建議解法/RICE/狀態）及趨勢判定規則
- AC2：`skills/sprint-execution/developer-prompt.md` 為主文件，新增 Tech Debt 標記格式說明與 Registry 更新指引；`SKILL.md` 的 DoD 自檢區塊新增引用；標記插入點：DoD 自檢環節
- AC3：Sprint Grooming 流程中包含 Tech Debt Review 步驟（掃描 Registry，標記逾期未解決項目）
- AC4：Tech Debt 條目需記錄「引入 Story」與「解決 Story」；欄位名稱固定為「引入 Story」與「解決 Story」
- AC5：Developer Prompt 包含「何時應標記 Tech Debt」說明；列舉 3 種取捷徑場景：跳過測試、使用硬編碼、延後必要重構；輸出的 [TECH-DEBT] 標記需符合 AC2 定義的格式
- AC6：Tech Debt Grooming 輸出包含：Active 條目清單、解決條目清單、本次變化量（相對上一次 Grooming 的 Active 總數差值）、趨勢判定（依 AC7 定義的規則執行）
- AC7：Registry 表頭說明中定義趨勢判定規則；判定規則需包含：連續 2 次 Grooming Active 增加定義為「增加中」、減少定義為「減少中」、不變定義為「穩定」；前 2 次 Grooming 輸出「資料不足」

**RICE**：Reach 8 × Impact 2 × Confidence 85% ÷ Effort 0.7 = **19.4**
**MoSCoW**：Must
**Size**：M / **Points**：2

---

### US-T01：Skill 完整性驗證

**User Story**
As a Developer, I want a script that verifies every skill directory has a valid SKILL.md with required frontmatter, so that I can catch missing or malformed skill definitions before pushing.

**Acceptance Criteria**
- AC1：掃描 `skills/` 下所有直接子目錄（depth=1），驗證每個子目錄都有 `SKILL.md`；腳本輸出掃描到的目錄清單，數量與 `skills/` 直接子目錄實際數一致
- AC2：驗證每個 SKILL.md 的 frontmatter 包含 `name` 和 `description` 欄位
- AC3：驗證 `name` 值與目錄名稱一致；比對為大小寫敏感的完全字串比對
- AC4：驗證空目錄報錯，而非靜默略過
- AC5：exit code 0 = 通過，非 0 = 失敗

**RICE**：Reach 10 × Impact 3 × Confidence 90% ÷ Effort 0.5 = **54.0**
**MoSCoW**：Must
**ADR**：ADR-002（Hard Gate 依賴）
**Size**：S / **Points**：1

---

### US-FIX-01：修復審計發現

**User Story**
As a Developer, I want framework documents (DoD, standup, health-check, sprint-planning, sprint-review) to be consistent and complete, so that monitoring gaps don't allow defects to slip through undetected.

**修改目標**：`skills/scrum-master/SKILL.md`、`skills/sprint-execution/SKILL.md`、`commands/standup.md`、`skills/health-check/SKILL.md`、`skills/sprint-planning/SKILL.md`、`skills/sprint-review/SKILL.md`

**Acceptance Criteria**
- AC-A1：`scrum-master/SKILL.md` 第 8 節與 `sprint-execution/SKILL.md` 第 5 節 DoD 統一為 7 層（功能、測試、安全、文件、設定、度量、反回歸），兩份文件完全一致
- AC-A2：`commands/standup.md` 新增「GitHub Issues 掃描」區塊，執行 `gh issue list` 並包含掃描範圍說明
- AC-A3：`skills/health-check/SKILL.md` 掃描清單新增 ROADMAP.md 與 Metrics_Log.md；ROADMAP 版號與 plugin.json 同步檢查
- AC-A4：`skills/sprint-planning/SKILL.md` 第 2 節新增 ROADMAP 讀取步驟；第 2 節與第 6 節步驟一致
- AC-A5：`skills/sprint-review/SKILL.md` 產出文件含 ROADMAP 更新項、checklist 含 ROADMAP checkbox、Action Items 含 Issue close 步驟

**RICE**：Reach 10 × Impact 3 × Confidence 90% ÷ Effort 0.3 = **90.0**
**MoSCoW**：Must
**Size**：M / **Points**：2

---

## 待選 Stories

### v0.3.0 知識沉澱 — 候選 Stories

（US-10 已移入 Sprint 5 進行中）

### 測試框架 — 候選 Stories

| 排序 | Story | RICE | MoSCoW | Size | ADR |
|------|-------|------|--------|------|-----|
| 1 | US-T01：Skill 完整性驗證（進行中，Sprint 5） | 54.0 | Must | S | ADR-002 |
| 2 | US-T02：Agent 完整性驗證 | 54.0 | Must | S | ADR-002 |
| 3 | US-T03：JSON Schema 驗證 | 36.0 | Must | S | ADR-002 |
| 4 | US-T05：交叉引用驗證 | 25.6 | Should | M | — |
| 5 | US-T07：CI Pipeline | 24.0 | Should | M | — |
| 6 | US-T09：孤兒文件清理規範 | 16.7 | Could | S | — |
| 7 | US-T08：Intent Routing 測試 | 6.0 | Could | L | — |

> US-T01 詳情見「進行中 Stories（Sprint 5）」區段（含 QA 修正後版本 AC）。

### 框架品質 — 候選 Stories

| 排序 | Story | RICE | MoSCoW | Size | ADR |
|------|-------|------|--------|------|-----|
| 1 | US-FIX-02：Hard Gate Checklist 機制 | 27.0 | Must | L | ADR-003 |

---

### US-FIX-02：Hard Gate Checklist 機制

**User Story**
As a Scrum Master, I want structural Hard Gate checklists at framework document changes, out-of-sprint changes, and ceremony completion, so that process compliance is enforced by mechanism rather than by memory.

**前置條件**：ADR-003（已完成，Accepted）

**Acceptance Criteria**
- AC-B1：ADR-003 狀態為 Accepted（前置條件）
- AC-B2：`skills/scrum-master/SKILL.md` 新增 Preflight Check 區段：框架文件（skills/、commands/、agents/）修改前自動觸發 4 項二元 checklist
- AC-B3：Framework Document Change Audit 實作為 Hard Gate，checklist 內容與 ADR-003 實作方式一致
- AC-B4：Out-of-Sprint Change Audit 實作為 Hard Gate，含緊急例外路徑（[EMERGENCY] 標注 + 48hr 事後稽核）
- AC-B5：Ceremony Integrity Audit 實作為 Hard Gate，Sprint Planning 與 Sprint Review 各有獨立 checklist

**RICE**：Reach 10 × Impact 3 × Confidence 90% ÷ Effort 1.0 = **27.0**
**MoSCoW**：Must
**ADR**：ADR-003
**Size**：L / **Points**：3

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
