#!/usr/bin/env bash

# 必需
yum install -y wget zip unzip net-tools gcc ntp

# 非必需，但方便命令行操作
yum install -y vim bash-completion

# 设置时区
timedatectl set-timezone Asia/Shanghai
