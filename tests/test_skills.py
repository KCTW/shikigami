"""US-T01: Skill 完整性驗證

驗證每個 skill 目錄都有合法的 SKILL.md，包含正確的 frontmatter。
"""

import os
import re
import sys

import yaml

SKILLS_DIR = os.path.join(os.path.dirname(__file__), '..', 'skills')


def parse_frontmatter(content):
    """從 Markdown 內容中解析 YAML frontmatter。"""
    match = re.match(r'^---\n(.*?)\n---', content, re.DOTALL)
    if not match:
        return None
    return yaml.safe_load(match.group(1))


def test_skills():
    errors = []
    skills_dir = os.path.normpath(SKILLS_DIR)

    if not os.path.isdir(skills_dir):
        errors.append(f"skills/ 目錄不存在: {skills_dir}")
        return errors

    entries = sorted(os.listdir(skills_dir))
    if not entries:
        errors.append("skills/ 目錄為空")
        return errors

    for skill_name in entries:
        skill_path = os.path.join(skills_dir, skill_name)
        if not os.path.isdir(skill_path):
            continue

        skill_md = os.path.join(skill_path, 'SKILL.md')

        # AC1 + AC4: 每個子目錄必須有 SKILL.md
        if not os.path.isfile(skill_md):
            errors.append(f"{skill_name}: SKILL.md 不存在（空目錄）")
            continue

        with open(skill_md, encoding='utf-8') as f:
            content = f.read()

        # AC2: frontmatter 必須存在且包含 name 和 description
        fm = parse_frontmatter(content)
        if fm is None:
            errors.append(f"{skill_name}: 缺少 YAML frontmatter（---...---）")
            continue

        if not fm.get('name'):
            errors.append(f"{skill_name}: frontmatter 缺少 'name' 欄位")

        if not fm.get('description'):
            errors.append(f"{skill_name}: frontmatter 缺少 'description' 欄位")

        # AC3: name 值必須與目錄名稱一致
        if fm.get('name') and fm['name'] != skill_name:
            errors.append(
                f"{skill_name}: frontmatter name '{fm['name']}' "
                f"與目錄名稱 '{skill_name}' 不一致"
            )

    return errors


def main():
    errors = test_skills()
    if errors:
        print("FAIL — Skill 完整性驗證失敗：\n")
        for e in errors:
            print(f"  ✗ {e}")
        print(f"\n共 {len(errors)} 個錯誤")
        sys.exit(1)
    else:
        skill_count = len([
            d for d in os.listdir(os.path.normpath(SKILLS_DIR))
            if os.path.isdir(os.path.join(os.path.normpath(SKILLS_DIR), d))
        ])
        print(f"PASS — {skill_count} 個 Skills 全部通過完整性驗證")
        sys.exit(0)


if __name__ == '__main__':
    main()
