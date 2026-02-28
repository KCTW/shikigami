"""US-T02: Agent 完整性驗證

驗證每個 agent .md 檔案都有正確的 frontmatter（name, description, model）。
"""

import os
import re
import sys

import yaml

AGENTS_DIR = os.path.join(os.path.dirname(__file__), '..', 'agents')

VALID_MODELS = {'sonnet', 'haiku', 'opus'}


def parse_frontmatter(content):
    """從 Markdown 內容中解析 YAML frontmatter。"""
    match = re.match(r'^---\n(.*?)\n---', content, re.DOTALL)
    if not match:
        return None
    return yaml.safe_load(match.group(1))


def test_agents():
    errors = []
    agents_dir = os.path.normpath(AGENTS_DIR)

    if not os.path.isdir(agents_dir):
        errors.append(f"agents/ 目錄不存在: {agents_dir}")
        return errors

    # AC1: 掃描 agents/ 下所有 .md 檔案
    md_files = sorted(
        f for f in os.listdir(agents_dir) if f.endswith('.md')
    )

    if not md_files:
        errors.append("agents/ 目錄中沒有 .md 檔案")
        return errors

    for filename in md_files:
        agent_name = filename[:-3]  # 去掉 .md
        filepath = os.path.join(agents_dir, filename)

        with open(filepath, encoding='utf-8') as f:
            content = f.read()

        fm = parse_frontmatter(content)
        if fm is None:
            errors.append(f"{filename}: 缺少 YAML frontmatter（---...---）")
            continue

        # AC2: frontmatter 包含 name, description, model
        if not fm.get('name'):
            errors.append(f"{filename}: frontmatter 缺少 'name' 欄位")

        # AC4: description 欄位存在且非空
        if not fm.get('description'):
            errors.append(f"{filename}: frontmatter 缺少 'description' 欄位")

        # AC3: model 值為合法值
        model = fm.get('model')
        if not model:
            errors.append(f"{filename}: frontmatter 缺少 'model' 欄位")
        elif model not in VALID_MODELS:
            errors.append(
                f"{filename}: model '{model}' 不合法，"
                f"合法值為 {sorted(VALID_MODELS)}"
            )

    return errors


def main():
    errors = test_agents()
    if errors:
        print("FAIL — Agent 完整性驗證失敗：\n")
        for e in errors:
            print(f"  ✗ {e}")
        print(f"\n共 {len(errors)} 個錯誤")
        sys.exit(1)
    else:
        agents_dir = os.path.normpath(AGENTS_DIR)
        agent_count = len([
            f for f in os.listdir(agents_dir) if f.endswith('.md')
        ])
        print(f"PASS — {agent_count} 個 Agents 全部通過完整性驗證")
        sys.exit(0)


if __name__ == '__main__':
    main()
