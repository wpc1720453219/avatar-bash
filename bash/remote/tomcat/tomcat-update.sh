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

# 读参数
app_name=$1
if [ -z "$app_name" ]; then
  echo "请输入以下应用名中的一个："
  echo $env_app_names
  echo "示例：tomcat-install.sh usercore"
  exit 1
fi

# 建文件夹
export appPath=$tfpPath/tomcat/$app_name
mkdir -p $appPath
cd $appPath
eval app_war_name=\$env_app_name_$app_name

# 下载应用war包
cd $appPath/apache-tomcat-8.5.46/webapps/
rm -rf $appPath/apache-tomcat-8.5.46/webapps/*
if [[ $app_name == 'dubbo_monitor' || $app_name == "dubbo_admin" ]]; then
  wget -c -O ROOT.war $baseUrl/software/dubbo/$app_war_name
else
  wget -c $baseUrl/application/$app_war_name
fi

echo "application $app_name 更新成功：$app_war_name"

