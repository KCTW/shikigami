# 團隊協作流程

> 最後更新：[日期]
> 適用範圍：全團隊（Claude Code sub-agents 驅動）

---

## 全流程概覽

```
Discovery（發散）→ Refinement（收斂）→ Planning（選取）→ 執行 → Review
   產出 Backlog      整理 Backlog       選進 Sprint            驗收 + 回顧
```

---

## 一、Product Discovery（里程碑啟動時）

### 標準定義
在新里程碑或重大方向調整時，PO 主導的發散式探索，目的是從願景產出可執行的 Product Backlog。

> **實際執行**：Stakeholder 給方向後，啟動 PO sub-agent 完成。

### 觸發條件
- Stakeholder 給新方向
- 新里程碑開始
- 重大需求變更或策略轉向

### 流程
1. PO 分析願景文件（PRD、互動分鏡圖等產品文件）
2. PO 盤點現有功能缺口與技術債
3. PO + Architect 發散討論：功能可能性、技術可行性
4. **Architect 識別需要技術選型的 Story，標注「需要 ADR」**
5. **Architect 為標注的 Story 產出 ADR（`docs/adr/ADR-xxx.md`）**
6. PO 用 RICE 框架收斂，產出 / 更新 `docs/prd/PRODUCT_BACKLOG.md`
7. PO 更新 `docs/prd/ROADMAP.md` 里程碑規劃
8. Backlog 產出後進入正常 Sprint 循環

### 產出
- `docs/prd/PRODUCT_BACKLOG.md`（新建或更新）
- `docs/prd/ROADMAP.md`（新建或更新）
- `docs/adr/ADR-xxx.md`（如有技術選型需求）

---

## 二、Sprint 節奏（時間驅動）

### 2.1 Sprint 週期

**1 週 Sprint**

理由：
- 小團隊，決策鏈短
- MVP 階段需要高頻反饋
- Backlog 多為中小型 Story
- 歷史教訓顯示痛點在第 2-3 天浮現，1 週剛好能在下個 Sprint 修正

> [根據你的專案調整] 如果團隊規模較大或 Story 粒度較粗，可改為 2 週 Sprint。

### 2.2 Sprint 儀式

#### Sprint Planning（週一，時間盒 60 分鐘）

**主持**：PO
**參與**：Architect（技術可行性）、QA（驗收標準）

> **實際執行**：Stakeholder 給方向或 AI 從 Backlog 頂部自動拉取，於對話開始時完成。

流程：
1. PO 讀取 `docs/PROJECT_BOARD.md` 與 `docs/prd/PRODUCT_BACKLOG.md`
2. 從 Backlog 頂部選取符合本次 Sprint Goal 的 Story
3. **檢查選入的 Story 是否標注「需要 ADR」— 有 ADR 才能進 Sprint，沒有則先產出 ADR**
4. Architect 評估每個 Story 的技術工時（T-shirt size：S / M / L）
5. QA 確認驗收標準可被測試
6. PO 建立 `docs/sprints/sprint_N.md`，更新 `docs/PROJECT_BOARD.md`

#### Daily Standup（異步，每次對話開始前）

> **實際執行**：每次新對話開頭自動產摘要，無需人工參與。

格式：
```
昨天完成：[任務]
今天計畫：[任務]
阻礙：[有/無，描述]
```

執行方式：主 agent 啟動時讀取 `PROJECT_BOARD.md`「進行中」欄位，自動生成。

#### Backlog Grooming（週三，非同步，時間盒 30 分鐘）

**主持**：PO

> **實際執行**：Sprint 中段由 PO sub-agent 檢視 Backlog，移除過時 Story、補充新 Story、調整優先級。

#### Sprint Review + Retrospective（週五，時間盒 30+30 分鐘）

**Review 主持**：PO 展示可運行的 Demo
**Review 參與**：Stakeholder 確認是否符合商業期待

> **實際執行**：Sprint Goal 達成時自動觸發，AI 產出 Demo 結果 + 回顧紀錄，Stakeholder Review。

Review 產出：
- 更新 `docs/PROJECT_BOARD.md`（已完成欄位）
- 未達 DoD 的 Story 移回 Backlog 並標注原因

Retro 產出：
- 在 `docs/km/Retrospective_Log.md` 新增本 Sprint 記錄（Good / Problem / Action）
- **強制規則**：上一個 Sprint 的 Action Items 必須在下一個 Sprint 驗收

Action Items 驗收機制：
1. Retro 產出的每個 Action 必須有 **Owner** 和 **驗收方式**
2. Sprint Planning 時，自動將上個 Sprint 的 Action Items 列入 Backlog（Task ID 建議 `TXX-R1`, `TXX-R2`...）
3. Sprint Review 時逐項檢查：有結論（決議/程式碼/報告）= 關閉，無結論 = 帶入下個 Sprint 並標注「延遲」
4. 連續兩個 Sprint 未關閉的 Action 升級至 Stakeholder

---

## 三、角色觸發條件（事件驅動）

Sprint 儀式定義日常節奏，以下定義**例外狀況**時何時啟動哪個角色。

### 3.1 日常開發（不需要啟動角色）

主 agent 日常實作自行完成：
- 功能代碼撰寫
- 簡單 Bug 修復
- 文件小幅更新
- 測試執行與確認

**每次 commit 前的自檢清單：**
- [ ] 測試全過
- [ ] 代碼有設計文件引用標註
- [ ] `docs/` 同步更新（如有相關文件）

### 3.2 需求變更

```
觸發：新需求進來 / 使用者回饋 / 優先級需重新排序

1. 啟動 PO → 分析價值、撰寫 User Story、排序 Backlog
2. PO 產出 User Story → 啟動 Architect → 設計 SDD / 評估影響
3. Architect 完成 SDD → 主 agent 實作
```

### 3.3 架構決策（ADR 產出時機）

ADR 在兩個時間點產出：
- **Discovery 階段**：新里程碑引入新技術時
- **Sprint Planning**：Story 進 Sprint 前發現需要技術選型

```
觸發：技術選型 / 重大重構 / 效能瓶頸

1. PO 或主 agent 在 Backlog Story 標注「需要 ADR」
2. 啟動 Architect → 評估選項、產出 ADR（docs/adr/ADR-xxx.md）
3. SRE Review ADR（維運可行性）、主 agent Review（實作可行性）
4. Architect 綜合意見後拍板決策
5. ADR 決議後 Story 才能進 Sprint
6. 主 agent 依照 ADR 執行
   （重大架構變更會知會 Stakeholder，但不阻塞執行）
```

**規則：沒有 ADR 的技術選型 Story 不能進 Sprint。**

### 3.4 品質審查

```
觸發：功能完成 / PR 準備

1. 啟動 QA → 審查代碼、檢查測試覆蓋
2. QA 通過 → 準備 commit / merge
3. QA 不通過 → 主 agent 修復 → 重新啟動 QA
```

### 3.5 安全審查

```
觸發：涉及外部輸入處理 / 新 API 端點 / 配置變更

1. 啟動 SecOps → 安全審查
2. 如涉及部署 → 同時啟動 SRE（並行）
3. SecOps 通過 → 繼續流程
4. SecOps 發現 Critical → 阻塞，修復後重審
```

### 3.6 部署

```
觸發：版本發布 / 環境配置變更

1. 啟動 SRE → 準備部署計畫 + 回滾方案
2. 啟動 SecOps → 部署前安全掃描（並行）
3. 兩者通過 → 執行部署
```

### 3.7 重大變更：多角色並行審查

```
觸發：核心架構重構 / 跨模組大規模變更 / 新里程碑發布

並行啟動：
- QA → 測試完整性審查
- SecOps → 安全性審查
- Architect → 架構一致性審查

全部通過 → 執行
任一不通過 → 修復後重審該角色
```

---

## 四、升級（Escalation）路徑

```
技術問題 → Architect
品質問題 → QA
安全問題 → SecOps
部署問題 → SRE
需求問題 → PO
以上都解決不了 → Stakeholder
```

**升級原則：**
- 先在同層級嘗試解決（例：QA 發現安全問題 → 先轉 SecOps，不直接升級 Stakeholder）
- 只有升級鏈走完且仍無法解決，才升級到 Stakeholder
- 升級時必須附帶：問題描述、已嘗試的方案、推薦的選項

---

## 五、Definition of Done（DoD）

每個 User Story 完成須同時滿足：

| 層次 | 條件 |
|---|---|
| 功能 | 所有 Acceptance Criteria 通過 |
| 測試 | 對應單元測試 + 整合測試全部通過（0 failed） |
| 安全 | 外部輸入通過安全驗證與去活化處理 |
| 文件 | 設計文件對應章節已更新，代碼含設計文件引用 |
| 設定 | 無硬編碼金鑰，配置透過環境變數管理 |
| 反回歸 | 既有測試全部仍然通過 |

> [根據你的專案調整] 如有專案特定的 DoD 條件（如特定 UI 規範、效能基準），在此新增。

---

## 六、工件對應關係

```
Discovery（Stakeholder 給方向）
  └→ ROADMAP（往哪走）               → docs/prd/ROADMAP.md
       └→ Product Backlog（做什麼）    → docs/prd/PRODUCT_BACKLOG.md
            └→ Sprint Backlog（這週做） → docs/sprints/sprint_N.md
                 └→ 看板（做到哪）      → docs/PROJECT_BOARD.md
```
