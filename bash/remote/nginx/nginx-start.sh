#!/usr/bin/env bash
# 说明：
# nginx安装，但不进行配置

set -e

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh

# 建文件夹
export nginxPath=$env_tfpPath/software/nginx
mkdir -p $nginxPath
cd $nginxPath
pwd

cd $nginxPath/bin/sbin
$nginxPath/bin/sbin/nginx

echo "nginx启动成功"
