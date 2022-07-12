#!/usr/bin/env bash
# 说明：
#
set -e

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh
export tfpPath="${env_tfpPath}"
export baseUrl="${env_baseUrl}"
env_app_names="${env_app_names}"
env_app_env="${env_app_env}"
env_app_log_path="${env_app_log_path}"
env_skywalking_grpc_port="${env_skywalking_grpc_port}"
env_skywalking_host="${env_skywalking_host}"
env_apollo_host="${env_apollo_host}"
env_app_jvm_opts="${env_app_jvm_opts}"

# 读参数 - 应用名
app_name=$1
if [ -z "$app_name" ]; then
  echo "请输入以下应用名中的一个："
  echo $env_app_names
  echo "示例：tomcat-start.sh usercore"
  exit 1
fi

# 应用jar路径
export appPath=$tfpPath/tomcat/$app_name
cd $appPath

# jvm参数，设置内存大小等
eval jvm_opts=\$env_app_jvm_opts_$app_name
if [ -z "$jvm_opts" ]; then
  echo "没有设置${app_name}的jvm参数env_app_jvm_opts_$app_name，将使用默认值：$env_app_jvm_opts"
  jvm_opts=$env_app_jvm_opts
fi

# 判断skywalking
skywalking_opts=""
skywalkingAgentPath=$tfpPath/software/skywalking/skywalking-agent-6.3.0
skywalkingAgentJar=$skywalkingAgentPath/skywalking-agent.jar

if [[ $app_name == 'dubbo_monitor' || $app_name == "dubbo_admin" ]]; then
  echo "正在启动${app_name}，不需要skywalking探针"
elif [ -f $skywalkingAgentJar ]; then
  skywalking_opts="$skywalking_opts \
      -javaagent:$skywalkingAgentJar \
      -Dskywalking.agent.namespace=tfp \
      -Dskywalking.agent.service_name=tfp-$app_name \
      -Dskywalking.agent.span_limit_per_segment=30000 \
      -Dskywalking.collector.backend_service=$env_skywalking_host:$env_skywalking_grpc_port \
      -Dskywalking.logging.file_name=skywalking-agent-$app_name.log \
      -Dskywalking.logging.level=INFO \
      -Dskywalking.agent.ignore_suffix='com.alibaba.dubbo.monitor.MonitorService.collect(URL),.jpg,.jpeg,.js,.css,.png,.bmp,.gif,.ico,.mp3,.mp4,.html,.svg'"
else
  echo "skywalking探针不存在：$skywalkingAgentJar"
fi


# 组装启动参数
export CATALINA_OPTS="$jvm_opts $skywalking_opts"

# 检查java
checkJava
$appPath/apache-tomcat-8.5.46/bin/startup.sh
eval app_tomcat_http_port=\$\{env_app_tomcat_ports_$app_name[1]\}
checkServerAlive http://localhost:$app_tomcat_http_port

echo "应用${app_name}启动成功"

