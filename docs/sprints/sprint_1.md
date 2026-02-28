# Sprint 1

**Sprint Goal**：建立 Issue Management Skill 基礎 + 專案等級自治框架
**週期**：2026-02-28
**專案等級**：low（完全自治）

---

## 選入 Stories

### Story 5：專案等級自治策略（S）

修改 `skills/scrum-master/SKILL.md`，加入專案等級章節。

**AC**：
- 定義 low / medium / high 三個等級與對應自治策略表
- 定義低風險/高風險操作分類框架
- 預設 medium，可在 CLAUDE.md 覆寫

### Story 1：Issue Lifecycle Management（M）

新建 `skills/issue-management/SKILL.md`，支援 GitHub Issue 完整生命週期管理。

**AC**：
- 支援 list（預設 open，可篩選 state/label/assignee，AND 邏輯）
- 支援 create / close / label / assign
- 分級自治：label/assign 自動執行；close 依專案等級決定

同步修改 `skills/scrum-master/SKILL.md` 決策樹。

---

## Retro Action Items

（首次 Sprint，無歷史 Action Items）
