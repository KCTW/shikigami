# Retrospective Log

---

## Sprint 1 — 2026-02-28

**Sprint Goal**：建立 Issue Management Skill 基礎 + 專案等級自治框架
**結果**：Goal 達成。全部 6 個 Story + 1 個 ADR 完成交付。

### 交付成果

| Story | Size | 狀態 | 驗收 |
|-------|------|------|------|
| Story 5：專案等級自治策略 | S | Done | AC 全通過 — low/medium/high 三等級已定義 |
| Story 1：Issue Lifecycle Management | M | Done | AC 全通過 — 7 個子流程已實作 |
| ADR-001：Backlog Bridge 編排模式 | S | Done | Accepted — 採用委派模式 |
| Story 2：Backlog Bridge 完整版 | M | Done | AC 全通過 — 委派 backlog-management 評分 |
| Story 3：Issue Comment 強化 | S | Done | AC 全通過 — 場景模板已定義 |
| Story 4：Issue Triage 強化 | S | Done | AC 全通過 — triage-prompt.md 已建立 |

**Velocity**：6 Stories（2S + 2M + 1S + 1S = 約 8 story points）

### Good（保持做的事）

- **Product Discovery 流程完整**：PO 分析 → Architect 評估 → QA 確認 AC，角色制衡有效運作
- **ADR 機制正常運作**：Story 2 被 Hard Gate 阻擋 → 先完成 ADR-001 → 解鎖，流程正確
- **使用者回饋即時納入**：「專案等級自治」和「不阻塞原則」都是使用者在過程中提出，立即轉為 Story 交付

### Problem（需改進的事）

- **Sprint Review 未自動觸發**：Sprint 所有 Story 完成後，scrum-master 沒有自動觸發 sprint-review，需要使用者提醒才補上
- **Plan Mode 與 Shikigami 衝突**：Session 開始時進了 Plan Mode，封印了式神調度，浪費了探索時間
- **AskUserQuestion 過多**：流程中多次用 AskUserQuestion 停下來問使用者，違反自治原則，被使用者拒絕多次

### Action Items

| # | Action | Owner | 驗收方式 | 狀態 |
|---|--------|-------|----------|------|
| 1 | scrum-master 決策樹加入「Sprint 完成自動觸發 sprint-review」邏輯 | Scrum Master | 下次 Sprint 完成後自動跑 Review | Closed（Sprint 3） |
| 2 | scrum-master 加入「不阻塞原則」強化指引，減少 AskUserQuestion 使用 | Scrum Master | 下次 Sprint 中 AskUserQuestion 次數 ≤ 1 | Closed（Sprint 2） |
| 3 | 文件中明確說明 Plan Mode 與 Shikigami 的互斥關係 | Developer | PLUGIN_DEV_NOTES.md 新增說明 | Closed（Sprint 2） |

---

## Sprint 2 — 2026-02-28

**Sprint Goal**：讓框架能感知自己的狀態
**結果**：Goal 達成。全部 2 個 Story + 2 個 Retro Action Items 完成交付。

### 交付成果

| Story | Size | 狀態 | 驗收 |
|-------|------|------|------|
| US-07：Health Check Skill | M | Done | AC 全通過（7/7）— 4 項結構化診斷 + 報告格式 |
| US-S01：Standup 遠端差距感知 | S | Done | AC 全通過（4/4）— Git 同步狀態 + 降級處理 |
| Retro #2：不阻塞原則強化 | S | Done | Done 定義全通過 — 4 節點決策樹 |
| Retro #3：Plan Mode 互斥說明 | S | Done | Done 定義全通過 — 問題/原因/避免 |

**Velocity**：4 Items（1M + 3S = 約 7 story points）

### Good（保持做的事）

- **Stakeholder 方向調整即時生效**：Sprint Planning 中途收到「感知優先」指示，PO 立即重選 Stories，沒有浪費已完成的分析
- **QA 審查品質高**：發現 14 個 AC 缺口（US-07 有 5 項需修正），全部在進 Sprint 前修補，避免了實作階段的返工
- **Sprint 1 Retro Action Items #2 #3 關閉**：不阻塞原則強化 + Plan Mode 互斥說明皆在本 Sprint 交付
- **角色制衡有效**：PO 選取 → Architect 確認 Size + ADR → QA 審 AC → PO 修補，四角色接力無阻塞

### Problem（需改進的事）

- **Standup 未偵測遠端差距**：Session 開始時 standup 沒發現本地落後遠端 19 個 commit，導致重做 Product Discovery，浪費約 15 分鐘（此問題已被 US-S01 解決）
- **ROADMAP vs Backlog 不同步**：ROADMAP v0.2.0 規劃了 US-06/07/08，但 Backlog 只有測試框架 Stories，PO 需要即時補寫 Story，增加了 Planning 複雜度
- **Health Check 只有被動查詢**：Stakeholder 回饋指出，使用者忘記執行 /health-check 時框架仍是盲區。需要掛鉤到 standup 或 Sprint 開始時自動觸發
- **Sprint Review 仍未自動觸發（重犯）**：Sprint Execution 完成所有 Story 後，Scrum Master 問了「要現在執行嗎？」而非直接觸發 sprint-review。這與 Sprint 1 Retro Action #1 是同一個問題 — 文件規則已寫入（5.2 狀態驅動）但行為未遵循。Sprint 2 新增的「不阻塞原則」6.1 章節也明確列為「絕對不問」的情境，但仍然問了。結論：Sprint 1 Action #1 的 Closed 判定有誤，問題未真正解決

### Action Items

| # | Action | Owner | 驗收方式 | 狀態 |
|---|--------|-------|----------|------|
| 1 | PO 補寫 ROADMAP v0.2.0 剩餘 Stories（US-06 Onboarding、US-08 Sprint Metrics）進 Backlog | PO | PRODUCT_BACKLOG.md 有對應完整 Story | Closed（Sprint 3 Planning） |
| 2 | Health Check 自動掛鉤：standup 或 Sprint 開始時自動執行輕量健康掃描 | Developer | standup.md 或 sprint-planning SKILL 含 health-check 呼叫 | Closed（Sprint 3） |
| 3 | Sprint Review 自動觸發重修：Sprint 1 Action #1 誤判 Closed，需重新開啟。規則存在但行為未遵循，需找出根因（是 prompt 不夠強？還是需要機制性保障？） | Scrum Master | 下次 Sprint 完成後 sprint-review 零詢問自動觸發 | Closed（Sprint 3） |

---

## Sprint 3 — 2026-03-01

**Sprint Goal**：完成 v0.2.0 自我感知，並修復跨兩個 Sprint 的行為性缺陷
**結果**：Goal 達成。全部 4 個 Story / Retro Action Items 完成交付。

### 交付成果

| Story | Size | 狀態 | 驗收 |
|-------|------|------|------|
| Story 1（Retro #3）：Sprint Review 自動觸發重修 | S | Done | AC 全通過 — sprint-execution 末端邏輯結構性修復，Sprint 3 零詢問自動觸發驗證通過 |
| US-06：Onboarding（專案初始化） | M | Done | AC 全通過（7/7）— 目錄建立 + 文件複製 + CLAUDE.md 生成 + 冪等性 + 錯誤處理 |
| Story 3（Retro #2）：Health Check 自動掛鉤 | S | Done | AC 全通過 — standup 輕量掃描（2 項）+ sprint-planning 完整掃描（4 項） |
| US-T04：版號一致性驗證 | S | Done | AC 全通過（3/3）— TDD Red-Green-Refactor，11 個測試案例全覆蓋 |

**Velocity**：5 points（1S + 1M + 1S + 1S；Retro Action Items 計入 S）

### Good（保持做的事）

- **Sprint Review 零詢問自動觸發**：Story 1 的結構性修復（把觸發邏輯移入 sprint-execution 流程末端）有效。Sprint 1/2 連續重犯的問題在 Sprint 3 正式修復
- **QA Planning 品質穩定**：Sprint 2 修了 14 個 AC 缺口，Sprint 3 修了 13 個，品質控制持續有效
- **Retro Action Items 全部關閉**：Sprint 2 的 3 個 Open Action Items 在 Sprint 3 全部處理完畢（#1 在 Planning 關閉，#2 和 #3 作為 Story 交付）
- **TDD 流程執行**：US-T04 嚴格遵循 Red-Green-Refactor，11 個測試案例全覆蓋

### Problem（需改進的事）

- **US-08 Sprint Metrics 推遲**：v0.2.0 的 ROADMAP 包含 US-08，但因容量與優先級決策推遲至 Sprint 4。v0.2.0 嚴格來說少了一個 Should Story
- **AC 品質系統性問題**：QA 連續兩個 Sprint 發現約 14 個 AC 缺陷。根因是 AC 混合文件結構條件（靜態）和 AI 行為條件（動態），兩種驗收方式不同但未在 AC 中區分
- **sprint-planning 第 6 節未同步更新**：Story 3 在 sprint-planning Checklist（第 2 節）加了健康檢查步驟，但第 6 節 Subagent 派遣說明未同步更新。QA 觀察到但未阻塞

### Action Items

| # | Action | Owner | 驗收方式 | 狀態 |
|---|--------|-------|----------|------|
| 1 | AC 分類標注：Backlog Grooming/Sprint Planning 時每個 AC 標注驗收類型：[靜態]（文件結構可直接驗證）或 [動態]（需執行 AI 流程觀測），降低 QA 審查量 | QA | 下次 Sprint Planning AC 表格含 [靜態]/[動態] 標注 | Closed（Sprint 4 Planning） |
| 2 | sprint-planning 第 6 節同步：補入步驟 0（健康檢查）使 Checklist 與派遣說明一致 | Developer | sprint-planning SKILL.md 第 6 節含步驟 0 健康檢查 | Closed（Sprint 4 Planning） |
