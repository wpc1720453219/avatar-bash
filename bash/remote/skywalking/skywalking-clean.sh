#!/usr/bin/env bash
set -e

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh
export tfpPath="${env_tfpPath}"

# 见文件夹
export skywalkingPath=$tfpPath/software/skywalking
rm -rf $skywalkingPath

echo 'skywalking清理成功'
