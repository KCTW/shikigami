# 式神 Shikigami — 召喚你的 Agent Scrum 團隊

> 用 Scrum 驅動 AI Agent 協作的治理框架

一套讓 AI agents 像真實 Scrum 團隊一樣協作的開源框架。6 個功能性角色各司其職，日常開發自行閉環，人類只需給方向和 Review。

就像陰陽師召喚式神 — 你是工程師，它們是你的影子團隊。

---

## 為什麼需要這個

你一個人開發，但需要：
- **PO** 幫你想清楚要做什麼、排優先級
- **Architect** 幫你做技術決策、寫 ADR
- **QA** 幫你審代碼、補測試
- **SRE** 幫你顧部署、建監控
- **SecOps** 幫你做安全審查
- **Stakeholder** 幫你在團隊卡住時做最終仲裁

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

### 1. 複製框架到你的專案

```bash
# 複製角色定義與流程文件
cp -r docs/team/ your-project/docs/team/

# 複製 Claude Code sub-agent 指令
cp -r .claude/agents/ your-project/.claude/agents/

# 複製模板
cp -r templates/ your-project/docs/
```

### 2. 設定 CLAUDE.md

把 `CLAUDE.md.template` 複製到你的專案根目錄，改名為 `CLAUDE.md`，填入你的專案資訊。

### 3. 開始第一個 Sprint

```
你（給方向）→ PO（Discovery + Backlog）→ Architect（ADR）→ Sprint Planning → 開工
```

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
4. **標準術語** — 保留 Scrum 標準名稱，人類接手時不用重新學
5. **務實簡化** — 每個儀式標注「實際執行」方式，AI 看得懂、人也看得懂

---

## 完整流程

```
Discovery（發散）→ Refinement（收斂）→ Planning（選取）→ 執行 → Review
   產出 Backlog      整理 Backlog       選進 Sprint            驗收 + 回顧
```

詳見 [scrum_process.md](docs/team/scrum_process.md)

---

## 實際案例

本框架從 [小七巴拉](https://github.com/KCTW/prj-ucpdemo) 專案中提煉 — 一個 UCP 驅動的智慧咖啡快取服務。該專案使用本框架從 v1.0 MVP 推進至 v1.3，6 個 Sprint，12 個 User Stories，全程由 AI 團隊自治開發。

---

## License

MIT
