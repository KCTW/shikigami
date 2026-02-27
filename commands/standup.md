---
description: "執行每日站立會議，檢視當前 Sprint 進度與阻礙"
disable-model-invocation: true
---

讀取 `docs/PROJECT_BOARD.md` 的「進行中」欄位，產出 Daily Standup 摘要：

格式：
- **昨天完成**：[從 PROJECT_BOARD 已完成欄位摘錄最近完成的任務]
- **今天計畫**：[從 PROJECT_BOARD 進行中欄位列出當前任務]
- **阻礙**：[有/無，描述]

如果 `docs/PROJECT_BOARD.md` 不存在，提示使用者先執行 `/sprint` 建立 Sprint。
