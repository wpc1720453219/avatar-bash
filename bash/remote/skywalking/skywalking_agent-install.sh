#!/usr/bin/env bash
set -e

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh
export baseUrl="${env_baseUrl}"
export tfpPath="${env_tfpPath}"

set -x

# 建文件夹
export skywalkingPath=$tfpPath/software/skywalking
mkdir -p $skywalkingPath
cd $skywalkingPath
pwd

# wget 下载包
rm -rf skywalking-agent-6.3.0.tar.gz
wget -c -O skywalking-agent-6.3.0.tar.gz $baseUrl/software/skywalking/skywalking-agent-6.3.0.tar.gz
tar -zxf skywalking-agent-6.3.0.tar.gz

echo 'skywalking_agent安装成功'
