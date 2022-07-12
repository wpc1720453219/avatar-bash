#!/usr/bin/env bash
# 说明：
#

set -xe

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh
export tfpPath="${env_tfpPath}"
export baseUrl="${env_baseUrl}"

# 读参数
cluster_type=$1

if [ -z $cluster_type ]; then
  echo "必需输入redis哨兵集群的节点类型，比如：master、slave、sentinel_1、sentinel_2、sentinel_3"
  exit 1
fi

# 建文件夹
export redisPath=$tfpPath/software/redis_sentinel/${cluster_type}
mkdir -p $redisPath
cd $redisPath

# 下载解压
rm -rf $redisPath/redis-4.0.14-suse12.tar.gz
rm -rf $redisPath/redis-4.0.14-suse12
wget -q -c $baseUrl/software/redis/redis-4.0.14-suse12.tar.gz
tar -zxvf redis-4.0.14-suse12.tar.gz
export redisSoftwarePath=$redisPath/redis-4.0.14-suse12

# 写配置文件
resolve_app_host redis_master
eval redis_port=\$env_redis_${cluster_type}_port

if [ $cluster_type == "slave" ]; then
  sed -i "s/# slaveof <masterip> <masterport>/slaveof ${env_redis_master_host} ${env_redis_master_port}/g" $redisPath/redis-4.0.14-suse12/redis.conf
fi

# 哨兵配置
if [[ $cluster_type != "master" && $cluster_type != "slave" ]]; then
  sed -i "s/port 26379/port $redis_port/g" $redisPath/redis-4.0.14-suse12/sentinel.conf
  sed -i "s/sentinel monitor mymaster 127.0.0.1 6379 2/sentinel monitor mymaster ${env_redis_master_host} ${env_redis_master_port} 2/g" $redisPath/redis-4.0.14-suse12/sentinel.conf
  if [ -n "$redis_password" ]; then
    sed -i "s/# sentinel auth-pass mymaster MySUPER--secret-0123passw0rd/sentinel auth-pass mymaster $redis_password/g" $redisPath/redis-4.0.14-suse12/sentinel.conf
  fi
fi


echo "redis集群哨兵模式节点${cluster_type}安装成功"
