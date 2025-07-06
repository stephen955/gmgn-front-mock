#!/bin/bash

# 真机运行脚本
echo "=== GMGN Front 真机运行配置 ==="

# 获取本机IP地址
LOCAL_IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -n 1)
echo "检测到本机IP地址: $LOCAL_IP"

# 更新配置文件中的IP地址
echo "更新配置文件中的IP地址..."
sed -i '' "s/http:\/\/192\.168\.1\.100:3000/http:\/\/$LOCAL_IP:3000/g" lib/core/config/app_config.dart

echo "配置文件已更新为: http://$LOCAL_IP:3000"

# 检查Flutter环境
echo "检查Flutter环境..."
flutter doctor

# 获取连接的设备
echo "获取连接的设备..."
flutter devices

echo ""
echo "=== 运行步骤 ==="
echo "1. 确保你的手机和电脑在同一个WiFi网络下"
echo "2. 在手机上启用开发者选项和USB调试"
echo "3. 用USB线连接手机到电脑"
echo "4. 运行以下命令启动应用："
echo "   flutter run"
echo ""
echo "如果遇到网络问题，请确保："
echo "- 手机和电脑在同一网络"
echo "- 防火墙允许3000端口访问"
echo "- Mock服务器正在运行在 $LOCAL_IP:3000" 