# Shikigami — Codex 安裝指南

## 前提條件

- 已安裝 [Codex](https://github.com/openai/codex)
- 已安裝 Git
- 終端環境：macOS / Linux / Windows (PowerShell)

---

## 安裝步驟

### macOS / Linux

```bash
# 1. Clone 到 Codex 目錄
git clone https://github.com/KCTW/shikigami.git ~/.codex/shikigami

# 2. 建立 skills 的 symlink
mkdir -p ~/.agents/skills
ln -s ~/.codex/shikigami/skills ~/.agents/skills/shikigami

# 3. 重啟 Codex
```

### Windows (PowerShell)

```powershell
# 1. Clone 到 Codex 目錄
git clone https://github.com/KCTW/shikigami.git "$env:USERPROFILE\.codex\shikigami"

# 2. 建立 skills 的 symlink（需以系統管理員身份執行）
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.agents\skills"
New-Item -ItemType SymbolicLink `
  -Path "$env:USERPROFILE\.agents\skills\shikigami" `
  -Target "$env:USERPROFILE\.codex\shikigami\skills"

# 3. 重啟 Codex
```

---

## 驗證安裝

安裝完成後，執行以下指令確認 plugin 已正確載入：

```bash
# 確認 symlink 存在
ls -la ~/.agents/skills/shikigami

# 確認 skills 目錄內容
ls ~/.agents/skills/shikigami/
```

你應該會看到 Shikigami 的 skill 檔案列表。在 Codex 中使用 `/shikigami` 或相關指令即可開始使用。

---

## 更新

```bash
cd ~/.codex/shikigami
git pull origin main
```

Symlink 會自動指向最新版本，無需重新建立。

---

## 移除

### macOS / Linux

```bash
rm ~/.agents/skills/shikigami
rm -rf ~/.codex/shikigami
```

### Windows (PowerShell)

```powershell
Remove-Item "$env:USERPROFILE\.agents\skills\shikigami"
Remove-Item -Recurse -Force "$env:USERPROFILE\.codex\shikigami"
```
