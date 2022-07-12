#!/usr/bin/env bash
# 说明：
#

set -e

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh
export tfpPath="${env_tfpPath}"
export baseUrl="${env_baseUrl}"

# 建文件夹
export redisPath=$tfpPath/software/redis
mkdir -p $redisPath
cd $redisPath

# 下载解压
rm -rf $redisPath/redis-4.0.14-suse12.tar.gz
rm -rf $redisPath/redis-4.0.14-suse12
wget -q -c $baseUrl/software/redis/redis-4.0.14-suse12.tar.gz
tar -zxvf redis-4.0.14-suse12.tar.gz
export redisSoftwarePath=$redisPath/redis-4.0.14-suse12

echo "redis安装成功"
