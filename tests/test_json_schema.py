"""US-T03: JSON Schema 驗證

驗證 plugin.json 和 marketplace.json 包含必填欄位且格式正確。
"""

import json
import os
import re
import sys

PLUGIN_DIR = os.path.join(os.path.dirname(__file__), '..', '.claude-plugin')

SEMVER_PATTERN = re.compile(
    r'^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)'
    r'(-[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?'
    r'(\+[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?$'
)


def test_json_schema():
    errors = []
    plugin_dir = os.path.normpath(PLUGIN_DIR)

    # --- plugin.json ---
    plugin_json_path = os.path.join(plugin_dir, 'plugin.json')
    if not os.path.isfile(plugin_json_path):
        errors.append("plugin.json 不存在")
    else:
        with open(plugin_json_path, encoding='utf-8') as f:
            try:
                plugin = json.load(f)
            except json.JSONDecodeError as e:
                errors.append(f"plugin.json JSON 解析失敗: {e}")
                plugin = None

        if plugin is not None:
            # AC1: 必填欄位
            for field in ('name', 'version', 'description', 'author'):
                if field not in plugin:
                    errors.append(
                        f"plugin.json 缺少必填欄位 '{field}'"
                    )

            # AC3: version 格式符合 semver
            version = plugin.get('version', '')
            if version and not SEMVER_PATTERN.match(version):
                errors.append(
                    f"plugin.json version '{version}' 不符合 semver 格式"
                )

    # --- marketplace.json ---
    marketplace_json_path = os.path.join(plugin_dir, 'marketplace.json')
    if not os.path.isfile(marketplace_json_path):
        errors.append("marketplace.json 不存在")
    else:
        with open(marketplace_json_path, encoding='utf-8') as f:
            try:
                marketplace = json.load(f)
            except json.JSONDecodeError as e:
                errors.append(f"marketplace.json JSON 解析失敗: {e}")
                marketplace = None

        if marketplace is not None:
            # AC2: 必填欄位
            if 'name' not in marketplace:
                errors.append(
                    "marketplace.json 缺少必填欄位 'name'"
                )

            if 'plugins' not in marketplace:
                errors.append(
                    "marketplace.json 缺少必填欄位 'plugins'"
                )
            elif not isinstance(marketplace['plugins'], list):
                errors.append(
                    "marketplace.json 'plugins' 必須是陣列"
                )

    return errors


def main():
    errors = test_json_schema()
    if errors:
        print("FAIL — JSON Schema 驗證失敗：\n")
        for e in errors:
            print(f"  ✗ {e}")
        print(f"\n共 {len(errors)} 個錯誤")
        sys.exit(1)
    else:
        print("PASS — plugin.json 和 marketplace.json 全部通過 Schema 驗證")
        sys.exit(0)


if __name__ == '__main__':
    main()
