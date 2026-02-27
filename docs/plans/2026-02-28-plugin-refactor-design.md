# Shikigami Plugin 架構重構設計

> **日期**: 2026-02-28
> **版本**: v1.0.0（從 v0.3.0 重構）
> **狀態**: 已核准

## 目標

將 Shikigami 從「檔案模板框架」重構為 **Claude Code Plugin**，採用與 obra/superpowers 相同的 plugin 架構，實現：

1. 安裝即可用（`claude plugins add shikigami`）
2. Skills 自動發現與觸發式載入
3. 7 個 Subagent 角色驅動的 Scrum 協作
4. 全平台支援（Claude Code、Cursor、Codex、OpenCode）

## 核心設計決策

### 1. 角色組成：7 個角色

| 角色 | 職責 | 觸發時機 |
|------|------|----------|
| Product Owner | 需求定義、Sprint 規劃、優先排序 | 新功能、需求變更、Sprint 開始 |
| Architect | 系統設計、ADR、技術選型 | 技術決策、設計審查 |
| **Developer** | **實作程式碼、TDD、重構** | **Story 實作、Bug 修復** |
| QA Engineer | 測試策略、品質門禁、Decision Challenger | 程式碼審查、測試規劃 |
| SRE Engineer | 部署、監控、可靠性 | 部署就緒、環境變更 |
| Security Engineer | 安全審查、OWASP、弱點掃描 | 外部輸入處理、安全審查 |
| Stakeholder | 最終仲裁、策略方向 | 團隊升級、重大方向轉變 |

**新增 Developer 角色**：原有 6 角色全是「審查/決策」型，缺少實際寫 code 的執行者。

### 2. 協作模式：Subagent 驅動

```
主 Agent（Scrum Master skill）
  ↓ 分析任務 context
  ↓ 決定需要哪些角色
  ↓ 派遣對應 subagent
  ↓ subagent 獨立執行（乾淨 context）
  ↓ 雙階段審查（spec compliance + code quality）
  ↓ 回報主 Agent
  ↓ 下一個任務
```

### 3. 生態定位：獨立 Plugin

- 自包含所有流程（不依賴 superpowers）
- 可與 superpowers 並存使用
- 參考但不 fork superpowers 的程式碼

### 4. 文件語言：繁中為主，英文輔助

- Skill 內容、模板、文件：繁體中文
- metadata、檔名、程式碼：英文

## 目錄結構

```
shikigami/
├── .claude-plugin/
│   ├── plugin.json
│   └── marketplace.json
├── .cursor-plugin/
│   └── plugin.json
├── .codex/
├── .opencode/
│
├── skills/
│   ├── scrum-master/            # 主控調度 skill
│   │   └── SKILL.md
│   ├── sprint-planning/         # Sprint 規劃儀式
│   │   └── SKILL.md
│   ├── sprint-execution/        # Sprint 執行（subagent 派遣）
│   │   ├── SKILL.md
│   │   ├── developer-prompt.md
│   │   ├── spec-reviewer-prompt.md
│   │   └── quality-reviewer-prompt.md
│   ├── sprint-review/           # Sprint 回顧
│   │   └── SKILL.md
│   ├── backlog-management/      # Product Backlog 管理
│   │   └── SKILL.md
│   ├── architecture-decision/   # 架構決策（ADR）
│   │   └── SKILL.md
│   ├── quality-gate/            # QA 品質門禁
│   │   └── SKILL.md
│   ├── security-review/         # 安全審查
│   │   └── SKILL.md
│   ├── deployment-readiness/    # 部署就緒檢查
│   │   └── SKILL.md
│   └── escalation/              # 衝突升級仲裁
│       └── SKILL.md
│
├── agents/
│   ├── product-owner.md
│   ├── architect.md
│   ├── developer.md
│   ├── qa-engineer.md
│   ├── sre-engineer.md
│   ├── security-engineer.md
│   └── stakeholder.md
│
├── commands/
│   ├── sprint.md
│   ├── standup.md
│   └── review.md
│
├── hooks/
│   ├── hooks.json
│   ├── session-start
│   └── run-hook.cmd
│
├── templates/
│   ├── PLAYBOOK.md
│   ├── PRODUCT_BACKLOG.md
│   ├── ROADMAP.md
│   ├── PROJECT_BOARD.md
│   ├── sprint_template.md
│   └── CLAUDE.md.template
│
├── README.md
├── README.en.md
└── LICENSE
```

## Skill 設計概要

### scrum-master（核心調度）
- SessionStart hook 自動載入
- 分析使用者意圖，決定觸發哪個流程 skill
- 管理 Sprint 狀態機（Planning → Execution → Review）

### sprint-planning
- 派遣 PO subagent 進行需求分析
- 派遣 Architect subagent 進行技術評估
- 產出 Sprint Backlog + Sprint Goal

### sprint-execution
- 逐個 Story 派遣 Developer subagent 實作
- 每完成一個 Story：
  - QA subagent 審查 spec compliance
  - Security subagent 審查安全性
  - 若不通過 → Developer 修復 → 重新審查

### quality-gate
- QA 角色的 Decision Challenger 機制
- 程式碼覆蓋率門禁（80%+）
- 測試金字塔驗證

### architecture-decision
- ADR 撰寫流程
- 技術選型評估框架
- SOLID / Clean Architecture 檢查

## 從 v0.3.0 遷移

### 保留
- `templates/` 全部保留（PLAYBOOK, ROADMAP, BACKLOG, etc.）
- 角色定義的核心內容（重寫為 agent prompt 格式）
- Scrum 流程邏輯（重寫為 skill 格式）
- RACI 矩陣概念（嵌入 scrum-master skill）

### 移除
- `docs/team/` 整個目錄（內容遷移至 skills/ 和 agents/）
- `.claude/agents/` 舊目錄（被新 agents/ 取代）
- `scripts/` 目錄（功能遷移至 hooks/）

### 新增
- `.claude-plugin/` 系列（plugin 清單）
- `skills/` 所有 SKILL.md
- `agents/developer.md`（新角色）
- `hooks/` 系統
- `commands/` slash commands
