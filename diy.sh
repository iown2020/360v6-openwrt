#!/bin/bash
# 360V6 自定义构建脚本

# 1. 设置默认管理 IP 为 192.168.50.1
TARGET_FILE="package/base-files/files/bin/config_generate"
[ ! -f "$TARGET_FILE" ] && TARGET_FILE="openwrt/package/base-files/files/bin/config_generate"
if [ -f "$TARGET_FILE" ]; then
    sed -i 's/192.168.1.1/192.168.50.1/g' "$TARGET_FILE"
fi

# 2. 赋予 uci-defaults 脚本执行权限
chmod +x files/etc/uci-defaults/* 2>/dev/null || true
chmod +x openwrt/files/etc/uci-defaults/* 2>/dev/null || true

