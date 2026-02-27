---
name: sprint-review
description: "Use when sprint ends, conducting sprint review and retrospective, or evaluating sprint outcomes"
---

# Sprint Review & Retrospective

## 1. 概述

Sprint Review + Retrospective 是 Sprint 的結束儀式，用於 **驗收成果** 和 **持續改進**。

- **Sprint Review**：展示本 Sprint 的可運行成果，確認是否達成 Sprint Goal。
- **Sprint Retrospective**：團隊回顧流程與協作，找出改進行動。

兩個活動依序進行，產出的文件將直接影響下個 Sprint 的規劃。

---

## 2. Sprint Review 流程

Sprint Review 的目的是驗收本 Sprint 交付的成果，確認是否符合商業期待。

### 步驟

1. **PO Subagent 展示 Demo 結果**
   - 針對每個已完成的 User Story，展示可運行的功能
   - Demo 應基於實際程式碼執行結果，而非文件描述
   - 逐一對照 Acceptance Criteria 確認通過狀態

2. **Stakeholder Subagent 確認商業期待**
   - 檢視 Demo 結果是否符合原始商業需求
   - 確認交付物是否達到預期的商業價值
   - 提出回饋意見或調整方向

3. **更新 `docs/PROJECT_BOARD.md`（已完成欄位）**
   - 將通過驗收的 Story 移至「Done」欄位
   - 記錄完成日期與 Sprint 編號
   - 更新 Sprint 統計數據（Velocity、完成率）

4. **未達 DoD 的 Story 處理**
   - 未通過 Definition of Done 的 Story 移回 Backlog
   - 必須標注未達標的具體原因（例：測試未通過、安全驗證失敗、文件未更新）
   - PO Subagent 重新評估優先級，決定是否納入下個 Sprint

---

## 3. Sprint Retrospective 流程

Sprint Retrospective 的目的是團隊自省，找出可改進之處並制定具體行動。

### 步驟

1. **在 `docs/km/Retrospective_Log.md` 新增記錄**
   - 以 Sprint 編號為標題新增一筆記錄
   - 記錄日期與參與角色

2. **使用 Good / Problem / Action 格式**

   | 分類 | 說明 | 範例 |
   |------|------|------|
   | **Good**（保持做的事） | 本 Sprint 中做得好、值得繼續保持的實踐 | TDD 流程順暢、ADR 文件品質提升 |
   | **Problem**（需改進的事） | 遇到的問題、瓶頸或不順暢的地方 | Story 拆分粒度太大、安全審查太晚介入 |
   | **Action**（具體改進行動） | 針對 Problem 提出的可執行改善措施 | 下 Sprint 起 Story 點數上限設為 5 |

3. **每個 Action 必須有 Owner 和驗收方式**

   ```markdown
   ### Action Items

   | # | Action | Owner | 驗收方式 | 狀態 |
   |---|--------|-------|----------|------|
   | 1 | Story 拆分粒度控制在 5 點以內 | PO | 下 Sprint Planning 時檢查 | Open |
   | 2 | 安全審查提前至設計階段 | Security Engineer | 下 Sprint 有 Security Review 紀錄 | Open |
   ```

---

## 4. Action Items 驗收機制

Action Items 是 Retrospective 的核心產出，必須有明確的追蹤與關閉機制。

### 規則

1. **自動帶入下個 Sprint**
   - 上個 Sprint 的 Action Items 自動列入下個 Sprint Backlog
   - 確保改進行動不會被遺忘

2. **Sprint Review 時逐項檢查**
   - 每次 Sprint Review 開始前，先檢查上個 Sprint 的 Action Items
   - 逐項確認執行狀況

3. **結論判定**
   - **有結論** = 關閉（標記為 `Closed`，記錄結論）
   - **無結論** = 帶入下個 Sprint，標注「延遲」（`Deferred`）

4. **升級機制**
   - 連續兩個 Sprint 未關閉的 Action 自動升級至 Stakeholder
   - Stakeholder 決定：強制執行、調整方案、或判定不再需要

### 狀態流轉

```
Open → Closed（已完成驗收）
Open → Deferred（延遲一個 Sprint）
Deferred → Closed（第二個 Sprint 完成驗收）
Deferred → Escalated（連續兩個 Sprint 未關閉，升級至 Stakeholder）
```

---

## 5. 產出文件

Sprint Review & Retrospective 完成後，必須更新以下文件：

| 文件 | 更新內容 |
|------|----------|
| `docs/PROJECT_BOARD.md` | 已完成 Story 移至 Done 欄位；更新 Sprint 統計 |
| `docs/km/Retrospective_Log.md` | 新增本 Sprint 的 Good / Problem / Action 記錄 |
| `docs/prd/PRODUCT_BACKLOG.md` | 未完成 Story 回填至 Backlog，標注未達標原因與重新排序 |

---

## 6. 執行檢查清單

完成 Sprint Review & Retrospective 前，確認以下項目全部完成：

- [ ] PO Subagent 已展示所有已完成 Story 的 Demo
- [ ] Stakeholder Subagent 已確認商業期待符合度
- [ ] 通過驗收的 Story 已移至 `PROJECT_BOARD.md` Done 欄位
- [ ] 未達 DoD 的 Story 已移回 Backlog 並標注原因
- [ ] `Retrospective_Log.md` 已新增 Good / Problem / Action 記錄
- [ ] 每個 Action Item 都有 Owner 和驗收方式
- [ ] 上個 Sprint 的 Action Items 已逐項檢查並更新狀態
- [ ] 連續兩個 Sprint 未關閉的 Action 已升級至 Stakeholder
- [ ] `PRODUCT_BACKLOG.md` 已更新（未完成 Story 回填）
