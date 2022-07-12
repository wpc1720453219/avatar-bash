#!/usr/bin/env bash
set -e

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh

export baseUrl="${env_baseUrl}"
export tfpPath="${env_tfpPath}"

# 建文件夹
export jdkPath=$tfpPath/software/jdk
mkdir -p $jdkPath
cd $jdkPath
pwd

# wget 下载包
wget -q -c $baseUrl/software/jdk/jdk-8u181-linux-x64.tar.gz

# 解压压缩包
tar -zxf jdk-8u181-linux-x64.tar.gz

