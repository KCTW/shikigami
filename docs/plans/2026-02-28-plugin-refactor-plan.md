# Shikigami Plugin 架構重構實作計畫

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 將 Shikigami v0.3.0 從檔案模板框架重構為 Claude Code Plugin，支援全平台（Claude Code、Cursor、Codex、OpenCode）。

**Architecture:** 採用與 obra/superpowers 相同的 plugin 架構。角色定義放在 `agents/`（subagent prompt），流程定義放在 `skills/`（以活動為單位觸發），透過 hooks 在 session 啟動時注入 scrum-master 調度邏輯。

**Tech Stack:** Markdown + YAML frontmatter（skills/agents）、Bash + Batch polyglot（hooks）、JSON（plugin manifests）

---

### Task 1: 建立 Plugin 基礎架構

**Files:**
- Create: `.claude-plugin/plugin.json`
- Create: `.claude-plugin/marketplace.json`
- Create: `.cursor-plugin/plugin.json`
- Create: `.codex/INSTALL.md`
- Create: `.opencode/INSTALL.md`

**Step 1: 建立 `.claude-plugin/plugin.json`**

```json
{
  "name": "shikigami",
  "description": "AI Agent Scrum Team：7 個專業角色 × Subagent 驅動 × Scrum 流程自動化",
  "version": "1.0.0",
  "author": {
    "name": "KCTW",
    "email": ""
  },
  "homepage": "https://github.com/KCTW/shikigami",
  "repository": "https://github.com/KCTW/shikigami",
  "license": "MIT",
  "keywords": ["scrum", "agents", "team", "tdd", "quality", "security", "architecture"]
}
```

**Step 2: 建立 `.claude-plugin/marketplace.json`**

```json
{
  "name": "shikigami",
  "description": "AI Agent Scrum Team plugin marketplace",
  "owner": {
    "name": "KCTW",
    "email": ""
  },
  "plugins": [
    {
      "name": "shikigami",
      "description": "AI Agent Scrum Team：7 個專業角色 × Subagent 驅動 × Scrum 流程自動化",
      "version": "1.0.0",
      "source": "./",
      "author": {
        "name": "KCTW",
        "email": ""
      }
    }
  ]
}
```

**Step 3: 建立 `.cursor-plugin/plugin.json`**

```json
{
  "name": "shikigami",
  "displayName": "Shikigami",
  "description": "AI Agent Scrum Team：7 個專業角色 × Subagent 驅動 × Scrum 流程自動化",
  "version": "1.0.0",
  "author": {
    "name": "KCTW",
    "email": ""
  },
  "homepage": "https://github.com/KCTW/shikigami",
  "repository": "https://github.com/KCTW/shikigami",
  "license": "MIT",
  "keywords": ["scrum", "agents", "team", "tdd", "quality", "security", "architecture"],
  "skills": "./skills/",
  "agents": "./agents/",
  "commands": "./commands/",
  "hooks": "./hooks/hooks.json"
}
```

**Step 4: 建立 `.codex/INSTALL.md`**

安裝說明，教使用者 clone + symlink 到 `~/.agents/skills/shikigami`。參考 superpowers 的 `.codex/INSTALL.md` 格式，替換 repo URL 和路徑。

**Step 5: 建立 `.opencode/INSTALL.md`**

安裝說明，教使用者 clone + symlink + plugin 註冊。參考 superpowers 的 `.opencode/INSTALL.md` 格式。

**Step 6: Commit**

```bash
git add .claude-plugin/ .cursor-plugin/ .codex/ .opencode/
git commit -m "feat: 建立多平台 plugin 基礎架構"
```

---

### Task 2: 建立 Hook 系統

**Files:**
- Create: `hooks/hooks.json`
- Create: `hooks/session-start`
- Create: `hooks/run-hook.cmd`

**Step 1: 建立 `hooks/hooks.json`**

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume|clear|compact",
        "hooks": [
          {
            "type": "command",
            "command": "'${CLAUDE_PLUGIN_ROOT}/hooks/run-hook.cmd' session-start",
            "async": false
          }
        ]
      }
    ]
  }
}
```

**Step 2: 建立 `hooks/session-start`**

Bash 腳本，讀取 `skills/scrum-master/SKILL.md` 的內容，JSON-escape 後以 `additional_context` 輸出。格式完全參照 superpowers 的 `hooks/session-start`，但注入的是 scrum-master skill 而非 using-superpowers skill。

**Step 3: 建立 `hooks/run-hook.cmd`**

跨平台 polyglot wrapper（Windows batch + Unix shell），直接採用 superpowers 的 `run-hook.cmd` 不需修改。

**Step 4: 設定執行權限並 Commit**

```bash
chmod +x hooks/session-start
git add hooks/
git commit -m "feat: 建立 SessionStart hook 系統（跨平台）"
```

---

### Task 3: 建立 Scrum Master Skill（核心調度）

**Files:**
- Create: `skills/scrum-master/SKILL.md`

**Step 1: 撰寫 `skills/scrum-master/SKILL.md`**

這是整個 plugin 的核心，session 啟動時自動注入。內容必須包含：

1. **YAML frontmatter**:
   - `name: scrum-master`
   - `description: "Use when starting any conversation - 自動調度 Shikigami Agent Scrum Team 的角色分工與 Sprint 流程"`

2. **核心職責**：
   - 分析使用者意圖，決定觸發哪個流程 skill
   - 管理 Sprint 狀態機
   - 調度 subagent 派遣

3. **可用 Skills 清單**（讓 agent 知道有哪些 skills 可以 invoke）

4. **可用 Agents 清單**（7 個角色的 subagent，說明觸發時機）

5. **RACI 矩陣**：嵌入精簡版 RACI 表格

6. **升級路徑**：從 `docs/team/scrum_process.md` 遷移升級邏輯

7. **觸發規則表**：
   - 新功能/需求 → invoke `backlog-management` skill
   - Sprint 開始 → invoke `sprint-planning` skill
   - Story 實作 → invoke `sprint-execution` skill
   - 技術決策 → invoke `architecture-decision` skill
   - 功能完成/PR → invoke `quality-gate` skill
   - 安全相關 → invoke `security-review` skill
   - 部署 → invoke `deployment-readiness` skill
   - 衝突 → invoke `escalation` skill
   - Sprint 結束 → invoke `sprint-review` skill

**Step 2: Commit**

```bash
git add skills/scrum-master/
git commit -m "feat: 建立 scrum-master 核心調度 skill"
```

---

### Task 4: 建立 Sprint Planning Skill

**Files:**
- Create: `skills/sprint-planning/SKILL.md`

**Step 1: 撰寫 `skills/sprint-planning/SKILL.md`**

1. **YAML frontmatter**:
   - `name: sprint-planning`
   - `description: "Use when starting a new sprint, selecting stories from backlog, or beginning sprint planning ceremony"`

2. **內容**：從 `docs/team/scrum_process.md` 的「Sprint Planning」段落遷移，重寫為 skill 格式：
   - 流程 checklist（必須逐項建立 task）
   - PO subagent 派遣：讀取 Backlog、選取 Stories
   - Architect subagent 派遣：評估技術工時、檢查 ADR 需求
   - QA subagent 派遣：確認驗收標準可測試
   - 產出 `docs/sprints/sprint_N.md`
   - 更新 `docs/PROJECT_BOARD.md`

**Step 2: Commit**

```bash
git add skills/sprint-planning/
git commit -m "feat: 建立 sprint-planning skill"
```

---

### Task 5: 建立 Sprint Execution Skill

**Files:**
- Create: `skills/sprint-execution/SKILL.md`
- Create: `skills/sprint-execution/developer-prompt.md`
- Create: `skills/sprint-execution/spec-reviewer-prompt.md`
- Create: `skills/sprint-execution/quality-reviewer-prompt.md`

**Step 1: 撰寫 `skills/sprint-execution/SKILL.md`**

1. **YAML frontmatter**:
   - `name: sprint-execution`
   - `description: "Use when executing sprint stories, implementing features, or working through sprint backlog items"`

2. **內容**：Subagent 驅動開發流程：
   - 從 Sprint Backlog 逐個取出 Story
   - 派遣 Developer subagent 實作（使用 `developer-prompt.md`）
   - Developer 完成後，派遣 QA subagent 做 spec compliance review（使用 `spec-reviewer-prompt.md`）
   - 再派遣 QA subagent 做 code quality review（使用 `quality-reviewer-prompt.md`）
   - 如有安全相關 → 同時派遣 Security subagent
   - 不通過 → Developer 修復 → 重新審查
   - 通過 → 更新 PROJECT_BOARD → 下一個 Story

3. **Hard Gate**：
   ```
   <HARD-GATE>
   每個 Story 必須通過雙階段審查（spec compliance + code quality）才能標記為完成。
   </HARD-GATE>
   ```

**Step 2: 撰寫 `skills/sprint-execution/developer-prompt.md`**

Developer subagent prompt，包含：
- 角色定義（資深開發者）
- TDD 流程（Red → Green → Refactor）
- Commit 規範
- DoD 自檢清單
- 不可做的事（不能改架構、不能跳過測試）

**Step 3: 撰寫 `skills/sprint-execution/spec-reviewer-prompt.md`**

Spec Compliance Reviewer prompt，包含：
- 檢查實作是否符合 Story 的 Acceptance Criteria
- 檢查是否多做或少做
- 檢查測試是否覆蓋所有 AC
- 輸出格式：PASS / FAIL + 具體問題列表

**Step 4: 撰寫 `skills/sprint-execution/quality-reviewer-prompt.md`**

Code Quality Reviewer prompt，包含：
- 代碼品質評估（SOLID、命名、複雜度）
- 測試品質評估（覆蓋率、邊界值）
- 安全性基本檢查
- 輸出格式：Critical / Important / Suggestion 分類

**Step 5: Commit**

```bash
git add skills/sprint-execution/
git commit -m "feat: 建立 sprint-execution skill（含 developer、reviewer prompts）"
```

---

### Task 6: 建立 Sprint Review Skill

**Files:**
- Create: `skills/sprint-review/SKILL.md`

**Step 1: 撰寫 `skills/sprint-review/SKILL.md`**

1. **YAML frontmatter**:
   - `name: sprint-review`
   - `description: "Use when sprint ends, conducting sprint review and retrospective, or evaluating sprint outcomes"`

2. **內容**：從 `docs/team/scrum_process.md` 的「Sprint Review + Retrospective」段落遷移：
   - Review：PO subagent 展示 Demo 結果
   - 更新 PROJECT_BOARD（完成欄位）
   - 未達 DoD 的 Story 移回 Backlog
   - Retrospective：Good / Problem / Action
   - Action Items 驗收機制
   - 產出 `docs/km/Retrospective_Log.md` 更新

**Step 2: Commit**

```bash
git add skills/sprint-review/
git commit -m "feat: 建立 sprint-review skill"
```

---

### Task 7: 建立 Backlog Management Skill

**Files:**
- Create: `skills/backlog-management/SKILL.md`

**Step 1: 撰寫 `skills/backlog-management/SKILL.md`**

1. **YAML frontmatter**:
   - `name: backlog-management`
   - `description: "Use when new feature requests arrive, requirements change, backlog grooming is needed, or product discovery begins"`

2. **內容**：合併 Product Discovery + Backlog Grooming 流程：
   - PO subagent：分析需求、撰寫 User Story、RICE 排序
   - Architect subagent：識別需要 ADR 的 Story
   - 產出 / 更新 `PRODUCT_BACKLOG.md` 和 `ROADMAP.md`
   - Grooming：移除過時 Story、補充新 Story、調整優先級

**Step 2: Commit**

```bash
git add skills/backlog-management/
git commit -m "feat: 建立 backlog-management skill"
```

---

### Task 8: 建立 Architecture Decision Skill

**Files:**
- Create: `skills/architecture-decision/SKILL.md`

**Step 1: 撰寫 `skills/architecture-decision/SKILL.md`**

1. **YAML frontmatter**:
   - `name: architecture-decision`
   - `description: "Use when technical decisions are needed, architecture reviews, technology selection, ADR creation, or system design changes"`

2. **內容**：
   - Architect subagent 派遣：評估選項、產出 ADR
   - QA subagent 的 Decision Challenger 機制
   - SRE subagent Review（維運可行性）
   - ADR 格式與儲存位置（`docs/adr/ADR-xxx.md`）
   - **Hard Gate**：沒有 ADR 的技術選型 Story 不能進 Sprint

**Step 2: Commit**

```bash
git add skills/architecture-decision/
git commit -m "feat: 建立 architecture-decision skill"
```

---

### Task 9: 建立 Quality Gate Skill

**Files:**
- Create: `skills/quality-gate/SKILL.md`

**Step 1: 撰寫 `skills/quality-gate/SKILL.md`**

1. **YAML frontmatter**:
   - `name: quality-gate`
   - `description: "Use when code review is needed, features are complete, PRs are ready, or quality metrics need checking"`

2. **內容**：
   - QA subagent 派遣：代碼審查 + 測試覆蓋檢查
   - QA 的 Decision Challenger 角色（挑戰 Architect 決策）
   - 品質門禁標準（coverage > 80%、zero critical defects、automation > 70%）
   - 測試金字塔驗證（70% unit / 20% integration / 10% E2E）
   - PASS / FAIL 決策 + 修復迴圈

**Step 2: Commit**

```bash
git add skills/quality-gate/
git commit -m "feat: 建立 quality-gate skill"
```

---

### Task 10: 建立 Security Review Skill

**Files:**
- Create: `skills/security-review/SKILL.md`

**Step 1: 撰寫 `skills/security-review/SKILL.md`**

1. **YAML frontmatter**:
   - `name: security-review`
   - `description: "Use when handling external input, API endpoints, configuration changes, security scanning, or vulnerability assessment"`

2. **內容**：
   - Security Engineer subagent 派遣
   - OWASP Top 10 檢查清單
   - DevSecOps 實踐（SAST/DAST）
   - Secrets management 審查
   - Critical 漏洞阻塞流程
   - 升級觸發（Critical → Stakeholder + SRE 通知）

**Step 2: Commit**

```bash
git add skills/security-review/
git commit -m "feat: 建立 security-review skill"
```

---

### Task 11: 建立 Deployment Readiness Skill

**Files:**
- Create: `skills/deployment-readiness/SKILL.md`

**Step 1: 撰寫 `skills/deployment-readiness/SKILL.md`**

1. **YAML frontmatter**:
   - `name: deployment-readiness`
   - `description: "Use when preparing for deployment, version release, environment configuration changes, or production readiness checks"`

2. **內容**：
   - SRE subagent 派遣：部署計畫 + 回滾方案
   - Security subagent 並行：部署前安全掃描
   - Golden Signals 監控配置檢查
   - SLO/SLI 驗證
   - 部署 checklist

**Step 2: Commit**

```bash
git add skills/deployment-readiness/
git commit -m "feat: 建立 deployment-readiness skill"
```

---

### Task 12: 建立 Escalation Skill

**Files:**
- Create: `skills/escalation/SKILL.md`

**Step 1: 撰寫 `skills/escalation/SKILL.md`**

1. **YAML frontmatter**:
   - `name: escalation`
   - `description: "Use when team conflicts cannot be resolved, major product pivots are needed, or escalation chain must be activated"`

2. **內容**：
   - 升級路徑（技術→Architect、品質→QA、安全→SecOps、部署→SRE、需求→PO、全部→Stakeholder）
   - 升級原則（先同層級解決）
   - Stakeholder subagent 觸發條件
   - 升級格式（問題描述 + 已嘗試方案 + 推薦選項）

**Step 2: Commit**

```bash
git add skills/escalation/
git commit -m "feat: 建立 escalation skill"
```

---

### Task 13: 建立 7 個 Agent Prompt Templates

**Files:**
- Create: `agents/product-owner.md`
- Create: `agents/architect.md`
- Create: `agents/developer.md`
- Create: `agents/qa-engineer.md`
- Create: `agents/sre-engineer.md`
- Create: `agents/security-engineer.md`
- Create: `agents/stakeholder.md`

**Step 1: 遷移 Product Owner agent**

從 `.claude/agents/po.md` 遷移內容，移除「專案特定規則」的佔位符（`> [根據你的專案調整]`），改為通用格式。保留方法論和跨角色協作段落。

**Step 2: 遷移 Architect agent**

從 `.claude/agents/architect.md` 遷移。

**Step 3: 建立 Developer agent（全新）**

這是新角色，prompt 必須包含：
- 角色定義：資深全端開發者
- TDD 強制（Red → Green → Refactor）
- Commit 規範
- DoD 自檢清單
- 限制：不能改架構決策（那是 Architect 的權限）、不能跳過測試
- 代碼品質標準（SOLID、DRY、KISS）

**Step 4: 遷移 QA Engineer agent**

從 `.claude/agents/qa.md` 遷移，保留 Decision Challenger 機制。

**Step 5: 遷移 SRE Engineer agent**

從 `.claude/agents/sre.md` 遷移。

**Step 6: 遷移 Security Engineer agent**

從 `.claude/agents/secops.md` 遷移。

**Step 7: 遷移 Stakeholder agent**

從 `.claude/agents/stakeholder.md` 遷移。

**Step 8: Commit**

```bash
git add agents/
git commit -m "feat: 建立 7 個 agent prompt templates（含新 developer 角色）"
```

---

### Task 14: 建立 Commands（Slash Commands）

**Files:**
- Create: `commands/sprint.md`
- Create: `commands/standup.md`
- Create: `commands/review.md`

**Step 1: 建立 `commands/sprint.md`**

```markdown
---
description: "啟動 Sprint 規劃流程，從 Backlog 選取 Stories 並建立 Sprint 計畫"
disable-model-invocation: true
---

Invoke the shikigami:sprint-planning skill and follow it exactly as presented to you
```

**Step 2: 建立 `commands/standup.md`**

```markdown
---
description: "執行每日站立會議，檢視當前 Sprint 進度與阻礙"
disable-model-invocation: true
---

讀取 `docs/PROJECT_BOARD.md` 的「進行中」欄位，產出 Daily Standup 摘要：
- 昨天完成：[任務]
- 今天計畫：[任務]
- 阻礙：[有/無，描述]
```

**Step 3: 建立 `commands/review.md`**

```markdown
---
description: "執行 Sprint 回顧，產出 Review + Retrospective 紀錄"
disable-model-invocation: true
---

Invoke the shikigami:sprint-review skill and follow it exactly as presented to you
```

**Step 4: Commit**

```bash
git add commands/
git commit -m "feat: 建立 slash commands（/sprint, /standup, /review）"
```

---

### Task 15: 遷移 Templates

**Files:**
- Modify: `templates/PLAYBOOK.md` — 移除佔位符，改為通用版本
- Modify: `templates/CLAUDE.md.template` — 更新為 plugin 架構的啟動協定
- Keep: 其他 templates 不動

**Step 1: 更新 `templates/CLAUDE.md.template`**

重寫為 plugin 架構下的啟動協定：
- 不再手動讀取 docs/team/ 文件（由 hook 自動注入）
- 改為指引使用者安裝 shikigami plugin
- 列出可用 slash commands
- 保留專案特定配置區塊

**Step 2: 將 `CLAUDE.md.template` 移到根目錄（已在根目錄就保持）**

**Step 3: Commit**

```bash
git add templates/
git commit -m "refactor: 更新 templates 適配 plugin 架構"
```

---

### Task 16: 清理舊結構 + 更新文件

**Files:**
- Delete: `.claude/agents/` 整個目錄
- Delete: `docs/team/` 整個目錄（內容已遷移至 skills/ 和 agents/）
- Delete: `scripts/` 目錄（功能遷移至 hooks/）
- Modify: `README.md` — 更新為 plugin 安裝說明
- Modify: `README.en.md` — 同步更新英文版
- Modify: `.gitignore` — 加入 `.claude/context/` 等

**Step 1: 刪除已遷移的舊目錄**

```bash
rm -rf .claude/agents/
rm -rf docs/team/
rm -rf scripts/
```

**Step 2: 更新 README.md**

重寫為：
- 專案介紹（Agent Scrum Team 概念）
- 安裝方式（Claude Code plugin install）
- 7 個角色介紹
- 可用 Skills 清單
- 可用 Commands 清單
- Cursor / Codex / OpenCode 安裝說明
- 與 superpowers 的關係（獨立 plugin，可並存）

**Step 3: 更新 README.en.md**

英文版同步更新。

**Step 4: 更新 `.gitignore`**

確保包含：
```
.claude/context/
*.pyc
__pycache__/
.venv/
venv/
node_modules/
.env
.env.local
*.swp
.DS_Store
```

**Step 5: Commit**

```bash
git add -A
git commit -m "refactor: 清理舊結構，更新 README 為 plugin 安裝說明"
```

---

### Task 17: 驗證 Plugin 載入

**Step 1: 檢查目錄結構完整性**

```bash
find . -name "SKILL.md" | sort
find . -name "*.md" -path "*/agents/*" | sort
find . -name "*.md" -path "*/commands/*" | sort
ls hooks/
ls .claude-plugin/
```

Expected:
- 10 個 SKILL.md（scrum-master, sprint-planning, sprint-execution, sprint-review, backlog-management, architecture-decision, quality-gate, security-review, deployment-readiness, escalation）
- 7 個 agent md
- 3 個 command md
- hooks.json + session-start + run-hook.cmd
- plugin.json + marketplace.json

**Step 2: 驗證 hook 腳本可執行**

```bash
bash hooks/session-start
```

Expected: 輸出 JSON 格式的 `additional_context`，內容包含 scrum-master skill

**Step 3: 驗證 YAML frontmatter 格式**

```bash
for f in $(find skills -name "SKILL.md"); do
  echo "=== $f ==="
  head -5 "$f"
  echo ""
done
```

Expected: 每個 SKILL.md 都以 `---` 開頭，包含 `name:` 和 `description:`

**Step 4: 最終 Push**

```bash
GITHUB_TOKEN="" git push
```

---

## 執行摘要

| Task | 內容 | 預估檔案數 |
|------|------|-----------|
| 1 | Plugin 基礎架構 | 5 |
| 2 | Hook 系統 | 3 |
| 3 | Scrum Master Skill | 1 |
| 4 | Sprint Planning Skill | 1 |
| 5 | Sprint Execution Skill | 4 |
| 6 | Sprint Review Skill | 1 |
| 7 | Backlog Management Skill | 1 |
| 8 | Architecture Decision Skill | 1 |
| 9 | Quality Gate Skill | 1 |
| 10 | Security Review Skill | 1 |
| 11 | Deployment Readiness Skill | 1 |
| 12 | Escalation Skill | 1 |
| 13 | 7 Agent Prompts | 7 |
| 14 | Commands | 3 |
| 15 | Templates 更新 | 2 |
| 16 | 清理 + README | 4 |
| 17 | 驗證 | 0 |
| **合計** | | **~37 files** |
