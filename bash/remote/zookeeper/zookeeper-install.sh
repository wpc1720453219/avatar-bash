#!/usr/bin/env bash
# 说明：
#

set -e

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh
export tfpPath="${env_tfpPath}"
export baseUrl="${env_baseUrl}"
export zookeeper_port="${env_zookeeper_port}"

# 建文件夹
export zookeeperPath=$tfpPath/software/zookeeper
mkdir -p $zookeeperPath
cd $zookeeperPath

# 下载解压
wget -q -c $baseUrl/software/zookeeper/zookeeper-3.4.14.tar.gz
tar -zxf zookeeper-3.4.14.tar.gz
export zookeeperSoftwarePath=$zookeeperPath/zookeeper-3.4.14

# 改配置
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
EOF

echo "zookeeper安装成功"
