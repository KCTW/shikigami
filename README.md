# 式神 Shikigami — 你的 AI 工程團隊

![Version](https://img.shields.io/badge/Version-0.3.0-success)
![Claude Code](https://img.shields.io/badge/Claude_Code-Compatible-blue)
![Roles](https://img.shields.io/badge/Roles-6_AI_Teammates-purple)
![License](https://img.shields.io/badge/License-MIT-green)

> 讓 Claude Code 不只幫你寫程式，還幫你做架構決策、審代碼、顧安全。

你一個人開發，寫完的代碼沒人 review，架構決策靠直覺，安全問題等上線才發現。

Shikigami 給你 6 個 AI 隊友，各有專業分工，而且**會互相制衡** — 不是 6 個各自回答問題的 chatbot，是一組有紀律的工程團隊。

---

## 它做了什麼

你在 Claude Code 裡正常開發。Shikigami 在背後自動啟動對應的角色：

| 發生了什麼 | 誰會出來 | 做什麼 |
|---|---|---|
| 你想開發新功能 | **PO** | 幫你釐清需求、排優先級 |
| 要做技術選型 | **Architect** | 寫 ADR（架構決策紀錄），給你選擇和理由 |
| 設計完成 / 代碼寫完 | **QA** | 挑戰架構決策、審查代碼、查測試覆蓋 |
| 要部署上線 | **SRE** | 檢查部署設定、建監控 |
| 有外部輸入處理 | **SecOps** | 掃描安全漏洞（OWASP Top 10） |
| 團隊意見分歧 | **Stakeholder** | 最終仲裁，打破僵局 |

**重點：它們會互相制衡。** SRE 從維運角度評估 Architect 的 ADR 可行性，QA 審你的代碼並挑戰架構決策，SecOps 審外部輸入。這不是 6 個獨立助手，是一張互相制衡的治理網。

---

## 實際效果

本框架已在兩個專案中驗證：

**[小七巴拉](https://github.com/KCTW/seven-bala)**（框架起源）— 智慧咖啡快取服務。從 MVP 到 v1.3，6 個 Sprint，12 個 User Stories，全程由 AI 團隊自治開發。

**[Onmyodo](https://github.com/KCTW/onmyodo)**（框架驗證）— AI Scrum 團隊 SaaS 平台。POC 階段 2 個 Sprint，驗證了多角色編排（PO → Architect → QA 接力），5/5 測試通過率 100%。過程中也反向回饋改進了框架本身（Retro 驗收機制、TDD 豁免條款、Decision Challenge）。

共同產出：
- 15+ 份架構決策紀錄（ADR）— 每個技術選擇都有文件，不靠記憶
- 完整的測試覆蓋 — QA 把關，沒測試不算完成
- Sprint 回顧紀錄 — 每次犯的錯都記下來，不會重複踩坑
- **Decision Challenge** — QA 兼任 Devil's Advocate，挑戰 Architect 最重要的決策

---

## 適用場景

1. **從零開發新產品** — 有想法沒團隊，AI 團隊跑 Discovery → Sprint，每週交付可 Demo 的成果
2. **接手沒文件的舊系統** — Architect 盤架構、QA 補測試、SRE 建監控，Sprint 逐步還技術債
3. **一人公司 / 側專案** — 想維持工程紀律但沒人力，所有決策有紀錄，隨時可回溯
4. **教學與研究** — 展示 AI agents 協作做真實軟體工程，每個角色有業界標準依據

---

## 快速開始

### 前提

- 已安裝 [Claude Code](https://docs.anthropic.com/en/docs/claude-code)（Anthropic 官方 CLI）
- 專案已有 Git repo

### 1. 複製框架

```bash
# 複製角色定義與流程文件
cp -r docs/team/ your-project/docs/team/

# 複製 Claude Code sub-agent 指令
cp -r .claude/agents/ your-project/.claude/agents/

# 複製模板
cp -r templates/ your-project/templates/

# 複製自動化腳本
cp -r scripts/ your-project/scripts/
```

### 2. 設定你的專案

- 把 `CLAUDE.md.template` 複製到專案根目錄，改名 `CLAUDE.md`，填入專案資訊
- 編輯 `.claude/agents/*.md` 裡的 `## 專案特定規則`，填入你的技術棧和業務規則
- 根據需要調整 `docs/team/RACI.md` 的決策權分配

### 3. 開始用

告訴 Claude 你要做什麼，對應的角色會自動啟動：

```
你：「我想做一個 xxx 產品，目標使用者是 xxx」
 ↓
PO：發散探索 → 產出 DISCOVERY.md（來回迭代）
 ↓
你 + PO：對話式迭代 → 逐步收斂方向
 ↓
方向確認 → 產出 ROADMAP.md + PRODUCT_BACKLOG.md
 ↓
Architect：識別需要技術選型的 Story → 草擬 ADR
 ↓
你：Review → 拍板
 ↓
Discovery Retro：記錄學到什麼 → 更新 Retrospective_Log
```

### 4. 跑 Sprint

```
Sprint Planning（選取 Story）
 ↓
Architect 產出 SDD（設計文件）
 ↓
QA 挑戰 Architect 關鍵決策（Decision Challenge）
 ↓
主 agent 依 SDD 寫測試 → 實作（TDD）
 ↓
QA / SRE / SecOps 按需 review
 ↓
Sprint Review（驗收）+ Retro（記錄教訓）
 ↓
下一輪 Planning
```

詳細流程見 [scrum_process.md](docs/team/scrum_process.md)

---

## 框架架構

```
docs/team/                     # 角色定義與流程（換工具也能用）
├── scrum_process.md           # 完整流程：Discovery → Sprint → DoD
├── RACI.md                    # 決策權矩陣
└── roles/                     # 6 個角色定義（含業界標準）
    ├── product-owner.md
    ├── architect.md
    ├── qa-engineer.md
    ├── sre-engineer.md
    ├── security-engineer.md
    └── stakeholder.md

.claude/agents/                # Claude Code sub-agent 指令
├── po.md
├── architect.md
├── qa.md
├── sre.md
├── secops.md
└── stakeholder.md

CLAUDE.md.template             # Claude Code 啟動設定模板

templates/                     # 可直接複製的模板
├── PLAYBOOK.md               # 戰術手冊（紅線、工作流、團隊守則）
├── PROJECT_BOARD.md
├── PRODUCT_BACKLOG.md
├── ROADMAP.md
└── sprint_template.md

scripts/                       # 自動化腳本
├── install_hooks.sh           # Git hooks 安裝
├── validate_commit.sh         # Pre-commit 品質守門
└── preflight_check.sh         # 環境驗證（Agent 執行前）
```

**雙層設計**：第一層（`docs/team/`）跟工具無關，換到其他 AI 工具也能用。第二層（`.claude/agents/`）是 Claude Code 專用。

---

## 設計原則

1. **自治優先** — 團隊自己解決問題，人類只管方向
2. **按需啟動** — 角色按觸發條件啟動，不是每次都叫滿 6 個
3. **決策留痕** — 所有決策寫成文件（ADR、SDD），不靠口頭共識
4. **測試先行** — 沒有設計文件不開工，沒有測試不算完成
5. **標準術語** — 用 Scrum 標準名稱，人類接手不用重新學
6. **務實簡化** — 每個流程都標注實際執行方式，AI 和人都看得懂

---

## 使用技巧

來自 [Anthropic 實戰報告](https://www.anthropic.com/engineering/claude-code-best-practices)與小七巴拉、Onmyodo 兩個專案的實戰經驗。

### CLAUDE.md 是靈魂

框架效果取決於 `CLAUDE.md` 寫得多詳細。建議包含：
- 啟動清單（每次對話必讀的文件）
- 開發紅線（絕對不能違反的規則）
- 專案特定的業務規則與術語
- 檔案路徑速查表

### 拉霸機工作法

不要試圖修補不滿意的結果：
```
git commit（存檔）→ 讓 Claude 跑 → 滿意就留，不滿意就 git revert
```
頻繁 commit 是你的存檔點。重來比修補快。

### 一次一步

- Discovery 階段不寫程式，只產出文件
- 一個 Story 做完、測試通過，再開下一個
- 避免同時改多個不相關的東西

### 截圖就是最好的 Bug Report

前端問題直接貼截圖，Claude 能看圖理解 UI 問題。

### 先規劃再動手

重要功能先在對話中跟 PO / Architect 討論完，再開始寫程式：
```
Discovery（想清楚）→ ADR（技術決策）→ SDD（設計）→ TDD（實作）
```

---

## FAQ

<details>
<summary><b>沒有前後端工程師？誰來寫程式？</b></summary>
<br>

**主 agent 就是開發者。** 6 個角色都是治理角色，不寫程式。

| 角色 | 身份 | 做什麼 |
|---|---|---|
| 你（人類） | 老闆 | 給方向、Review |
| 主 agent | 開發者 | 日常開發、寫程式、跑測試 |
| 6 個 sub-agents | 式神 | 需要專業判斷時才召喚 |

主 agent 已經能寫程式，6 個角色的價值是**視角切換** — 同一個 LLM 用不同 prompt 提供你平時不會想到的觀點。

> Shikigami 不是開發團隊框架，而是**開發者的治理護衛**。

</details>

<details>
<summary><b>可以加自訂角色嗎？</b></summary>
<br>

可以。在 `docs/team/roles/` 新增角色定義，再到 `.claude/agents/` 新增對應指令即可。

</details>

<details>
<summary><b>AI 自己寫、自己 review，有效嗎？</b></summary>
<br>

有效，但有限度。QA 用不同 prompt 切換視角（專注找 bug、安全漏洞、測試覆蓋），能抓到開發時的盲點。本質上是**同一個 LLM 的多角度自審** — 比沒有 review 好，但不等於獨立的人類 review。

務實的做法：
- **日常**：QA 自審 + 自動化測試守底線
- **重要節點**：人類在 Sprint Review 時看結果
- **底線**：測試通過 + QA 無重大發現 = 可合併

> 這個框架的前提：人類沒時間事事過目，所以才需要式神。

</details>

<details>
<summary><b>不用 Claude Code 能用嗎？</b></summary>
<br>

第一層（`docs/team/`）跟工具無關，可以套用到任何 AI 協作工具。第二層（`.claude/agents/`）是 Claude Code 專用，換工具需要重寫這層。

</details>

---

## License

MIT
