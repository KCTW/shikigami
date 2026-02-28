---
description: "執行每日站立會議，檢視當前 Sprint 進度與阻礙"
disable-model-invocation: true
---

執行 Daily Standup，依序完成以下兩個區塊：

## 區塊一：Git 同步狀態

先檢查本地與遠端的同步狀態：

1. 執行 `git remote` 檢查是否有遠端設定
   - 若輸出為空 → 顯示「**Git 同步**：無遠端設定，略過同步檢查」，跳到區塊二
2. 執行 `git fetch --quiet`（超時 5 秒）
   - 若失敗（離線/超時/錯誤）→ 顯示「**Git 同步**：無法連線遠端，同步狀態未知」，跳到區塊二
3. 檢查當前 branch 是否有 tracking branch（`git rev-parse --abbrev-ref @{u}` 是否成功）
   - 若無 tracking branch → 顯示「**Git 同步**：本地分支尚未設定遠端追蹤」，跳到區塊二
4. 計算差距：
   - 未推送：`git rev-list --count @{u}..HEAD`
   - 未拉取：`git rev-list --count HEAD..@{u}`
5. 顯示結果：
   - **Git 同步**：本地已同步（兩者皆為 0）
   - **Git 同步**：本地有 N 個未推送的 commits（未推送 > 0）
   - **Git 同步**：⚠️ 遠端有 N 個未拉取的 commits，建議執行 `git pull`（未拉取 > 0）
   - 兩者皆 > 0 時兩條都顯示

## 區塊二：Sprint 進度

讀取 `docs/PROJECT_BOARD.md` 的內容，產出 Sprint 進度摘要：

格式：
- **昨天完成**：[從 PROJECT_BOARD 已完成欄位摘錄最近完成的任務]
- **今天計畫**：[從 PROJECT_BOARD 進行中欄位列出當前任務；若無進行中，從待開發欄位取最高優先]
- **阻礙**：[有/無，描述]

如果 `docs/PROJECT_BOARD.md` 不存在，提示使用者先執行 `/sprint` 建立 Sprint。
