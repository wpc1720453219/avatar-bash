#!/usr/bin/env bash
# 说明：
#

set -e

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh
export tfpPath="${env_tfpPath}"
export redis_password="${env_redis_password}"

# 读参数
cluster_type=$1

if [ -z $cluster_type ]; then
  echo "必需输入redis哨兵集群的节点类型，比如：master、slave、sentinel_1、sentinel_2、sentinel_3"
  exit 1
fi

# 建文件夹
export redisPath=$tfpPath/software/redis_sentinel/${cluster_type}
export redisSoftwarePath=$redisPath/redis-4.0.14-suse12
eval redis_port=\$env_redis_${cluster_type}_port
export redisInstancePath=$redisSoftwarePath/redis_$redis_port
mkdir -p $redisInstancePath

redis_password_arg=""
if [ -n "$redis_password" ]; then
    redis_password_arg="--requirepass $redis_password --masterauth $redis_password"
fi

cd $redisInstancePath


if [[ $cluster_type == "master" || $cluster_type == "slave" ]]; then
  $redisSoftwarePath/redis-server $redisSoftwarePath/redis.conf \
    --logfile $redisInstancePath/redis.log \
    --pidfile /var/run/redis_${redis_port}.pid \
    --port $redis_port \
    --dir $redisInstancePath/ \
    $redis_password_arg
else
  resolve_app_host redis_master
  $redisSoftwarePath/redis-sentinel $redisSoftwarePath/sentinel.conf \
    --logfile $redisInstancePath/sentinel.log \
    --pidfile /var/run/redis_${redis_port}.pid \
    --daemonize yes \
    --protected-mode no \
    --port $redis_port \
    --dir $redisInstancePath
fi

echo "redis集群哨兵模式节点${cluster_type}启动成功"
