#!/usr/bin/env bash
# 说明：
#

set -e

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh
export tfpPath="${env_tfpPath}"
export baseUrl="${env_baseUrl}"

# 必需的参数
myid=$1
if [ -z $myid ]; then
  echo "必需输入zookeeper集群的节点id号，比如：./zookeeper_cluster-stop.sh 1"
  exit 1
fi

export zookeeperBinPath=$tfpPath/software/zookeeper_cluster_${myid}/zookeeper-3.4.14/bin

cd $zookeeperBinPath
$zookeeperBinPath/zkServer.sh stop

echo "zookeeper集群节点${myid}关闭成功"
