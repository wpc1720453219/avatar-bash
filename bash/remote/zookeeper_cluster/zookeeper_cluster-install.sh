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
  echo "必需输入zookeeper集群的节点id号，比如：./zookeeper_cluster-install.sh 1"
  exit 1
fi

# 建文件夹
export zookeeperPath=$tfpPath/software/zookeeper_cluster_${myid}
mkdir -p $zookeeperPath
cd $zookeeperPath

# 下载解压
wget -q -c $baseUrl/software/zookeeper/zookeeper-3.4.14.tar.gz
tar -zxf zookeeper-3.4.14.tar.gz
export zookeeperSoftwarePath=$zookeeperPath/zookeeper-3.4.14


# 改配置
mkdir -p $zookeeperSoftwarePath/dataLog
mkdir -p $zookeeperSoftwarePath/data
echo $myid > $zookeeperSoftwarePath/data/myid
resolve_app_host zookeeper_cluster_1
resolve_app_host zookeeper_cluster_2
resolve_app_host zookeeper_cluster_3
eval zookeeper_port=\${env_zookeeper_cluster_${myid}_ports[0]}
cat << EOF > $zookeeperSoftwarePath/conf/zoo.cfg
tickTime=2000
initLimit=10
syncLimit=5
maxClientCnxns=10000
dataDir=$zookeeperSoftwarePath/data
dataLogDir=$zookeeperSoftwarePath/dataLog
clientPort=$zookeeper_port
autopurge.snapRetainCount=3
autopurge.purgeInterval=1

server.1=${env_zookeeper_cluster_1_host}:${env_zookeeper_cluster_1_ports[1]}:${env_zookeeper_cluster_1_ports[2]}
server.2=${env_zookeeper_cluster_2_host}:${env_zookeeper_cluster_2_ports[1]}:${env_zookeeper_cluster_2_ports[2]}
server.3=${env_zookeeper_cluster_3_host}:${env_zookeeper_cluster_3_ports[1]}:${env_zookeeper_cluster_3_ports[2]}
EOF

echo "zookeeper集群节点${myid}安装成功"
