# Sprint 2

**Sprint Goal**：建立自動化測試框架，確保框架結構完整性可被驗證

**日期**：2026-02-28
**分支**：`feat/test-framework`

---

## 選入 Stories

| Story | Size | ADR | 狀態 |
|-------|------|-----|------|
| ADR-002：測試框架技術選型 | S | Accepted | 完成 |
| US-T01：Skill 完整性驗證 | S | ADR-002 | 完成 |
| US-T02：Agent 完整性驗證 | S | ADR-002 | 完成 |
| US-T03：JSON Schema 驗證 | S | ADR-002 | 完成 |
| US-T04：版號一致性驗證 | S | — | 完成 |
| US-T05：交叉引用驗證 | M | — | 進行中 |
| US-T06：Command 路由驗證 | S | — | 完成 |
| US-T07：CI Pipeline | M | — | 待辦 |

**總量**：6S + 2M ≈ 10 story points

---

## 技術決策

- 語言：Python（ADR-002）
- 目錄：`tests/`
- CI：`.github/workflows/validate.yml`
- 依賴：PyYAML + jsonschema（CI 內 pip install）

---

## 執行紀錄

### 已完成

| 測試 | 結果 | 說明 |
|------|------|------|
| US-T01 test_skills.py | PASS | 14 個 Skills 全部通過 |
| US-T02 test_agents.py | PASS | 7 個 Agents 全部通過 |
| US-T03 test_json_schema.py | PASS | plugin.json + marketplace.json 通過 |
| US-T04 test_versions.py | PASS | 版號一致 |
| US-T06 test_commands.py | PASS | 3 個 Commands 全部通過 |

### US-T05 待修：交叉引用誤報

`test_cross_refs.py` 報出 10 個錯誤，皆為**誤報（false positive）**，非真實斷掉的引用：

| 檔案 | 行號 | 引用 | 原因 |
|------|------|------|------|
| README.md | 269 | `shikigami:developer` | Agent 名稱，非 Skill |
| README.md | 269 | `shikigami:qa-engineer` | Agent 名稱，非 Skill |
| README.md | 275 | `shikigami:xxx` | 說明格式的佔位符 |
| README.md | 276 | `shikigami:developer` | Agent 名稱，非 Skill |
| README.en.md | 216 | `shikigami:developer` | 同上（英文版） |
| README.en.md | 216 | `shikigami:qa-engineer` | 同上 |
| README.en.md | 222 | `shikigami:xxx` | 同上 |
| README.en.md | 223 | `shikigami:developer` | 同上 |
| PRODUCT_BACKLOG.md | 96 | `shikigami:xxx` | User Story 描述中的佔位符 |
| PRODUCT_BACKLOG.md | 115 | `shikigami:xxx` | 同上 |

**修復方向**：`test_cross_refs.py` 需排除佔位符 `xxx` 和已知 agent 名稱，或改為只掃描 `invoke shikigami:` 格式的實際調用。
