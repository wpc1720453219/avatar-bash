#!/usr/bin/env bash
set -e

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh
export baseUrl="${env_baseUrl}"
export tfpPath="${env_tfpPath}"

# 建文件夹
export skywalkingPath=$tfpPath/software/skywalking
mkdir -p $skywalkingPath
cd $skywalkingPath
pwd

# wget 下载包
wget -c $baseUrl/software/skywalking/apache-skywalking-apm-6.3.0.zip
wget -c $baseUrl/software/skywalking/plugins/apm-oracle-10.x-plugin-1.0.1.jar
wget -c $baseUrl/software/skywalking/plugins/fingard-logback-plugin-6.3.0.jar
mkdir -p $skywalkingPath/base_config
wget -c -O base_config/application.yml $baseUrl/software/skywalking/config/application.yml
wget -c -O base_config/component-libraries.yml $baseUrl/software/skywalking/config/component-libraries.yml

# 解压压缩包
rm -rf $skywalkingPath/apache-skywalking-apm-bin
unzip apache-skywalking-apm-6.3.0.zip

# 拷贝插件
cp -r *.jar apache-skywalking-apm-bin/agent/plugins/
# 拷贝基础配置
cp -rf base_config/* apache-skywalking-apm-bin/config/

# 进入skywalking目录
cd apache-skywalking-apm-bin/

# 移动插件，启用gateway，禁用redis，包括jedis、redisson
mv agent/optional-plugins/apm-spring-cloud-gateway-2.x-plugin-6.3.0.jar agent/plugins/
mv agent/plugins/apm-jedis-2.x-plugin-6.3.0.jar agent/optional-plugins/
mv agent/plugins/apm-redisson-3.x-plugin-6.3.0.jar agent/optional-plugins/
ls -al agent/plugins/
ls -al agent/optional-plugins/

# 脚本添加执行权限
chmod a+x bin/*.sh

echo 'skywalking安装成功'
