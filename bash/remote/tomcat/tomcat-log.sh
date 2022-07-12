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

# 读参数 - 应用名
app_name=$1
if [ -z "$app_name" ]; then
  echo "请输入以下应用名中的一个："
  echo $env_app_names
  echo "示例：fg-app-log.sh usercore"
  exit 1
fi

# 应用jar路径
export appPath=$tfpPath/tomcat/$app_name
cd $appPath


log_out_path=$appPath/$app_name.out

echo "应用${app_name}控制台log：$log_out_path"

tail -f $log_out_path
