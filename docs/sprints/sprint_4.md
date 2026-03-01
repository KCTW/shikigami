# Sprint 4

> 週期：2026-03-07 ~ 2026-03-14
> 狀態：進行中（v0.3.0 開始）
> 專案等級：low（完全自治）

---

## Sprint Goal

**「啟動 v0.3.0 知識沉澱，以 US-08 Sprint Metrics 完成 v0.2.0 收尾，並建立 Retrospective Analytics 的第一層能力」**

US-08 是 v0.2.0 ROADMAP 的最後一個 Should Story，Sprint 3 因容量決策推遲。Sprint 4 優先完成此收尾，同時以 US-09 啟動 v0.3.0「知識沉澱」主題的第一個交付。US-T06 填充剩餘容量並強化測試框架覆蓋率。

對應 ROADMAP：v0.2.0 收尾 + v0.3.0「知識沉澱」啟動。

---

## Sprint Backlog

| Story | 任務 | 負責 | 狀態 |
|---|---|---|---|
| US-08：Sprint Metrics（Velocity 追蹤與趨勢分析） | 修改 `skills/sprint-review/SKILL.md` 第 6 節執行檢查清單，新增 Sprint Metrics 計算步驟；新建 `docs/km/Metrics_Log.md` 格式規範；實作 Velocity 計算、完成率計算、趨勢分析與歷史回溯邏輯 | Developer + QA | 待開發 |
| US-09：Retrospective Analytics（問題趨勢分析） | 修改 `skills/sprint-review/SKILL.md` 第 3 節 Sprint Retrospective 流程，在第一步插入 Retrospective Analytics 呼叫；實作 Good/Problem 頻率統計、重複問題警示、Action Item 關閉速度分析 | Developer + QA | 待開發 |
| US-T06：Command 路由驗證 | 新建 Command 路由驗證腳本，掃描 `commands/` 下所有 `.md` 檔案，驗證 `shikigami:xxx` 引用指向存在的 Skill | Developer + QA | 待開發 |

---

## 工作容量

- US-08：~0.3 Sprint（S，資料已存在、觸發點單一、無架構設計決策）
- US-09：~0.5 Sprint（M，語意匹配複雜度，跨 Sprint 模式辨識）
- US-T06：~0.2 Sprint（S，腳本驗證，路徑清晰）
- 合計：~1.0 Sprint（預估 4 points，歷史 Velocity 5，保留緩衝）

**Points 換算**（T-shirt Sizing）：US-08 = 1pt（S）、US-09 = 2pt（M）、US-T06 = 1pt（S）= 合計 **4 points**

> **T-shirt Sizing 參考**：
> - S（< 0.3 Sprint）：單一模組小改動，路徑清晰
> - M（0.3-0.7 Sprint）：跨模組，需設計但風險可控
> - L（> 0.7 Sprint）：跨層、新架構、高不確定性

---

## 風險

| 風險 | 可能性 | 影響 | 應對 |
|---|---|---|---|
| US-09 語意匹配（Good/Problem 關鍵字萃取）依賴 AI 判斷，無法靜態驗證；驗收結果具不確定性 | 中 | 中 | AC2/AC3 標注 [動態]，接受 AI 行為觀測；AC 設計降低邊界條件歧義（明確定義「未解決」判定規則） |
| US-08 趨勢分析的連續方向判定邏輯需精確定義，避免邊界條件爭議（穩定 vs 改善中） | 低 | 低 | AC5 已明確優先級判定規則：先判連續方向，再判穩定；AC 文字清晰，爭議空間小 |
| US-T06 的 command 引用掃描若遇到無引用 command，輸出 INFO 而非 ERROR，需確保腳本 exit code 邏輯正確 | 低 | 低 | AC2 已明確無引用 command 輸出 INFO；腳本設計時明確區分 ERROR（引用存在但 Skill 不存在）vs INFO（無引用）vs PASS |
| Metrics_Log.md 歷史回溯（US-08 AC7）若 sprint_N.md 格式不規則，解析可能失敗 | 低 | 低 | AC7 設計為 best-effort 回溯，解析失敗的 Sprint 記錄跳過並輸出 WARN，不阻塞整體執行 |

---

## Story 詳情

### US-08：Sprint Metrics（Velocity 追蹤與趨勢分析）

**User Story**
As a Scrum Master, I want Sprint Metrics automatically calculated and appended at the end of each Sprint Review, so that I can track Velocity trends across Sprints and make data-driven capacity decisions for Sprint Planning.

**修改目標**：`skills/sprint-review/SKILL.md`（第 6 節執行檢查清單），新建 `docs/km/Metrics_Log.md`

**Architect 調整說明**：從 M 調降為 S（1pt）。理由：資料來源已存在（sprint_N.md 格式已知）、觸發點單一（Sprint Review 第 6 節）、無新架構設計決策需要。

**Acceptance Criteria**（QA 修正後版本，含類型標注）

| # | 類型 | 條件 | 通過標準 |
|---|------|------|----------|
| AC1 | [靜態] | 觸發整合 | `skills/sprint-review/SKILL.md` 第 6 節執行檢查清單新增最後一項：Sprint Metrics 計算。Sprint Review 完成時 Metrics 自動附加，無需人工觸發 |
| AC2 | [靜態] | Velocity 計算 | 讀取當期 `docs/sprints/sprint_N.md`，統計 Sprint Backlog 中狀態為 Done 的 Story 數量，以 sprint_N.md 中 Story 狀態欄值為「完成」或「Done」者計入；依 T-shirt Sizing（S=1, M=2, L=3）換算 Story Points；輸出「本期 Velocity：X points（Y Stories）」 |
| AC3 | [靜態] | 完成率計算 | 計算「計畫 Stories 數 vs 實際完成 Stories 數」；輸出完成率百分比；若有 Carry-over，列出未完成 Story 名稱。計畫 Stories 數 = Sprint Backlog 表格中所有 Story（含完成與未完成）。分母為 0 時輸出 N/A |
| AC4 | [靜態] | 累積記錄 | 每次 Sprint Review 後，將 Metrics 追加至 `docs/km/Metrics_Log.md`（若不存在則建立）；格式：Sprint 編號 + 日期 + Velocity + 完成率 + 備註 |
| AC5 | [動態] | 趨勢分析（3+ Sprint 後啟用） | 當 `Metrics_Log.md` 累積 3 個以上 Sprint 記錄時，輸出趨勢判斷。判斷優先級：先判連續方向（連升 2+/連降 2+），成立則優先判為「改善中（Velocity 連續上升）」或「退步中（Velocity 連續下降）」；不成立才判「穩定（上下波動 ≤ 20%）」 |
| AC6 | [動態] | 資料不足降級 | Sprint 1 或 Sprint 2 時，趨勢分析輸出「資料不足，需 3 個以上 Sprint 才能分析趨勢」；不報錯，其餘指標正常顯示 |
| AC7 | [靜態] | 歷史回溯 | 當 Metrics_Log.md 不存在或為空時，從所有既有 sprint_N.md 回溯計算，補齊 `Metrics_Log.md` 的歷史空白 |

**RICE**：Reach 6 × Impact 2 × Confidence 80% ÷ Effort 0.7 = **13.7**
**MoSCoW**：Should
**Size**：S（Architect 調整，原 M）
**Points**：1

---

### US-09：Retrospective Analytics（問題趨勢分析與模式辨識）

**User Story**
As a Scrum Master, I want the Retrospective Analytics report displayed automatically before each Retrospective session, so that the team can review recurring problems and unresolved root causes rather than re-discovering the same issues every Sprint.

**背景與動機**

Sprint 2 和 Sprint 3 的 Problem 區段均出現「Sprint Review 自動觸發失敗」，且 Sprint 1 的 Action Item #1 被誤判 Closed 後在 Sprint 2 重犯，根因是缺乏跨 Sprint 的模式辨識機制。本 Story 直接解決此類盲點，是 v0.3.0「知識沉澱」里程碑的首個交付。

**修改目標**：`skills/sprint-review/SKILL.md`（第 3 節 Sprint Retrospective 流程）

**資料源**：`docs/km/Retrospective_Log.md`

格式參考（已知 3 個 Sprint 的實際結構）：
- 每個 Sprint 區段包含：Good 條列 / Problem 條列 / Action Items 表格（Owner、驗收方式、狀態）
- Action Items 狀態值：`Open` / `Closed（Sprint N）`

**Acceptance Criteria**（QA 修正後版本，含類型標注）

| # | 類型 | 條件 | 通過標準 |
|---|------|------|----------|
| AC1 | [靜態] | 觸發時機 | `skills/sprint-review/SKILL.md` 第 3 節 Sprint Retrospective 流程第一步插入 Retrospective Analytics 呼叫。展示報告前不得開始收集 Good/Problem/Action |
| AC2 | [動態] | Good 頻率統計 | 讀取 `docs/km/Retrospective_Log.md` 所有 Sprint 的 Good 條列；輸出「出現 2 次以上的 Good」清單，格式：主題關鍵字 + 出現次數 + 最近一次出現的 Sprint 編號 |
| AC3 | [動態] | Problem 頻率統計 | 讀取所有 Sprint 的 Problem 條列；輸出「出現 2 次以上的 Problem」清單，格式：主題關鍵字 + 出現次數 + 首次出現 Sprint + 最近出現 Sprint；標注「跨 N 個 Sprint 未解決」。「未解決」判定：Problem 重複出現且最近一次出現 Sprint 無對應 Closed Action Item 視為未解決 |
| AC4 | [靜態] | 重複 Problem 根因警示 | 若某 Problem 在連續 Sprint 中出現（例如 Sprint 1 和 Sprint 2 均有），報告中以醒目格式標注「重複問題（連續 N 個 Sprint）」；「Sprint Review 自動觸發」類問題必須被此規則捕捉。間斷情境（Sprint 1 有、Sprint 2 有、Sprint 3 無）輸出「曾連續 2 個 Sprint（Sprint 1-2）」，不觸發醒目警示 |
| AC5 | [靜態] | Action Items 關閉速度 | 統計所有 Action Items 的關閉速度：從出現 Sprint 到 `Closed（Sprint N）` 之間的 Sprint 數差；輸出：平均關閉速度（X.X 個 Sprint）、最快（N 個 Sprint）、最慢（N 個 Sprint）；仍 `Open` 的 Items 列出「逾期 N 個 Sprint 未關閉」 |
| AC6 | [靜態] | Open Action Items 警示 | 若 `Retrospective_Log.md` 中存在狀態為 `Open` 的 Action Items，報告最後單獨列出「待關閉 Action Items」區塊，包含 Item 內容、Owner、出現 Sprint |
| AC7 | [動態] | 報告格式一致性 | Analytics 報告輸出包含四個固定區塊：① Good 趨勢 ② Problem 趨勢（含重複警示）③ Action Item 關閉速度 ④ 待關閉 Action Items；缺少任一區塊視為不通過 |
| AC8 | [動態] | 資料不足降級 | 當 `Retrospective_Log.md` 只有 1 個 Sprint 記錄時，頻率統計輸出「資料不足，需 2 個以上 Sprint 才能分析趨勢」；不報錯，其餘可計算的指標（如 Open Action Items）正常顯示 |
| AC9 | [靜態] | 檔案不存在處理 | 若 `docs/km/Retrospective_Log.md` 不存在，輸出「尚無 Retrospective 記錄，請完成第一次 Retrospective 後再執行分析」並正常結束，不丟出例外或空白報告 |

**RICE**：Reach 7 × Impact 2 × Confidence 85% ÷ Effort 0.7 = **17.0**
**MoSCoW**：Should
**Size**：M
**Points**：2

---

### US-T06：Command 路由驗證

**User Story**
As a Developer, I want to verify that each command correctly delegates to an existing skill, so that routing failures are caught before users encounter them.

**修改目標**：新建 Command 路由驗證腳本（路徑由 Developer 決定，建議 `scripts/validate-commands.sh` 或整合至現有驗證框架）

**Acceptance Criteria**（QA 修正後版本，含類型標注）

| # | 類型 | 條件 | 通過標準 |
|---|------|------|----------|
| AC1 | [靜態] | 掃描範圍 | 掃描 `commands/` 下所有 `.md` 檔案；腳本輸出掃描到的檔案清單，數量與 commands/ 目錄實際 .md 檔案數一致 |
| AC2 | [靜態] | 引用存在性驗證 | 驗證引用的 `shikigami:xxx` skill 存在；若 command 未引用任何 `shikigami:xxx`，視為無引用需驗證，輸出 INFO 而非 ERROR |
| AC3 | [靜態] | Frontmatter 驗證 | 驗證 command frontmatter 包含 `description` 欄位 |
| AC4 | [靜態] | Exit code | exit code 0 = 全部通過，非 0 = 存在 ERROR（INFO 不影響 exit code） |

**RICE**：Reach 6 × Impact 1 × Confidence 90% ÷ Effort 0.3 = **18.0**
**MoSCoW**：Should
**Size**：S
**Points**：1

---

## Retro Action Items 處理

| # | Action（原始） | 本 Sprint 處理方式 | 狀態 |
|---|---------------|-------------------|------|
| Sprint 3 #1 | AC 分類標注：每個 AC 標注 [靜態]/[動態] | Sprint 4 Planning 中全部 US-08、US-09、US-T06 AC 已完成標注 | 已關閉（Sprint 4 Planning） |
| Sprint 3 #2 | sprint-planning 第 6 節同步：補入步驟 0（健康檢查） | 已在 Sprint 4 Planning 步驟 0 直接完成 | 已關閉（Sprint 4 Planning） |

---

## 驗收標準

- [ ] US-08：`skills/sprint-review/SKILL.md` 第 6 節執行檢查清單最後一項為 Sprint Metrics 計算（AC1 通過）
- [ ] US-08：Velocity 計算以「完成」或「Done」為判定值，依 S/M/L 換算 Points（AC2 通過）
- [ ] US-08：完成率計算含 Carry-over 列出與分母為 0 時 N/A 處理（AC3 通過）
- [ ] US-08：Metrics 追加至 `docs/km/Metrics_Log.md`，格式含 Sprint 編號 + 日期 + Velocity + 完成率 + 備註（AC4 通過）
- [ ] US-08：趨勢判定先判連續方向，不成立才判穩定（AC5 通過，[動態]）
- [ ] US-08：Sprint 1-2 時趨勢分析輸出資料不足訊息，不報錯（AC6 通過，[動態]）
- [ ] US-08：Metrics_Log.md 不存在或為空時從既有 sprint_N.md 回溯計算（AC7 通過）
- [ ] US-09：`skills/sprint-review/SKILL.md` 第 3 節 Retrospective 流程第一步為 Analytics 呼叫（AC1 通過）
- [ ] US-09：Good 頻率統計輸出 2 次以上清單（AC2 通過，[動態]）
- [ ] US-09：Problem 頻率統計含「未解決」判定規則（AC3 通過，[動態]）
- [ ] US-09：連續重複 Problem 觸發醒目警示，間斷情境輸出「曾連續 N 個 Sprint」且不觸發警示（AC4 通過）
- [ ] US-09：Action Items 關閉速度統計含平均/最快/最慢及逾期列出（AC5 通過）
- [ ] US-09：Open Action Items 單獨列出（AC6 通過）
- [ ] US-09：報告含四個固定區塊（AC7 通過，[動態]）
- [ ] US-09：資料不足降級不報錯（AC8 通過，[動態]）
- [ ] US-09：Retrospective_Log.md 不存在時輸出明確提示並正常結束（AC9 通過）
- [ ] US-T06：掃描輸出檔案清單，數量與 commands/ 目錄實際 .md 檔案數一致（AC1 通過）
- [ ] US-T06：shikigami:xxx 引用指向存在的 Skill（AC2 通過），無引用時輸出 INFO 而非 ERROR（AC2 通過）
- [ ] US-T06：command frontmatter 含 description 欄位（AC3 通過）
- [ ] US-T06：exit code 0 全通過，非 0 存在 ERROR（AC4 通過）
- [ ] 既有功能不受影響（反回歸：sprint-review 其餘流程、retrospective 流程、scrum-master 路由）
