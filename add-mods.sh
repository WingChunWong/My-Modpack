#!/bin/bash
# Packwiz模组批量导入脚本
# 从 1.21.11.txt 读取Project ID并添加模组
# 游戏版本: 1.21.11

set -e

MODLIST="1.21.11.txt"

echo "=== Packwiz模组导入 ==="
echo "游戏版本: 1.21.11 + Fabric"
echo ""

# 统计总数
TOTAL=$(grep -c "modrinth.com/mod" "$MODLIST" || echo 0)
echo "待导入模组数: $TOTAL"
echo ""

# 需要手动指定的Project ID（列表格式不标准）
MANUAL_IDS="modernfix-mvus modernui-mc-mvus"

count=0
failed=0

# 从列表提取并添加
while IFS= read -r line; do
    # 提取Project ID: https://modrinth.com/mod/{ID}
    project_id=$(echo "$line" | sed -n 's/.*modrinth\.com\/mod\/\([^ )]*\).*/\1/p' | tr -d ')' | grep -v "^$" || true)

    if [ -n "$project_id" ]; then
        count=$((count + 1))
        echo "[$count/$TOTAL] $project_id"

        packwiz modrinth add --project-id "$project_id" -y || {
            failed=$((failed + 1))
            echo "  ⚠️ 失败"
        }
    fi
done < "$MODLIST"

# 手动添加指定ID
echo ""
echo "=== 手动指定模组 ==="
for id in $MANUAL_IDS; do
    count=$((count + 1))
    echo "[手动] $id"
    packwiz modrinth add --project-id "$id" -y || {
        failed=$((failed + 1))
        echo "  ⚠️ 失败"
    }
done

echo ""
echo "=== 导入完成 ==="
echo "成功: $((count - failed))"
echo "失败: $failed"

# 刷新索引
packwiz refresh
echo "索引已刷新"