# 式神 Shikigami — AI Agent Scrum Team 框架

> 7 個 AI 隊友，各司其職，互相制衡 — 讓你的 AI 開發工具擁有一整組有紀律的工程團隊。

---

## 概念

你一個人開發，寫完的代碼沒人 review，架構決策靠直覺，安全問題等上線才發現。

Shikigami 是一個 **plugin 框架**，為你的 AI 開發工具注入 7 個專業角色（式神）。它們不只各自回答問題 — 而是組成一張**互相制衡的治理網**：SRE 從維運角度評估 Architect 的 ADR 可行性，QA 審你的代碼並挑戰架構決策，SecOps 審外部輸入。

---

## 安裝方式

### Claude Code

```bash
# 1. 加入 marketplace（首次安裝）
/plugin marketplace add KCTW/shikigami

# 2. 安裝 plugin
claude plugin install shikigami
```

> **注意**：需先加入 marketplace 才能安裝。安裝後開新 session 即自動啟動。

### Cursor

在 Cursor 的 plugin 設定中搜尋 `shikigami`，點擊安裝。

### Codex

參照 `.codex/INSTALL.md`

### OpenCode

參照 `.opencode/INSTALL.md`

---

## 7 個角色

| 角色 | 職責 | 觸發時機 |
|---|---|---|
| **Product Owner** | 需求定義、優先級決策、Backlog 管理 | 需求討論、Sprint 規劃、功能排序 |
| **Architect** | 架構決策、SDD 撰寫、技術選型 | 技術選型、系統設計、效能瓶頸分析 |
| **Developer** | 功能實作、TDD 開發、Bug 修復 | Sprint 執行、代碼撰寫、技術實作 |
| **QA Engineer** | 代碼審查、測試策略、品質把關 | 功能完成、PR 審查、品質檢測 |
| **Security Engineer** | 安全掃描、漏洞評估、OWASP 檢查 | 外部輸入處理、API 端點、配置變更 |
| **SRE Engineer** | 部署檢查、監控配置、環境管理 | 部署準備、版本發布、環境變更 |
| **Stakeholder** | 最終仲裁、打破僵局 | 團隊升級鏈走完仍無法解決 |

**重點：它們會互相制衡。** 不是 7 個獨立助手，是一組有紀律的工程團隊。

---

## 可用 Skills（13 個）

| Skill | 說明 |
|---|---|
| **scrum-master** | 自動調度 Agent Scrum Team 的角色分工與 Sprint 流程 |
| **sprint-planning** | 啟動新 Sprint、從 Backlog 選取 Stories、規劃 Sprint 目標 |
| **sprint-execution** | 執行 Sprint Stories、功能實作、處理 Sprint Backlog |
| **sprint-review** | Sprint 結束時進行回顧與驗收、評估 Sprint 成果 |
| **backlog-management** | 新需求管理、需求變更、Backlog 梳理、產品探索 |
| **architecture-decision** | 技術決策、架構審查、技術選型、ADR 撰寫 |
| **quality-gate** | 代碼審查、功能驗收、PR 檢查、品質指標檢測 |
| **security-review** | 外部輸入處理、API 安全、配置安全、漏洞評估 |
| **deployment-readiness** | 部署準備、版本發布、環境配置、生產就緒檢查 |
| **escalation** | 團隊衝突無法解決、重大產品轉向、升級鏈啟動 |
| **systematic-debugging** | Bug 排查、測試失敗分析、系統化除錯流程 |
| **git-workflow** | 分支隔離、Worktree 管理、開發完成後的合併/PR 流程 |
| **parallel-dispatch** | 多個獨立任務的平行 Subagent 派遣 |

---

## Slash Commands

| 指令 | 說明 |
|---|---|
| `/sprint` | 啟動 Sprint 規劃 |
| `/standup` | 每日站立會議 |
| `/review` | Sprint 回顧 |

---

## 使用流程概覽

```
Discovery → Sprint Planning → Sprint Execution → Sprint Review
```

1. **Discovery**：與 PO 討論需求，產出 ROADMAP 與 PRODUCT_BACKLOG
2. **Sprint Planning**：選取 Stories，Architect 產出 SDD，QA 進行 Decision Challenge
3. **Sprint Execution**：Developer 依 SDD 進行 TDD 開發，QA/SRE/SecOps 按需審查
4. **Sprint Review**：驗收成果、記錄教訓、更新 Retrospective Log

---

## 專案配置

安裝 plugin 後，將 `templates/CLAUDE.md.template` 複製到你的專案根目錄並重命名為 `CLAUDE.md`：

```bash
cp templates/CLAUDE.md.template ./CLAUDE.md
```

根據你的專案需求調整其中的：
- 專案名稱與技術棧
- 開發紅線
- 文件目錄結構
- 快速啟動指令

---

## 與 Superpowers 的關係

Shikigami 可完全取代 Superpowers。13 個 Skills 已涵蓋 Superpowers 的所有核心工作流程（brainstorming、TDD、systematic debugging、git worktree、parallel dispatch 等），並額外提供 **7 角色制衡、安全審查、部署就緒、升級機制** 等 Superpowers 沒有的功能。安裝 Shikigami 後可安全移除 Superpowers。

---

## 實戰驗證

本框架已在以下專案中驗證：

**[小七巴拉 seven-bala](https://github.com/KCTW/seven-bala)**（框架起源）— 智慧咖啡快取服務。從 MVP 到 v1.3，6 個 Sprint，12 個 User Stories，全程由 AI 團隊自治開發。

**[Onmyodo](https://github.com/KCTW/onmyodo)**（框架驗證）— AI Scrum 團隊 SaaS 平台。POC 階段 2 個 Sprint，驗證了多角色編排（PO → Architect → QA 接力），5/5 測試通過率 100%。過程中也反向回饋改進了框架本身。

共同產出：
- 15+ 份架構決策紀錄（ADR）
- 完整的測試覆蓋 — QA 把關，沒測試不算完成
- Sprint 回顧紀錄 — 每次犯的錯都記下來
- Decision Challenge — QA 兼任 Devil's Advocate，挑戰 Architect 關鍵決策

---

## 授權

MIT
