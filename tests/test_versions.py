"""US-T04: 版號一致性驗證

驗證 plugin.json 和 marketplace.json 的版號一致，
並可選驗證 git tag。
"""

import json
import os
import subprocess
import sys

PLUGIN_DIR = os.path.join(os.path.dirname(__file__), '..', '.claude-plugin')
ROOT_DIR = os.path.join(os.path.dirname(__file__), '..')


def test_versions():
    errors = []
    plugin_dir = os.path.normpath(PLUGIN_DIR)

    # 讀取 plugin.json version
    plugin_json_path = os.path.join(plugin_dir, 'plugin.json')
    marketplace_json_path = os.path.join(plugin_dir, 'marketplace.json')

    if not os.path.isfile(plugin_json_path):
        errors.append("plugin.json 不存在，無法驗證版號")
        return errors

    if not os.path.isfile(marketplace_json_path):
        errors.append("marketplace.json 不存在，無法驗證版號")
        return errors

    with open(plugin_json_path, encoding='utf-8') as f:
        plugin = json.load(f)

    with open(marketplace_json_path, encoding='utf-8') as f:
        marketplace = json.load(f)

    plugin_version = plugin.get('version')
    if not plugin_version:
        errors.append("plugin.json 缺少 version 欄位")
        return errors

    # AC1: plugin.json 和 marketplace.json 的 version 必須相同
    marketplace_plugins = marketplace.get('plugins', [])
    if marketplace_plugins:
        mp_version = marketplace_plugins[0].get('version')
        if mp_version != plugin_version:
            errors.append(
                f"版號不一致：plugin.json='{plugin_version}', "
                f"marketplace.json='{mp_version}'"
            )

    # AC2 + AC3: 若存在 git tag，最新 tag 版號必須與 plugin.json 一致
    # 不強制要求有 git tag（0.x.x 開發期可豁免）
    try:
        result = subprocess.run(
            ['git', 'tag', '--sort=-v:refname'],
            capture_output=True, text=True,
            cwd=os.path.normpath(ROOT_DIR)
        )
        tags = result.stdout.strip().split('\n')
        tags = [t for t in tags if t]  # 過濾空行

        if tags:
            latest_tag = tags[0]
            tag_version = latest_tag.lstrip('v')
            if tag_version != plugin_version:
                errors.append(
                    f"最新 git tag '{latest_tag}' 的版號 '{tag_version}' "
                    f"與 plugin.json version '{plugin_version}' 不一致"
                )
    except FileNotFoundError:
        pass  # git 不可用，跳過 tag 檢查

    return errors


def main():
    errors = test_versions()
    if errors:
        print("FAIL — 版號一致性驗證失敗：\n")
        for e in errors:
            print(f"  ✗ {e}")
        print(f"\n共 {len(errors)} 個錯誤")
        sys.exit(1)
    else:
        print("PASS — 版號一致性驗證通過")
        sys.exit(0)


if __name__ == '__main__':
    main()
