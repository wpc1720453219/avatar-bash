#!/usr/bin/env bash
set -e

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh
export tfpPath="${env_tfpPath}"
export env_elasticsearch_host="${env_elasticsearch_host}"
export env_elasticsearch_port="${env_elasticsearch_port}"
export elasticsearchBinPath=$tfpPath/software/elasticsearch/elasticsearch-6.4.2/bin

# 切换用户
# 省的其他地址没elasticsearch用户的写权限
cd $elasticsearchBinPath
# 后台启动
nohup $elasticsearchBinPath/elasticsearch >> $elasticsearchBinPath/elasticsearch.out 2>&1 &

checkServerAlive http://$env_elasticsearch_host:$env_elasticsearch_port
rc=$?
if [[ $rc != 0 ]];
then
  echo "Elasticsearch 在 $rc 秒内启动失败!"
  exit 1;
fi

echo 'elasticsearch启动成功'
