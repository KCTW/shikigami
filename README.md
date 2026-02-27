# 式神 Shikigami — 召喚你的 Agent Scrum 團隊

> 用 Scrum 驅動 AI Agent 協作的治理框架

一套讓 AI agents 像真實 Scrum 團隊一樣協作的開源框架。6 個功能性角色各司其職，日常開發自行閉環，人類只需給方向和 Review。

就像陰陽師召喚式神 — 你是 Maker，它們是你的影子團隊。

---

## 為什麼需要這個

你一個人開發，但需要：
- **PO** 幫你想清楚要做什麼、排優先級
- **Architect** 幫你做技術決策、寫 ADR
- **QA** 幫你審代碼、補測試
- **SRE** 幫你顧部署、建監控
- **SecOps** 幫你做安全審查
- **Stakeholder** 幫你在團隊卡住時做最終仲裁

更重要的是，它們會**彼此 review** — SRE 審 Architect 的 ADR、QA 審主 agent 的代碼、SecOps 審外部輸入處理。不是 6 個獨立助手，而是一張互相制衡的治理網。

Shikigami 把這 6 個角色定義成 Claude Code sub-agents，按觸發條件自動啟動。

---

## 適用場景

### 從零開發新產品
有想法沒團隊，需要快速從 0 到 MVP。AI 團隊跑 Discovery → Backlog → Sprint，每週交付可 Demo 的成果。

### 接手既有平台
繼承沒有文件、沒有測試的舊系統。Architect 盤架構、QA 補測試、SRE 建監控、SecOps 做掃描，Sprint 逐步還技術債。

### 一人公司 / 側專案
想維持工程紀律但沒人力。AI 團隊執行儀式，所有決策有 ADR 紀錄，隨時可回溯。

### 教學與研究
展示 AI agents 協作完成真實軟體工程。每個角色有業界標準依據（ISTQB、OWASP、Google SRE Book、RICE）。

---

## 快速開始

### 1. 複製框架

```bash
# 複製角色定義與流程文件
cp -r docs/team/ your-project/docs/team/

# 複製 Claude Code sub-agent 指令
cp -r .claude/agents/ your-project/.claude/agents/

# 複製模板
cp -r templates/ your-project/docs/
```

### 2. 客製化

- 把 `CLAUDE.md.template` 複製到專案根目錄，改名 `CLAUDE.md`，填入專案資訊
- 編輯 `.claude/agents/*.md` 裡的 `## 專案特定規則`，填入你的技術棧、檔案路徑、業務規則
- 根據專案需要調整 `docs/team/RACI.md` 的決策權分配

### 3. Product Discovery

告訴 Claude 你的產品願景，讓 PO 跑 Discovery：

```
你：「我想做一個 xxx 產品，目標使用者是 xxx」
 ↓
PO：發散討論 → 產出 ROADMAP.md + PRODUCT_BACKLOG.md
 ↓
Architect：識別需要技術選型的 Story → 產出 ADR
```

### 4. 跑 Sprint

```
Sprint Planning（選取 Story）
 ↓
Architect 產出 SDD（軟體設計文件）
 ↓
主 agent 依 SDD 寫測試 → 實作（TDD）
 ↓
QA / SRE / SecOps 按需 review
 ↓
Sprint Review（驗收 + 回顧 → 更新 Retrospective_Log）
 ↓
下一輪 Planning
```

每個 Sprint 的工作安排：
- **Planning**：PO 從 Backlog 選 Story 進 Sprint，確認有 ADR（SRE 已 review）才能進
- **設計**：Architect 為 Story 產出 SDD（設計規格），主 agent 依 SDD 執行
- **執行**：SDD → 寫測試 → 實作（TDD），QA 審代碼、SecOps 審安全
- **Review**：對照 DoD 驗收，記錄教訓到 Retrospective Log
- 詳細流程見 [scrum_process.md](docs/team/scrum_process.md)

---

## 框架架構

```
docs/team/
├── scrum_process.md       # 完整流程：Discovery → Sprint → 角色觸發 → DoD
├── RACI.md                # 決策權矩陣：誰負責、誰決定、誰被知會
└── roles/                 # 6 個角色定義（含業界標準引用）
    ├── product-owner.md
    ├── architect.md
    ├── qa-engineer.md
    ├── sre-engineer.md
    ├── security-engineer.md
    └── stakeholder.md

.claude/agents/            # Claude Code sub-agent 指令
├── po.md
├── architect.md
├── qa.md
├── sre.md
├── secops.md
└── stakeholder.md

templates/                 # 可直接複製使用的模板
├── PROJECT_BOARD.md
├── PRODUCT_BACKLOG.md
├── ROADMAP.md
└── sprint_template.md
```

### 雙層架構

| 層 | 位置 | 用途 |
|---|---|---|
| 第一層（工具無關） | `docs/team/` | 角色定義、流程、RACI — 換工具也能用 |
| 第二層（Claude Code 專用） | `.claude/agents/` | Sub-agent 指令 — 綁定 Claude Code 執行 |

---

## 核心設計原則

1. **自治優先** — 團隊自行閉環，Stakeholder 只管策略轉向和升級僵局
2. **事件驅動** — 角色按觸發條件啟動，不是每個任務都叫滿 6 個人
3. **文件即治理** — 所有決策留痕（ADR、SDD、Retro Log），不靠口頭共識
4. **測試先行** — SDD → 寫測試 → 實作（TDD），沒有設計文件不開工，沒有測試不算完成
5. **標準術語** — 保留 Scrum 標準名稱，人類接手時不用重新學
6. **務實簡化** — 每個儀式標注「實際執行」方式，AI 看得懂、人也看得懂

---

## 實際案例

本框架從 [小七巴拉](https://github.com/KCTW/seven-bala) 專案中提煉 — 一個 UCP 驅動的智慧咖啡快取服務。該專案使用本框架從 v1.0 MVP 推進至 v1.3，6 個 Sprint，12 個 User Stories，全程由 AI 團隊自治開發。

---

## 使用技巧

來自 [Anthropic 內部實戰報告](https://www.anthropic.com/engineering/claude-code-best-practices)與小七巴拉專案的經驗。

### CLAUDE.md 是靈魂

框架的效果取決於 `CLAUDE.md` 寫得多詳細。建議包含：
- 啟動清單（每次對話必讀的文件）
- 開發紅線（絕對不能違反的規則）
- 專案特定的業務規則與術語
- 檔案路徑速查表

### 拉霸機工作法

不要試圖修補不滿意的結果，而是：
```
git commit（存檔）→ 讓 Claude 跑 → 滿意就留，不滿意就 git revert 重來
```
頻繁 commit 是你的存檔點。重來比修補快。

### 一次一步

把大任務拆成小步驟，每步都能驗證。對齊 Sprint 思維：
- Discovery 階段不寫程式，只產出文件
- 一個 Story 做完、測試通過，再開下一個
- 避免同時改多個不相關的東西

### 截圖就是最好的 Bug Report

前端問題不用文字描述，直接貼截圖。Claude 能看圖理解 UI 問題，比描述「按鈕位置不對」快得多。

### 先規劃再動手

重要功能先在對話中跟 PO / Architect 討論完，再開始寫程式。對應框架流程：
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
| 你（人類） | 陰陽師 | 給方向、Review |
| 主 agent | 本體 | 日常開發、寫程式、跑測試 |
| 6 個 sub-agents | 式神 | 需要專業判斷時才召喚 |

這是刻意的設計：
- **主 agent 已經能寫程式** — 再開一個 Developer sub-agent 等於委派給分身，沒有意義
- **6 個角色的價值是「視角切換」** — 同一個 LLM 用不同 system prompt 提供主 agent 平時不會想到的觀點
- **不拆前後端** — AI agent 沒有人類的技能分工限制，拆開反而增加溝通成本

> Shikigami 不是完整的開發團隊框架，而是**開發者的治理護衛**。
> 主角負責所有開發工作，式神們負責確保品質、安全、架構、需求不跑偏。

</details>

<details>
<summary><b>可以加自訂角色嗎？</b></summary>
<br>

可以。在 `docs/team/roles/` 新增角色定義，再到 `.claude/agents/` 新增對應 sub-agent 指令即可。框架本身不限定角色數量。

</details>

<details>
<summary><b>AI 自己寫、自己 review，有效嗎？</b></summary>
<br>

有效，但有限度。QA sub-agent 用不同 system prompt 切換視角（專注找 bug、安全漏洞、測試覆蓋），能抓到主 agent 開發時的盲點。本質上是**同一個 LLM 的多角度自審**，比沒有 review 好，但不等於獨立的人類 review。

務實的做法：
- **日常開發**：靠 QA sub-agent 自審 + 自動化測試守底線
- **重要節點**：人類在 Sprint Review 時看結果、看 PR，不用逐行審
- **底線**：測試通過 + QA 無重大發現 = 可合併，人類有空再回頭看

> 這個框架的前提就是：人類沒時間事事過目，所以才需要式神。

</details>

<details>
<summary><b>不用 Claude Code 能用嗎？</b></summary>
<br>

第一層（`docs/team/`）是工具無關的 — 角色定義、RACI、流程可以套用到任何 AI 協作工具。第二層（`.claude/agents/`）是 Claude Code 專用，換工具需要重寫這層。

</details>

---

## License

MIT
