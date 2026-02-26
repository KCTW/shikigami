# Product Backlog

> 最後更新：[日期]
> 擁有者：Product Owner
> 排序方法：RICE（Reach x Impact x Confidence / Effort）

里程碑定義見 `docs/prd/ROADMAP.md`。

---

## 北極星指標

> [根據你的專案調整] 定義你的 North Star Metric。

**主指標**：[描述你的核心衡量指標]

**輔助指標**：
- [輔助指標 1]（目標 > [值]）
- [輔助指標 2]（目標 > [值]）
- [輔助指標 3]（目標 < [值]）

---

## RICE 評分說明

- **Reach**（1-5）：影響用戶數量，5 = 所有用戶都受益
- **Impact**（1-3）：對核心指標的影響，3 = 重大
- **Confidence**（%）：估算準確度信心
- **Effort**（Sprint 數）：完成所需 Sprint 週期數
- **RICE 分數** = (Reach x Impact x Confidence) / Effort

### RICE 使用指南

**何時使用 RICE：**
- 新功能優先級排序
- 多個 Story 競爭同一 Sprint 容量時
- Backlog Grooming 期間的重新排序

**何時不使用 RICE：**
- Bug 修復（依嚴重度排序）
- 技術債清理（依架構風險排序）
- 合規/安全需求（強制執行）

**評分注意事項：**
- Reach 和 Impact 由 PO 評估
- Effort 由 Architect 評估
- Confidence 反映整體不確定性，低於 50% 需先做 Spike

---

## 優先級總覽

| 排名 | ID | 標題 | RICE | 里程碑 | Sprint | 狀態 |
|---|---|---|---|---|---|---|
| 1 | US-xx | [Story 標題] | [分數] | [版本] | [Sprint 編號] | 待開發 |
| 2 | US-xx | [Story 標題] | [分數] | [版本] | [Sprint 編號] | 待開發 |

---

## User Story 細節

### US-xx：[Story 標題]

```
As a [角色],
I want [目標],
so that [效益].
```

**驗收標準**：
- [AC-1 描述]
- [AC-2 描述]
- [AC-3 描述]

**RICE**：R=[值], I=[值], C=[值]%, E=[值] → **[分數]**

---

### US-xx：[Story 標題]

```
As a [角色],
I want [目標],
so that [效益].
```

**驗收標準**：
- [AC-1 描述]
- [AC-2 描述]

**RICE**：R=[值], I=[值], C=[值]%, E=[值] → **[分數]**
