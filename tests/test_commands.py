"""US-T06: Command 路由驗證

驗證每個 command 正確引用存在的 skill，且 frontmatter 包含 description。
"""

import os
import re
import sys

import yaml

COMMANDS_DIR = os.path.join(os.path.dirname(__file__), '..', 'commands')
SKILLS_DIR = os.path.join(os.path.dirname(__file__), '..', 'skills')

REF_PATTERN = re.compile(r'shikigami:([a-z][a-z0-9-]*)')


def parse_frontmatter(content):
    """從 Markdown 內容中解析 YAML frontmatter。"""
    match = re.match(r'^---\n(.*?)\n---', content, re.DOTALL)
    if not match:
        return None
    return yaml.safe_load(match.group(1))


def test_commands():
    errors = []
    commands_dir = os.path.normpath(COMMANDS_DIR)
    skills_dir = os.path.normpath(SKILLS_DIR)

    if not os.path.isdir(commands_dir):
        errors.append(f"commands/ 目錄不存在: {commands_dir}")
        return errors

    # AC1: 掃描 commands/ 下所有 .md 檔案
    md_files = sorted(
        f for f in os.listdir(commands_dir) if f.endswith('.md')
    )

    if not md_files:
        errors.append("commands/ 目錄中沒有 .md 檔案")
        return errors

    for filename in md_files:
        filepath = os.path.join(commands_dir, filename)

        with open(filepath, encoding='utf-8') as f:
            content = f.read()

        # AC3: frontmatter 包含 description 欄位
        fm = parse_frontmatter(content)
        if fm is None:
            errors.append(f"{filename}: 缺少 YAML frontmatter（---...---）")
            continue

        if not fm.get('description'):
            errors.append(f"{filename}: frontmatter 缺少 'description' 欄位")

        # AC2: 驗證引用的 shikigami:xxx skill 存在
        refs = REF_PATTERN.findall(content)
        for ref_name in refs:
            skill_md = os.path.join(skills_dir, ref_name, 'SKILL.md')
            if not os.path.isfile(skill_md):
                errors.append(
                    f"{filename}: 引用 shikigami:{ref_name} "
                    f"但 skills/{ref_name}/SKILL.md 不存在"
                )

    return errors


def main():
    errors = test_commands()
    if errors:
        print("FAIL — Command 路由驗證失敗：\n")
        for e in errors:
            print(f"  ✗ {e}")
        print(f"\n共 {len(errors)} 個錯誤")
        sys.exit(1)
    else:
        commands_dir = os.path.normpath(COMMANDS_DIR)
        cmd_count = len([
            f for f in os.listdir(commands_dir) if f.endswith('.md')
        ])
        print(f"PASS — {cmd_count} 個 Commands 全部通過路由驗證")
        sys.exit(0)


if __name__ == '__main__':
    main()
