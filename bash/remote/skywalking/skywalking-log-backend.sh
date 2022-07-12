#!/usr/bin/env bash
set -e

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh
export tfpPath="${env_tfpPath}"

# 建文件夹
export skywalkingPath=$tfpPath/software/skywalking
cd $skywalkingPath
pwd

tail -f apache-skywalking-apm-bin/logs/skywalking-oap-server.log
