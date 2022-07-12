#!/usr/bin/env bash
# 说明：
# nginx安装，但不进行配置

set -e

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh

set -x

# 建文件夹
export nginxPath=$env_tfpPath/software/nginx
mkdir -p $nginxPath
cd $nginxPath
pwd

# 必须组件，想办法装上去
linux_commands_verify zypper
sudo zypper -n install pcre pcre-devel

# 下载解压
wget -q -c $env_baseUrl/software/nginx/nginx-1.16.1.tar.gz
tar -zxf nginx-1.16.1.tar.gz
mkdir -p $nginxPath/bin
# 编译
cd $nginxPath/nginx-1.16.1
./configure \
  --prefix=$nginxPath/bin \
  --with-http_ssl_module
make
make install

echo "nginx安装成功"
