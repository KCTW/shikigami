---
name: architecture-decision
description: "Use when technical decisions are needed, architecture reviews, technology selection, ADR creation, or system design changes"
---

# Architecture Decision — 架構決策流程

## 1. 概述

Architecture Decision 是技術決策的正式流程，由 **Architect** 主導，產出 ADR（Architecture Decision Record）作為決策紀錄。流程中包含多角色審查機制：QA Engineer 擔任 **Decision Challenger** 挑戰關鍵決策、SRE Engineer 評估維運可行性，最終由 Architect 綜合意見後拍板定案。

**目標**：確保每一項技術選型與架構變更皆經過嚴謹的評估、挑戰與審查，並以 ADR 形式留下可追溯的決策紀錄。

---

## 2. ADR 產出時機

ADR 並非隨時都需要建立，以下兩個階段是主要的產出時機：

| 階段 | 觸發條件 | 說明 |
|------|----------|------|
| **Discovery 階段** | 新里程碑引入新技術 | 例如：新 Milestone 需要引入新框架、新資料庫、新第三方服務等，必須在規劃階段即產出 ADR |
| **Sprint Planning** | Story 進 Sprint 前需要技術選型 | 涉及技術選型的 Story 在進入 Sprint 前，必須先完成 ADR 並獲得 Accepted 狀態 |

---

## 3. 流程

以下步驟必須依序執行，不可跳過：

```
1. PO 或主 Agent 標注 Story「需要 ADR」
2. Architect subagent → 評估技術選項、產出 ADR（docs/adr/ADR-xxx.md）
3. QA subagent 的 Decision Challenger → 挑戰 Architect 最關鍵決策
4. SRE subagent Review → 維運可行性
5. Architect subagent 綜合意見後拍板
6. ADR 決議後 Story 才能進 Sprint
```

**流程說明**：

1. **標注需求**：PO 在 Backlog Grooming 或主 Agent 在分析 Story 時，識別出需要技術選型的 Story，標注「需要 ADR」。
2. **Architect 產出 ADR**：Architect subagent 分析問題背景，列舉可行的技術選項，進行利弊分析，並產出初版 ADR 文件至 `docs/adr/ADR-xxx.md`。
3. **Decision Challenger 挑戰**：QA subagent 以 Decision Challenger 身份，針對 Architect 最關鍵的決策進行挑戰（詳見第 5 節）。
4. **SRE 審查**：SRE subagent 從維運角度審查決策的可行性，包括部署複雜度、監控需求、故障恢復等。
5. **Architect 拍板**：Architect subagent 綜合 Decision Challenger 與 SRE 的意見，決定是否維持原案或調整決策，更新 ADR 狀態。
6. **Story 解鎖**：ADR 狀態變更為 Accepted 後，對應的 Story 方可在 Sprint Planning 中選入 Sprint。

---

## 4. Hard Gate

<HARD-GATE>
沒有 ADR 的技術選型 Story 不能進 Sprint。
</HARD-GATE>

**說明**：任何涉及技術選型的 Story（例如選擇框架、資料庫、第三方服務、通訊協定等），必須先透過本流程完成 ADR 並獲得 Accepted 狀態。未通過此門禁的 Story 將被退回 Backlog，待 ADR 完成後方可在下次 Sprint Planning 重新選入。

---

## 5. Decision Challenger 機制

Decision Challenger 是由 **QA Engineer subagent** 擔任的挑戰角色。其目的不是阻止決策，而是透過結構化的質疑過程，確保決策經得起考驗。

**執行規則**：

- **挑選最關鍵決策**：從 Architect 的 ADR 中，挑選最關鍵的一個決策進行挑戰（非全部決策）
- **為被否決方案辯護**：為 Architect 否決的替代方案提出最強論述，扮演「魔鬼代言人」角色
- **描述具體失敗情境**：提出具體的場景，說明若採用 Architect 的決策，在什麼情況下可能失敗或產生問題
- **給出明確結論**：必須從以下三個選項中擇一
  - **同意**：挑戰後仍認為 Architect 的決策正確
  - **建議重新考慮**：發現值得深入探討的疑慮，建議 Architect 重新評估
  - **強烈反對**：發現重大風險或明顯缺陷，強烈建議更換方案
- **即使同意也必須挑戰**：Decision Challenger 的價值在於論證過程本身，而非結論。即使最終同意 Architect 的決策，仍必須完整執行挑戰流程，確保決策經過充分的壓力測試

---

## 6. ADR 格式

所有 ADR 文件存放於 `docs/adr/` 目錄，檔名格式為 `ADR-xxx.md`（xxx 為遞增編號）。

ADR 文件必須遵循以下格式：

```markdown
# ADR-xxx: [決策標題]

## 狀態：[Proposed / Accepted / Deprecated]

## 背景
[描述促使此決策的背景脈絡、面臨的問題或需求]

## 決策
[明確說明最終採用的技術方案與理由]

## 選項分析
### 選項 A: [名稱]
- 優點：...
- 缺點：...

### 選項 B: [名稱]
- 優點：...
- 缺點：...

（視需要增加更多選項）

## 結果
[預期此決策帶來的正面與負面影響]

## 影響
[此決策對系統架構、團隊流程、維運等方面的具體影響]
```

**狀態說明**：

| 狀態 | 意義 |
|------|------|
| **Proposed** | Architect 已產出初版，尚未通過審查 |
| **Accepted** | 通過 Decision Challenger 與 SRE 審查，正式採用 |
| **Deprecated** | 已被後續決策取代，保留作為歷史紀錄 |

---

## 7. 架構審查標準

Architect 在評估技術選項時，必須依據以下標準進行審查：

### 設計原則

| 原則 | 說明 |
|------|------|
| **SOLID** | 單一職責、開放封閉、里氏替換、介面隔離、依賴反轉 |
| **Clean Architecture** | 依賴方向由外向內，核心業務邏輯不依賴框架與基礎設施 |
| **DRY** | Don't Repeat Yourself — 避免重複邏輯，提取共用模組 |
| **KISS** | Keep It Simple, Stupid — 選擇最簡單能解決問題的方案 |
| **YAGNI** | You Aren't Gonna Need It — 不為尚未確認的需求預先設計 |

### 品質屬性

| 屬性 | 審查重點 |
|------|----------|
| **可擴展性** | 方案是否能隨業務成長而水平/垂直擴展 |
| **可維護性** | 方案是否易於理解、修改與除錯 |
| **安全性** | 方案是否符合安全最佳實踐，是否引入已知風險 |

---

## 8. Subagent 派遣順序

Architecture Decision 的 Subagent 調度遵循以下固定順序：

```
1. Architect     → 評估技術選項、產出 ADR 初版
2. QA (Challenger) → 挑戰最關鍵決策
3. SRE           → 維運可行性審查
4. Architect     → 綜合意見、拍板定案、更新 ADR 狀態
```

**派遣說明**：

1. **Architect（第一輪）**：分析 Story 的技術需求，調研可行方案，進行選項分析，產出 ADR 初版（狀態為 Proposed）。
2. **QA — Decision Challenger**：閱讀 ADR，挑選最關鍵決策，執行完整的挑戰流程，產出挑戰結論。
3. **SRE**：從維運角度審查 ADR，評估部署複雜度、監控需求、故障恢復機制、資源需求等。
4. **Architect（第二輪）**：綜合 QA 與 SRE 的回饋，決定維持或調整方案，更新 ADR 文件並將狀態變更為 Accepted（或退回重新評估）。
