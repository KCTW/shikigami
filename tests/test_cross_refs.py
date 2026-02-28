"""US-T05: 交叉引用驗證

驗證所有 .md 中的 shikigami:xxx 引用都指向存在的 skill。
"""

import os
import re
import sys

ROOT_DIR = os.path.join(os.path.dirname(__file__), '..')
SKILLS_DIR = os.path.join(ROOT_DIR, 'skills')

# 匹配 shikigami:skill-name 格式的引用
REF_PATTERN = re.compile(r'shikigami:([a-z][a-z0-9-]*)')


def get_existing_skills():
    """取得所有存在的 skill 目錄名稱。"""
    skills_dir = os.path.normpath(SKILLS_DIR)
    if not os.path.isdir(skills_dir):
        return set()
    return {
        d for d in os.listdir(skills_dir)
        if os.path.isdir(os.path.join(skills_dir, d))
    }


def scan_references(root_dir):
    """掃描所有 .md 檔案中的 shikigami:xxx 引用。"""
    references = []
    root = os.path.normpath(root_dir)

    for dirpath, dirnames, filenames in os.walk(root):
        # 跳過隱藏目錄和 node_modules
        dirnames[:] = [
            d for d in dirnames
            if not d.startswith('.') and d != 'node_modules'
        ]

        for filename in filenames:
            if not filename.endswith('.md'):
                continue

            filepath = os.path.join(dirpath, filename)
            rel_path = os.path.relpath(filepath, root)

            with open(filepath, encoding='utf-8') as f:
                for line_no, line in enumerate(f, 1):
                    for match in REF_PATTERN.finditer(line):
                        references.append({
                            'file': rel_path,
                            'line': line_no,
                            'ref': match.group(1),
                        })

    return references


def test_cross_refs():
    errors = []
    root_dir = os.path.normpath(ROOT_DIR)
    existing_skills = get_existing_skills()

    if not existing_skills:
        errors.append("skills/ 目錄不存在或為空")
        return errors

    references = scan_references(root_dir)

    if not references:
        errors.append("未找到任何 shikigami:xxx 引用（可能是掃描範圍問題）")
        return errors

    # AC2: 驗證對應的 skills/<name>/SKILL.md 存在
    broken = []
    for ref in references:
        skill_name = ref['ref']
        skill_md = os.path.join(
            os.path.normpath(SKILLS_DIR), skill_name, 'SKILL.md'
        )
        if not os.path.isfile(skill_md):
            broken.append(ref)

    # AC3: 產出斷掉的引用報告
    for b in broken:
        errors.append(
            f"{b['file']}:{b['line']}: "
            f"shikigami:{b['ref']} 指向不存在的 skill"
        )

    return errors


def main():
    errors = test_cross_refs()
    if errors:
        print("FAIL — 交叉引用驗證失敗：\n")
        for e in errors:
            print(f"  ✗ {e}")
        print(f"\n共 {len(errors)} 個錯誤")
        sys.exit(1)
    else:
        root_dir = os.path.normpath(ROOT_DIR)
        refs = scan_references(root_dir)
        print(f"PASS — {len(refs)} 個交叉引用全部指向存在的 skill")
        sys.exit(0)


if __name__ == '__main__':
    main()
