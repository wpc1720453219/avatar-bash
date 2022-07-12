#!/usr/bin/env bash
# 说明：
# 停止skywalking

set -e

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh
export tfpPath="${env_tfpPath}"

# kill参数
stop_process_arg=$1

stop_process $stop_process_arg $tfpPath/software/elasticsearch/elasticsearch-6.4.2/lib

echo 'elasticsearch关闭成功'
