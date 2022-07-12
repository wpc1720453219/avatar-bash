#!/usr/bin/env bash
set -e

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh
export tfpPath="${env_tfpPath}"
export elasticsearch_host="${env_elasticsearch_host}"
export elasticsearch_port="${env_elasticsearch_port}"
export skywalking_grpc_port="${env_skywalking_grpc_port}"
export skywalking_rest_port="${env_skywalking_rest_port}"
export skywalking_webapp_port="${env_skywalking_webapp_port}"
export env_skywalking_host="${env_skywalking_host}"

# 设置环境变量，skywalking可以通过环境变量覆盖配置
## 后台配置，走 skywalking oap 的覆盖配置
export SW_NAMESPACE=skywalking
export SW_STORAGE_ES_CLUSTER_NODES=$elasticsearch_host:$elasticsearch_port
export SW_CORE_REST_PORT=$skywalking_rest_port
export SW_CORE_GRPC_PORT=$skywalking_grpc_port
## 前端配置，走 spring boot 的覆盖配置
export SERVER_PORT=$skywalking_webapp_port
export COLLECTOR_RIBBON_LISTOFSERVERS="127.0.0.1:$SW_CORE_REST_PORT"

# 起skywalking
skywalkingBinPath=$tfpPath/software/skywalking/apache-skywalking-apm-bin/bin/
cd $skywalkingBinPath
$skywalkingBinPath/startup.sh


checkServerAlive http://$env_skywalking_host:$skywalking_webapp_port
rc=$?
if [[ $rc != 0 ]];
then
  echo "Skywalking 前端在 $rc 秒内启动失败!"
  exit 1;
fi
checkServerAlive http://$env_skywalking_host:$skywalking_rest_port
rc=$?
if [[ $rc != 0 ]];
then
  echo "Skywalking 后台在 $rc 秒内启动失败!"
  exit 1;
fi

echo 'skywalking启动成功'
