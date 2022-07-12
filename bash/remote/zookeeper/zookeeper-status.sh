#!/usr/bin/env bash
# 说明：
#

set -e

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh
export tfpPath="${env_tfpPath}"
export baseUrl="${env_baseUrl}"

export zookeeperBinPath=$tfpPath/software/zookeeper/zookeeper-3.4.14/bin

cd $zookeeperBinPath
$zookeeperBinPath/zkServer.sh status

echo "zookeeper状态查询成功"
