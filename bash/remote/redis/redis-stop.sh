#!/usr/bin/env bash
# 说明：
#

set -e

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh
export tfpPath="${env_tfpPath}"
export redis_port="${env_redis_port}"
export redis_password="${env_redis_password}"

export redisSoftwarePath=$tfpPath/software/redis/redis-4.0.14-suse12
export redisInstancePath=$redisSoftwarePath/redis_$redis_port
mkdir -p $redisInstancePath

cd $redisInstancePath
redis_password_clause=""
if [ -n "$redis_password" ]; then
  redis_password_clause="-a $redis_password"
fi
$redisSoftwarePath/redis-cli -p $redis_port $redis_password_clause shutdown

echo "redis关闭成功"
