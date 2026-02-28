---
name: backlog-management
description: "Use when new feature requests arrive, requirements change, backlog grooming is needed, or product discovery begins"
---

# Backlog Management — 需求管理與產品探索

## 1. 概述

Backlog Management 合併 **Product Discovery** 與 **Backlog Grooming** 兩個流程，由 **Product Owner (PO)** 主導需求管理的全生命週期。

- **Product Discovery**：在里程碑啟動時執行，從願景文件中發掘需求、識別功能缺口與技術債，並透過 RICE 框架收斂排序，產出可執行的 Product Backlog。
- **Backlog Grooming**：在 Sprint 中段定期執行，維護 Backlog 的健康度——移除過時 Story、補充新 Story、調整優先級、確保驗收標準清晰。

**目標**：確保 Product Backlog 始終反映最新的產品策略與優先級，讓每次 Sprint Planning 都能從健康的 Backlog 中選取 Stories。

---

## 2. Product Discovery 流程（里程碑啟動時）

以下步驟必須逐項完成，不可跳過：

- [ ] **PO subagent** 分析願景文件（PRD、產品文件），理解里程碑目標與產品方向
- [ ] **PO subagent** 盤點現有功能缺口與技術債，比對目前產品狀態與目標之間的差距
- [ ] **PO + Architect subagent 討論**：探討功能可能性與技術可行性，識別潛在風險與依賴
- [ ] **Architect subagent** 識別需要 ADR（Architecture Decision Record）的 Story，標注「需要 ADR」
- [ ] **PO subagent** 使用 RICE 框架對所有候選 Story 進行評分與排序，收斂為優先級清單
- [ ] **PO subagent** 產出或更新 `docs/prd/PRODUCT_BACKLOG.md` 與 `docs/prd/ROADMAP.md`

---

## 3. Backlog Grooming 流程（Sprint 中段執行）

以下步驟必須逐項完成，不可跳過：

- [ ] **PO subagent** 檢視目前 `docs/prd/PRODUCT_BACKLOG.md` 的完整內容
- [ ] 移除過時或已不再適用的 Story
- [ ] 根據最新需求與回饋補充新 Story
- [ ] 調整優先級——使用 RICE Scoring 重新評分排序
- [ ] 確保每個 Story 有清楚的 Acceptance Criteria（驗收標準）
- [ ] **PO subagent** 更新 `docs/prd/PRODUCT_BACKLOG.md`

---

## 4. User Story 格式

所有 User Story 必須遵循以下標準格式：

```
As a [role], I want [goal], so that [benefit]
```

**範例**：

```
As a developer, I want automated test coverage reports, so that I can identify untested code paths quickly.
```

每個 Story 必須包含：

| 欄位 | 說明 |
|------|------|
| Story 標題 | 簡潔描述功能 |
| User Story | 遵循 `As a / I want / so that` 格式 |
| Acceptance Criteria | 明確、可測試的驗收條件（至少 1 條） |
| RICE 分數 | Reach、Impact、Confidence、Effort 各項評分與總分 |
| 優先級標籤 | MoSCoW 分類（Must / Should / Could / Won't） |
| ADR 標注 | 是否需要 ADR（若涉及技術選型） |

---

## 5. 優先級框架

### 5.1 RICE Scoring

RICE 是主要的量化排序框架，用於客觀比較 Story 的優先級：

| 維度 | 說明 | 評分範圍 |
|------|------|----------|
| **Reach** | 影響的使用者或場景數量 | 1–10 |
| **Impact** | 對使用者/產品的影響程度 | 0.25 / 0.5 / 1 / 2 / 3 |
| **Confidence** | 對評估的信心程度 | 50% / 80% / 100% |
| **Effort** | 所需工作量（人週） | 0.5–10 |

**計算公式**：

```
RICE Score = (Reach × Impact × Confidence) ÷ Effort
```

分數越高，優先級越高。

### 5.2 MoSCoW 分類

MoSCoW 作為輔助標籤，提供直覺式的優先級分類：

| 分類 | 說明 |
|------|------|
| **Must** | 本里程碑必須完成，缺少會導致產品無法交付 |
| **Should** | 重要但非必要，應盡量納入 |
| **Could** | 有價值但可延後，若有餘力則納入 |
| **Won't** | 本里程碑明確不做，記錄以備未來參考 |

**使用原則**：RICE 分數用於 Backlog 內部排序，MoSCoW 標籤用於與 Stakeholder 溝通與里程碑範圍管理。

---

## 6. 產出文件

Backlog Management 完成後，必須產出或更新以下文件：

| 文件 | 說明 |
|------|------|
| `docs/prd/PRODUCT_BACKLOG.md` | 核心產出。僅包含**待選 Stories**，含 RICE 分數、MoSCoW 標籤、Acceptance Criteria |
| `docs/prd/BACKLOG_DONE.md` | 已完成 Stories 歸檔。按 Sprint 整理，保留完整 RICE 評分與 AC |
| `docs/prd/ROADMAP.md` | 產品路線圖，反映里程碑規劃與 Story 的時程分配 |
| `docs/adr/ADR-xxx.md` | 若有涉及技術選型的 Story，需透過 `architecture-decision` Skill 建立對應的 ADR |

---

## 7. Subagent 派遣順序

### Product Discovery（里程碑啟動）

```
1. PO        → 分析願景文件、盤點功能缺口與技術債
2. PO + Arch → 討論功能可能性與技術可行性
3. Architect → 識別需要 ADR 的 Story
4. PO        → RICE 評分排序、產出 Backlog 與 Roadmap
```

### Backlog Grooming（Sprint 中段）

```
1. PO → 檢視 Backlog、移除過時 Story、補充新 Story
2. PO → 調整 RICE 分數與優先級
3. PO → 確認 Acceptance Criteria、更新 Backlog 文件
```

**派遣說明**：

1. **PO（分析階段）**：讀取 PRD 與產品相關文件，理解里程碑目標。同時盤點現有功能與已知技術債，建立候選 Story 清單。
2. **PO + Architect（協作階段）**：PO 提出功能需求，Architect 評估技術可行性。雙方共同討論每個候選 Story 的實現方式與潛在風險。Architect 在此階段標注需要 ADR 的 Story。
3. **PO（收斂階段）**：根據 Architect 的回饋，使用 RICE 框架為每個 Story 評分排序，標注 MoSCoW 分類，最終產出或更新 Product Backlog 與 Roadmap。
