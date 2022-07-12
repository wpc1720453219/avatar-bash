#!/usr/bin/env bash
# 说明：
# 停止skywalking

set -e

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh
export tfpPath="${env_tfpPath}"
stop_process_arg=$1

export skywalkingBinPath=$tfpPath/software/skywalking/apache-skywalking-apm-bin

stop_process $stop_process_arg $skywalkingBinPath/webapp/skywalking-webapp.jar
stop_process $stop_process_arg $skywalkingBinPath/oap-libs/

echo 'skywalking关闭成功'
