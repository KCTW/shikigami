# RACI Decision Matrix

> **原則：團隊自治優先。** Stakeholder 僅在升級時介入，日常決策由團隊內部閉環。

## 決策權分配

| 任務 | PO | Architect | QA | SRE | SecOps | Stakeholder |
|---|---|---|---|---|---|---|
| 需求定義 / User Story | **A** | C | C | I | I | I |
| 優先級排序 / Sprint Goal | **A** | C | I | I | I | I |
| 架構決策 / SDD 變更 | C | **A** | I | C | C | I |
| 技術選型 / ADR | C | **A** | I | C | C | I |
| 功能實作 | I | C | I | I | I | — |
| 代碼審查 | I | C | **A** | I | C | — |
| 測試策略與執行 | I | I | **A** | I | I | — |
| 安全審查 | I | I | I | I | **A** | — |
| 部署與監控 | I | C | C | **A** | I | — |
| 產品方向重大轉向 | R | C | I | I | I | **A** |
| 團隊內部無法解決的爭議 | C | C | C | C | C | **A** |

**圖例：**
- **A** = Accountable（負責產出，有最終決策權）
- **R** = Responsible（執行者）
- **C** = Consulted（需要徵詢意見）
- **I** = Informed（事後知會即可）
- **—** = 不涉及

## 自治原則

1. **日常開發免升級**：功能實作、Bug 修復、代碼審查、測試——團隊自行閉環。
2. **角色間協調免升級**：PO 與 Architect 意見不同時，先內部對齊；QA 與 SecOps 發現問題時，直接走 Escalation 路徑。
3. **升級 Stakeholder 的觸發條件**（僅限以下情況）：
   - 產品方向重大轉向（例：放棄某核心功能、改變目標使用者）
   - 團隊內部升級鏈走完仍無法解決的僵局
   - 涉及外部商業承諾或合約的變更
4. **「沉默即同意」**：如果 Stakeholder 被知會（I）但未在合理時間回應，團隊可自行推進。
