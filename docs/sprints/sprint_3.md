# Sprint 3

> 週期：2026-03-07 ~ 2026-03-14
> 狀態：已完成（v0.2.0）
> 專案等級：low（完全自治）

---

## Sprint Goal

**「完成 v0.2.0 自我感知，並修復跨兩個 Sprint 的行為性缺陷」**

Sprint 2 完成了被動感知（Health Check + Standup 遠端差距），但留下兩個行為性缺陷未修：Sprint Review 未自動觸發（Retro Action #1，跨兩個 Sprint 重犯）、Health Check 只有被動查詢（Stakeholder 回饋）。本 Sprint 同時推進 v0.2.0 剩餘功能需求（Onboarding、測試框架版號驗證），補完自我感知主題。

對應 ROADMAP：v0.2.0「自我感知」主題收尾。

---

## Sprint Backlog

| Story | 任務 | 負責 | 狀態 |
|---|---|---|---|
| Story 1（Retro Action #3）：Sprint Review 自動觸發重修 | 修改 `skills/sprint-execution/SKILL.md` 流程末端邏輯 + `skills/scrum-master/SKILL.md` 6.1「絕對不問」清單 | Scrum Master | 完成 |
| US-06：Onboarding（專案初始化） | 新建 `skills/onboarding/SKILL.md`，實作目錄建立 + 文件複製 + CLAUDE.md 生成 + 路由 | Developer + QA | 完成 |
| Story 3（Retro Action #2）：Health Check 自動掛鉤 | 修改 `commands/standup.md` 加入輕量掃描（2 項）+ 修改 `skills/sprint-planning/SKILL.md` 加入完整 4 項檢查 | Developer | 完成 |
| US-T04：版號一致性驗證 | 新建版號驗證腳本，範圍限定 `.claude-plugin/` 下的 `plugin.json` 與 `marketplace.json` | Developer + QA | 完成 |

---

## 工作容量

- Story 1（Retro #3）：~0.3 Sprint（S，行為修復，改文件邏輯）
- US-06：~0.4 Sprint（S-M，新建 Skill + 7 項 AC，邏輯較複雜）
- Story 3（Retro #2）：~0.3 Sprint（S，修改兩個現有文件）
- US-T04：~0.2 Sprint（S，腳本驗證，路徑清晰）
- 合計：1.2 Sprint（預估 5 points，歷史 Velocity 7-8，保留緩衝應對 Retro #3 不確定性）

**Points 換算**（T-shirt Sizing）：Story 1 = 1pt（S）、US-06 = 2pt（M）、Story 3 = 1pt（S）、US-T04 = 1pt（S）= 合計 **5 points**

> **T-shirt Sizing 參考**：
> - S（< 0.3 Sprint）：單一模組小改動，路徑清晰
> - M（0.3-0.7 Sprint）：跨模組，需設計但風險可控
> - L（> 0.7 Sprint）：跨層、新架構、高不確定性

---

## 風險

| 風險 | 可能性 | 影響 | 應對 |
|---|---|---|---|
| Story 1（Retro #3）是跨兩個 Sprint 的重犯問題，根因為「規則存在但行為未遵循」，文件修改後效果不確定 | 中 | 中 | AC4 設為延遲驗證（Sprint 3 結束觀測），不阻塞 Done 判定；Sprint Review 作為最終驗收點 |
| US-06 Onboarding 的 CLAUDE.md 生成涉及互動問答，low 等級下可能仍需少量人工介入 | 中 | 低 | AC4 明確豁免不阻塞原則，CLAUDE.md 是框架根設定，任何等級皆需人工確認，已在 AC 中說明 |
| Story 3 standup 輕量掃描增加執行成本，影響 standup 速度 | 低 | 低 | 輕量掃描限 2 項（必要文件 + Retro 逾期），不執行 git 操作，速度影響可忽略 |
| US-T04 的 git tag 驗證在 0.x.x 開發期可能頻繁觸發 WARNING，降低訊號品質 | 低 | 低 | AC3 已設計降級機制：^0\.\d+\.\d+$ 時降為 WARNING，1.0.0 以上恢復強制 |
| QA 識別：.cursor-plugin 版號（1.0.0）與 .claude-plugin（0.1.0）不一致，未來可能造成使用者困惑 | 低 | 低 | 當前 Sprint 不處理，US-T04 範圍已限定 .claude-plugin/，未來另開 Story |

---

## Story 詳情

### Story 1（Retro Action #3）：Sprint Review 自動觸發重修

**背景**：Sprint 1 Retro Action #1 誤判 Closed，Sprint 2 重犯同一問題（Scrum Master 在 Sprint Execution 完成後詢問是否觸發 sprint-review，而非直接觸發）。Sprint 2 已有「不阻塞原則」章節，問題根因為行為層未遵循規則，非規則缺失。

**修改目標**：`skills/sprint-execution/SKILL.md`、`skills/scrum-master/SKILL.md`

**Acceptance Criteria**（QA 修正後版本）

| # | 條件 | 通過標準 |
|---|------|----------|
| AC1 | sprint-execution 流程末端分支 | `skills/sprint-execution/SKILL.md` 第 3 節流程末端包含明確分支：Sprint Backlog 清空 → 立即 invoke sprint-review，不跳回「下一個 Story」或詢問使用者 |
| AC2 | scrum-master 絕對不問清單 | `skills/scrum-master/SKILL.md` 6.1「絕對不問」新增條目：「Sprint Execution 完成後是否觸發 Sprint Review」 |
| AC3 | 邏輯一致性 | sprint-execution 終止條件與 scrum-master 5.2 狀態驅動邏輯一致，無矛盾（兩個文件的觸發規則描述相同） |
| AC4 | 行為層驗收（延遲驗證） | Sprint 3 結束時觀測：sprint-review 零詢問自動觸發。此 AC 不阻塞 Done 判定，於 Sprint 3 Sprint Review 時評估 |

---

### US-06：Onboarding（專案初始化）

**User Story**
As a new user, I want Shikigami to automatically scaffold my project's document structure after installation, so that I can start my first Sprint within 5 minutes without manually creating directories or copying templates.

**修改目標**：新建 `skills/onboarding/SKILL.md`，更新 `skills/scrum-master/SKILL.md` 決策樹

**Acceptance Criteria**（QA 修正後版本）

| # | 條件 | 通過標準 |
|---|------|----------|
| AC1 | 觸發與路由 | (a) `skills/onboarding/SKILL.md` 存在且 frontmatter 含 `name` 與 `description` 欄位；(b) `skills/scrum-master/SKILL.md` 5.1 決策樹新增一條「意圖描述 → invoke shikigami:onboarding」路由 |
| AC2 | 目錄結構建立 | 執行後 `docs/prd/`、`docs/adr/`、`docs/sprints/`、`docs/km/` 四個目錄全部存在；已存在不寫入，AI 輸出「[略過] docs/xxx/ 已存在」 |
| AC3 | 初始文件複製 | 從 `templates/` 複製 `PRODUCT_BACKLOG.md`、`ROADMAP.md`、`PROJECT_BOARD.md` 至 `docs/prd/`；已存在不覆蓋，標記警告而非中斷 |
| AC4 | CLAUDE.md 生成 | `CLAUDE.md` 不存在時，詢問使用者 3 個問題（專案名稱、技術棧、專案等級）後生成。**【豁免不阻塞原則】**：CLAUDE.md 是框架根設定，錯誤等級=高風險，任何專案等級皆需人工確認。已存在略過，輸出「CLAUDE.md 已存在，使用現有設定」 |
| AC5 | Product Discovery 引導 | 初始化完成後輸出下一步清單，必含 3 項：確認 CLAUDE.md 內容、執行 `/standup` 確認環境、說明如何啟動 Sprint Planning；允許輸出額外引導項目 |
| AC6 | 冪等性 | 重複執行不產生錯誤、不覆蓋已存在內容；輸出「跳過 X 目錄、Y 檔案（共 Z 項）」摘要 |
| AC7 | 錯誤處理 | `templates/` 不存在時輸出明確錯誤訊息「templates/ 目錄遺失，請確認 Shikigami 安裝完整」，不靜默失敗 |

---

### Story 3（Retro Action #2）：Health Check 自動掛鉤

**背景**：Sprint 2 Stakeholder 回饋：Health Check 目前只有被動查詢，需要掛鉤到 standup 或 Sprint 開始時自動觸發。PO 決策：兩者都要，但範圍不同（standup 輕量 2 項、sprint-planning 完整 4 項）。

**修改目標**：`commands/standup.md`、`skills/sprint-planning/SKILL.md`

**Acceptance Criteria**（QA 修正後版本，含 PO 決策）

| # | 條件 | 通過標準 |
|---|------|----------|
| AC1 | standup 輕量掃描 | `commands/standup.md` 在區塊一前執行輕量健康掃描（必要文件存在性 + Retro Action Items 逾期偵測，共 2 項）；掃描結果輸出於報告頂端；WARNING/CRITICAL 附提示但不阻塞後續 standup 流程 |
| AC2 | sprint-planning 完整檢查 | `skills/sprint-planning/SKILL.md` 第 2 節 Checklist「選取 Stories」步驟前執行完整 4 項健康檢查（必要文件 + 孤兒 Story + ADR 一致性 + Retro 逾期）；CRITICAL 標注警告但不阻塞 Planning 流程 |

---

### US-T04：版號一致性驗證

**User Story**
As a Developer, I want a check that ensures version numbers are consistent across `.claude-plugin/` files, so that plugin installation doesn't silently use mismatched versions.

**範圍說明**：US-T04 範圍限定為 `.claude-plugin/` 下的檔案。`.cursor-plugin` 是 Cursor 適配，與 Claude Code 主體獨立，版本策略不同，不納入本 Story 驗證範圍。

**修改目標**：新建版號驗證腳本（路徑由 Developer 決定，建議 `scripts/validate-version.sh` 或整合至現有 pre-commit hook）

**Acceptance Criteria**（QA 修正後版本）

| # | 條件 | 通過標準 |
|---|------|----------|
| AC1 | plugin.json 與 marketplace.json 一致性 | 驗證 `.claude-plugin/plugin.json` 的 `version` 與 `.claude-plugin/marketplace.json` 的 `plugins[0].version` 相同；不同則 FAIL + 非零 exit code |
| AC2 | git tag 一致性 | 若存在 git tag，最新 semver tag 與 `.claude-plugin/plugin.json` 的 `version` 一致；不一致則報錯 |
| AC3 | 0.x.x 開發期降級 | `version` 符合 `^0\.\d+\.\d+$` 時，AC2 降級為 WARNING（非 FAIL），允許開發期 tag 未對齊；1.0.0 以上恢復強制 FAIL |

---

## Retro Action Items 處理

| # | Action（原始） | 本 Sprint 處理方式 | 來源 |
|---|---------------|-------------------|------|
| Sprint 1 #1 / Sprint 2 #3 | Sprint Review 自動觸發（跨兩 Sprint 重犯） | 納入 Sprint 3 為 Story 1，完整重修 | Sprint 1 + Sprint 2 Retro |
| Sprint 2 #2 | Health Check 自動掛鉤 | 納入 Sprint 3 為 Story 3 | Sprint 2 Retro |
| Sprint 2 #1 | PO 補寫 US-06、US-08 進 Backlog | 已關閉（Sprint 3 Planning 完成）| Sprint 2 Retro |

---

## 驗收標準

- [x] Story 1（Retro #3）：sprint-execution SKILL.md 流程末端含明確 invoke sprint-review 分支（AC1-AC3 通過）
- [x] Story 1（Retro #3）：scrum-master 6.1「絕對不問」清單含 Sprint Review 觸發條目（AC2 通過）
- [x] Story 1（Retro #3）：[延遲驗證] Sprint 3 結束時 sprint-review 零詢問自動觸發（AC4 PASS）
- [x] US-06：onboarding SKILL.md 存在且路由已配置（AC1 通過）
- [x] US-06：目錄建立、文件複製、CLAUDE.md 生成、冪等性、錯誤處理（AC2-AC7 通過）
- [x] Story 3（Retro #2）：standup.md 含輕量掃描（2 項）輸出於報告頂端（AC1 通過）
- [x] Story 3（Retro #2）：sprint-planning SKILL.md 含完整 4 項健康檢查（AC2 通過）
- [x] US-T04：.claude-plugin/ 版號一致性驗證腳本 FAIL + 非零 exit（AC1 通過）
- [x] US-T04：git tag 驗證含 0.x.x 降級邏輯（AC2-AC3 通過）
- [x] 既有功能不受影響（反回歸：standup 其餘欄位、health-check 主命令、scrum-master 路由）

---

## Sprint Review 記錄

**日期**：2026-03-01
**Sprint Goal 達成**：是（4/4 Stories PASS）
**Velocity**：5 points（1M + 3S）
**Stakeholder 決定**：接受，v0.2.0 Release 批准

### 展示結果

| Story | 驗收結果 | 備注 |
|-------|----------|------|
| Story 1（Retro #3）：Sprint Review 自動觸發重修 | PASS | AC4 延遲驗證通過：本次 Sprint Review 零詢問自動觸發，確認 Sprint 1/2 跨兩 Sprint 的重犯問題正式修復 |
| US-06：Onboarding（專案初始化） | PASS | 全部 7 項 AC 通過，含 CLAUDE.md 豁免不阻塞原則設計 |
| Story 3（Retro #2）：Health Check 自動掛鉤 | PASS | standup 輕量掃描（2 項）+ sprint-planning 完整掃描（4 項）均通過 |
| US-T04：版號一致性驗證 | PASS | TDD 嚴格執行 Red-Green-Refactor，11 個測試案例全覆蓋 |

### Stakeholder 回饋

- v0.2.0「自我感知」主題收尾，Release 批准
- US-08 Sprint Metrics 推遲至 Sprint 4，認可容量決策合理
- AC 品質系統性問題列入 Retro，要求 Sprint 4 開始實施 [靜態]/[動態] 分類標注
