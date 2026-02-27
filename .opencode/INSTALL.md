# Shikigami — OpenCode 安裝指南

## 前提條件

- 已安裝 [OpenCode](https://github.com/opencode-ai/opencode)
- 已安裝 Git
- 終端環境：macOS / Linux / Windows (PowerShell)

---

## 安裝步驟

### macOS / Linux

```bash
# 1. Clone 到 OpenCode 設定目錄
git clone https://github.com/KCTW/shikigami.git ~/.config/opencode/shikigami

# 2. 建立 skills 的 symlink
mkdir -p ~/.config/opencode/skills
ln -s ~/.config/opencode/shikigami/skills ~/.config/opencode/skills/shikigami

# 3. 重啟 OpenCode
```

### Windows (PowerShell)

```powershell
# 1. Clone 到 OpenCode 設定目錄
git clone https://github.com/KCTW/shikigami.git "$env:APPDATA\opencode\shikigami"

# 2. 建立 skills 的 symlink（需以系統管理員身份執行）
New-Item -ItemType Directory -Force -Path "$env:APPDATA\opencode\skills"
New-Item -ItemType SymbolicLink `
  -Path "$env:APPDATA\opencode\skills\shikigami" `
  -Target "$env:APPDATA\opencode\shikigami\skills"

# 3. 重啟 OpenCode
```

---

## 驗證安裝

安裝完成後，執行以下指令確認 plugin 已正確載入：

```bash
# 確認 symlink 存在
ls -la ~/.config/opencode/skills/shikigami

# 確認 skills 目錄內容
ls ~/.config/opencode/skills/shikigami/
```

你應該會看到 Shikigami 的 skill 檔案列表。在 OpenCode 中即可開始使用 Shikigami 的各項功能。

---

## 更新

```bash
cd ~/.config/opencode/shikigami
git pull origin main
```

Symlink 會自動指向最新版本，無需重新建立。

---

## 移除

### macOS / Linux

```bash
rm ~/.config/opencode/skills/shikigami
rm -rf ~/.config/opencode/shikigami
```

### Windows (PowerShell)

```powershell
Remove-Item "$env:APPDATA\opencode\skills\shikigami"
Remove-Item -Recurse -Force "$env:APPDATA\opencode\shikigami"
```
