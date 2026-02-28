# Sprint 2

**Sprint Goal**：建立自動化測試框架，確保框架結構完整性可被驗證

**日期**：2026-02-28
**分支**：`feat/test-framework`

---

## 選入 Stories

| Story | Size | ADR | 狀態 |
|-------|------|-----|------|
| ADR-002：測試框架技術選型 | S | Accepted | 完成 |
| US-T01：Skill 完整性驗證 | S | ADR-002 | 待辦 |
| US-T02：Agent 完整性驗證 | S | ADR-002 | 待辦 |
| US-T03：JSON Schema 驗證 | S | ADR-002 | 待辦 |
| US-T04：版號一致性驗證 | S | — | 待辦 |
| US-T05：交叉引用驗證 | M | — | 待辦 |
| US-T06：Command 路由驗證 | S | — | 待辦 |
| US-T07：CI Pipeline | M | — | 待辦 |

**總量**：6S + 2M ≈ 10 story points

---

## 技術決策

- 語言：Python（ADR-002）
- 目錄：`tests/`
- CI：`.github/workflows/validate.yml`
- 依賴：PyYAML + jsonschema（CI 內 pip install）
