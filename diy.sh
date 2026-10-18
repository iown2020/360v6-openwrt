#!/bin/bash
# 360V6 自定义构建脚本

# 1. 设置默认管理 IP 为 192.168.2.1
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# 2. 赋予 uci-defaults 脚本执行权限
chmod +x files/etc/uci-defaults/* 2>/dev/null || true
