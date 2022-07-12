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

# 读参数 - 应用名
app_name=$1
if [ -z "$app_name" ]; then
  echo "请输入以下应用名中的一个："
  echo $env_app_names
  echo "示例："
  echo "关闭usercore：tomcat-stop.sh usercore"
  echo "强行关闭usercore：tomcat-stop.sh usercore -9"
  echo "关闭所有应用：tomcat-stop.sh all"
  echo "强行关闭所有应用：tomcat-stop.sh all -9"
  exit 1
fi
# kill参数
stop_process_arg=$2

if [ "all" = $app_name ]; then
  stop_process "$stop_process_arg" $tfpPath/tomcat
else
  # 应用tomcat路径
  appPath=$tfpPath/tomcat/$app_name
  cd $appPath
  # 关闭
  stop_process "$stop_process_arg" $appPath/apache-tomcat-8.5.46
fi

echo "${app_name}关闭成功"
