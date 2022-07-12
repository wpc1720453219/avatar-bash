#!/usr/bin/env bash
set -e

# 读取配置
if [[ $0 =~ ^\/.* ]] #判断当前脚本是否为绝对路径，匹配以/开头下的所有
then
  script=$0
else
  script=$(pwd)/$0
fi
script=`readlink -f $script` #获取文件的真实路径
script_path=${script%/*}  #获取文件所在的目录
current_path=$(readlink -f $script_path)  #获取文件所在目录的真实路径
source $current_path/../env.sh

# 启动http文件服务，用于部署
function http_file_server_start() {
  cd $env_deployPath
  nohup python2 -m SimpleHTTPServer ${env_http_file_server_port} >> http_file_server.out 2>&1 &
  checkServerAlive $env_baseUrl
  echo "用于部署的http文件服务启动成功"
}
# 关闭http文件服务
function http_file_server_stop() {
  stop_process "python2 -m SimpleHTTPServer ${env_http_file_server_port}"
}
# 检查http文件服务
function http_file_server_check() {
  if [ "$(curl -X GET --silent --connect-timeout 2 --max-time 5 --head $env_baseUrl | grep "HTTP")" == "" ]; then
    http_file_server_start
  fi
}

# 安装jdk
function jdk_install() {
  app_install "jdk" 'jdk/jdk-install.sh'
}

# 安装zookeeper
function zookeeper_install() {
  app_install "zookeeper" 'zookeeper/zookeeper-install.sh'
}

# 启动zookeeper
function zookeeper_start() {
  app_install "zookeeper" 'zookeeper/zookeeper-start.sh'
}
# 关闭zookeeper
function zookeeper_stop() {
  app_install "zookeeper" 'zookeeper/zookeeper-stop.sh'
}
# zookeeper状态
function zookeeper_status() {
  app_install "zookeeper" 'zookeeper/zookeeper-status.sh'
}

# 安装zookeeper集群
function zookeeper_cluster_install() {
  app_install "zookeeper_cluster_1" 'zookeeper_cluster/zookeeper_cluster-install.sh' 1
  app_install "zookeeper_cluster_2" 'zookeeper_cluster/zookeeper_cluster-install.sh' 2
  app_install "zookeeper_cluster_3" 'zookeeper_cluster/zookeeper_cluster-install.sh' 3
}

# 启动zookeeper集群
function zookeeper_cluster_start() {
  app_install "zookeeper_cluster_1" 'zookeeper_cluster/zookeeper_cluster-start.sh' 1
  app_install "zookeeper_cluster_2" 'zookeeper_cluster/zookeeper_cluster-start.sh' 2
  app_install "zookeeper_cluster_3" 'zookeeper_cluster/zookeeper_cluster-start.sh' 3
}
# 关闭zookeeper集群
function zookeeper_cluster_stop() {
  app_install "zookeeper_cluster_1" 'zookeeper_cluster/zookeeper_cluster-stop.sh' 1
  app_install "zookeeper_cluster_2" 'zookeeper_cluster/zookeeper_cluster-stop.sh' 2
  app_install "zookeeper_cluster_3" 'zookeeper_cluster/zookeeper_cluster-stop.sh' 3
}
# zookeeper集群 查询节点状态
function zookeeper_cluster_status() {
  app_install "zookeeper_cluster_1" 'zookeeper_cluster/zookeeper_cluster-status.sh' 1
  app_install "zookeeper_cluster_2" 'zookeeper_cluster/zookeeper_cluster-status.sh' 2
  app_install "zookeeper_cluster_3" 'zookeeper_cluster/zookeeper_cluster-status.sh' 3
}

# 编译redis
function redis_make() {
  # 解压
  cd $env_deployPath/software/redis
  rm -rf $env_deployPath/software/redis/redis-4.0.14
  rm -rf $env_deployPath/software/redis/redis-4.0.14-suse12
  rm -rf $env_deployPath/software/redis/redis-4.0.14-suse12.tar.gz
  tar -zxf redis-4.0.14.tar.gz
  # 编译
  cd $env_deployPath/software/redis/redis-4.0.14
  make
  # 打包
  mkdir -p $env_deployPath/software/redis/redis-4.0.14-suse12
  cp $env_deployPath/software/redis/redis-4.0.14/src/redis-benchmark $env_deployPath/software/redis/redis-4.0.14-suse12/
  cp $env_deployPath/software/redis/redis-4.0.14/src/redis-check-aof $env_deployPath/software/redis/redis-4.0.14-suse12/
  cp $env_deployPath/software/redis/redis-4.0.14/src/redis-check-rdb $env_deployPath/software/redis/redis-4.0.14-suse12/
  cp $env_deployPath/software/redis/redis-4.0.14/src/redis-cli $env_deployPath/software/redis/redis-4.0.14-suse12/
  cp $env_deployPath/software/redis/redis-4.0.14/src/redis-sentinel $env_deployPath/software/redis/redis-4.0.14-suse12/
  cp $env_deployPath/software/redis/redis-4.0.14/src/redis-server $env_deployPath/software/redis/redis-4.0.14-suse12/
  cp $env_deployPath/software/redis/redis-4.0.14/src/redis-trib.rb $env_deployPath/software/redis/redis-4.0.14-suse12/
  cp $env_deployPath/software/redis/redis-4.0.14/sentinel.conf $env_deployPath/software/redis/redis-4.0.14-suse12/
  cp $env_deployPath/software/redis/redis-4.0.14/redis.conf $env_deployPath/software/redis/redis-4.0.14-suse12/
  cd $env_deployPath/software/redis
  tar -zvcf redis-4.0.14-suse12.tar.gz redis-4.0.14-suse12
}
# 安装redis
function redis_install() {
  if [ ! -f "$env_deployPath/software/redis/redis-4.0.14-suse12.tar.gz" ]; then
      redis_make
  fi
  app_install "redis" 'redis/redis-install.sh'
}

# 启动redis
function redis_start() {
  app_install "redis" 'redis/redis-start.sh'
}
# 关闭redis
function redis_stop() {
  app_install "redis" 'redis/redis-stop.sh'
}

# 安装redis集群哨兵模式
function redis_sentinel_install() {
  if [ ! -f "$env_deployPath/software/redis/redis-4.0.14-suse12.tar.gz" ]; then
      redis_make
  fi
  app_install "redis_master" 'redis_sentinel/redis_sentinel-install.sh' 'master'
  app_install "redis_slave" 'redis_sentinel/redis_sentinel-install.sh' 'slave'
  app_install "redis_sentinel_1" 'redis_sentinel/redis_sentinel-install.sh' 'sentinel_1'
  app_install "redis_sentinel_2" 'redis_sentinel/redis_sentinel-install.sh' 'sentinel_2'
  app_install "redis_sentinel_3" 'redis_sentinel/redis_sentinel-install.sh' 'sentinel_3'
}

# 启动redis集群哨兵模式
function redis_sentinel_start() {
  app_install "redis_master" 'redis_sentinel/redis_sentinel-start.sh' 'master'
  app_install "redis_slave" 'redis_sentinel/redis_sentinel-start.sh' 'slave'
  app_install "redis_sentinel_1" 'redis_sentinel/redis_sentinel-start.sh' 'sentinel_1'
  app_install "redis_sentinel_2" 'redis_sentinel/redis_sentinel-start.sh' 'sentinel_2'
  app_install "redis_sentinel_3" 'redis_sentinel/redis_sentinel-start.sh' 'sentinel_3'
}
# 关闭redis集群哨兵模式
function redis_sentinel_stop() {
  app_install "redis_master" 'redis_sentinel/redis_sentinel-stop.sh' 'master'
  app_install "redis_slave" 'redis_sentinel/redis_sentinel-stop.sh' 'slave'
  app_install "redis_sentinel_1" 'redis_sentinel/redis_sentinel-stop.sh' 'sentinel_1'
  app_install "redis_sentinel_2" 'redis_sentinel/redis_sentinel-stop.sh' 'sentinel_2'
  app_install "redis_sentinel_3" 'redis_sentinel/redis_sentinel-stop.sh' 'sentinel_3'
}
# redis集群哨兵模式 状态查询
function redis_sentinel_status() {
  app_install "redis_master" 'redis_sentinel/redis_sentinel-status.sh' 'master Replication'
  app_install "redis_slave" 'redis_sentinel/redis_sentinel-status.sh' 'slave Replication'
  app_install "redis_sentinel_1" 'redis_sentinel/redis_sentinel-status.sh' 'sentinel_1 Sentinel'
  app_install "redis_sentinel_2" 'redis_sentinel/redis_sentinel-status.sh' 'sentinel_2 Sentinel'
  app_install "redis_sentinel_3" 'redis_sentinel/redis_sentinel-status.sh' 'sentinel_3 Sentinel'
}

# 安装tomcat
function tomcat_install() {
  # 读参数
  app_name=$1
  if [ -z "$app_name" ]; then
    echo "请输入以下应用名中的一个："
    echo $env_app_names
    echo "示例：./tfp.sh tomcat_install usercore"
    exit 1
  fi
  app_install "$app_name" 'tomcat/tomcat-install.sh' "$app_name"
}
# 更新tomcat
function tomcat_update() {
  # 读参数
  app_name=$1
  if [ -z "$app_name" ]; then
    echo "请输入以下应用名中的一个："
    echo $env_app_names
    echo "示例：./tfp.sh tomcat_update usercore"
    exit 1
  fi
  set -e
  app_install "$app_name" 'tomcat/tomcat-stop.sh' "$app_name"
  app_install "$app_name" 'tomcat/tomcat-update.sh' "$app_name"
  app_install "$app_name" 'tomcat/tomcat-start.sh' "$app_name"
}
# 启动tomcat
function tomcat_start() {
  # 读参数
  app_name=$1
  if [ -z "$app_name" ]; then
    echo "请输入以下应用名中的一个："
    echo $env_app_names
    echo "示例：./tfp.sh tomcat_start usercore"
    exit 1
  fi
  app_install "$app_name" 'tomcat/tomcat-start.sh' "$app_name"
}
# 关闭tomcat
function tomcat_stop() {
  # 读参数
  app_name=$1
  if [ -z "$app_name" ]; then
    echo "请输入以下应用名中的一个："
    echo $env_app_names
    echo "示例：./tfp.sh tomcat_stop usercore"
    exit 1
  fi
  app_install "$app_name" 'tomcat/tomcat-stop.sh' "$app_name"
}

# 遍历所有tomcat的应用名
function loop_all_app_names() {
  local function_name=$1
  for i in $env_app_names ; do
    echo "正在执行：$function_name$i"
    $function_name $i
  done
}

# 安装所有tomcat
function tomcat_install_all() {
  loop_all_app_names tomcat_install
}

# 启动所有tomcat
function tomcat_start_all() {
  loop_all_app_names tomcat_start
}

# 关闭所有tomcat
function tomcat_stop_all() {
  loop_all_app_names tomcat_stop
}

# 更新所有tomcat
function tomcat_update_all() {
  loop_all_app_names tomcat_update
}

# 安装elasticsearch
function elasticsearch_install() {
  app_install "elasticsearch" 'elasticsearch/elasticsearch-install.sh'
}

# 启动elasticsearch
function elasticsearch_start() {
  app_install "elasticsearch" 'elasticsearch/elasticsearch-start.sh'
}

# 关闭elasticsearch
function elasticsearch_stop() {
  app_install "elasticsearch" 'elasticsearch/elasticsearch-stop.sh'
}

# 安装kibana
function kibana_install() {
  app_install "kibana" 'kibana/kibana-install.sh'
}

# 启动kibana
function kibana_start() {
  app_install "kibana" 'kibana/kibana-start.sh'
}

# 关闭kibana
function kibana_stop() {
  app_install "kibana" 'kibana/kibana-stop.sh'
}

# kibana创建日志索引pattern
function kibana_index_pattern() {
  curl "http://${env_kibana_host}:${env_kibana_port}/api/saved_objects/index-pattern" \
    -H "Origin: http://${env_kibana_host}:${env_kibana_port}" \
    -H 'Accept-Encoding: gzip, deflate' \
    -H 'Accept-Language: zh-CN,zh;q=0.9' \
    -H 'kbn-version: 6.4.2' \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36' \
    -H 'Content-Type: application/json' \
    -H 'Accept: */*' \
    -H "Referer: http://${env_kibana_host}:${env_kibana_port}/app/kibana" \
    -H 'Connection: keep-alive' \
    --data-binary '{"attributes":{"title":"log-'${env_filebeat_log_index_pattern}'-*","timeFieldName":"@timestamp"}}' \
    --compressed --insecure
}

# 安装filebeat
function filebeat_install() {
  app_install "filebeat" 'filebeat/filebeat-install.sh'
}

# 启动filebeat
function filebeat_start() {
  app_install "filebeat" 'filebeat/filebeat-start.sh'
}

# 关闭filebeat
function filebeat_stop() {
  app_install "filebeat" 'filebeat/filebeat-stop.sh'
}


# 安装skywalking
function skywalking_install() {
  app_install "skywalking" 'skywalking/skywalking-install.sh'
}

# 启动skywalking
function skywalking_start() {
  app_install "skywalking" 'skywalking/skywalking-start.sh'
}

# 关闭skywalking
function skywalking_stop() {
  app_install "skywalking" 'skywalking/skywalking-stop.sh'
}

# skywalking探针制作打包
function skywalking_agent_package() {
  cd $env_deployPath/software/skywalking
  # 解压压缩包
  unzip -o apache-skywalking-apm-6.3.0.zip
  # 拷贝插件
  cp -r plugins/*.jar apache-skywalking-apm-bin/agent/plugins/
  # 拷贝基础配置
  cp -rf config/* apache-skywalking-apm-bin/config/

  # 进入skywalking目录
  cd apache-skywalking-apm-bin/


  # 移动插件，启用gateway，禁用redis，包括jedis、redisson
  mv agent/optional-plugins/apm-spring-cloud-gateway-2.x-plugin-6.3.0.jar agent/plugins/
  mv agent/plugins/apm-jedis-2.x-plugin-6.3.0.jar agent/optional-plugins/
  mv agent/plugins/apm-redisson-3.x-plugin-6.3.0.jar agent/optional-plugins/
  ls -al agent/plugins/
  ls -al agent/optional-plugins/

  rm -rf ../skywalking-agent-6.3.0
  mv agent ../skywalking-agent-6.3.0
  cd ..
  rm -rf apache-skywalking-apm-bin
  tar -zcf skywalking-agent-6.3.0.tar.gz skywalking-agent-6.3.0
}

# skywalking探针安装
function skywalking_agent_install() {
  if [ ! -f "$env_deployPath/software/skywalking/skywalking-agent-6.3.0.tar.gz" ]; then
      skywalking_agent_package
  fi
  app_install "skywalking_agent" 'skywalking/skywalking_agent-install.sh'
}


# 安装ftp
function ftp_install() {
  app_install "ftp" 'vsftpd/vsftpd-install.sh' '' 'sudo'
}


# 安装nginx
function nginx_install() {
  app_install "nginx" 'nginx/nginx-install.sh'
}

# 启动nginx
function nginx_start() {
  app_install "nginx" 'nginx/nginx-start.sh'
}

# 关闭nginx
function nginx_stop() {
  app_install "nginx" 'nginx/nginx-stop.sh'
}

# 安装所有中间件
function middleware_all_install() {
  jdk_install
  zookeeper_cluster_install
  redis_sentinel_install
  elasticsearch_install
  filebeat_install
  kibana_install
  skywalking_install
  skywalking_agent_install
  nginx_install
}
# 启动所有中间件
function middleware_all_start() {
  zookeeper_cluster_start
  redis_sentinel_start
  elasticsearch_start
  filebeat_start
  kibana_start
  skywalking_start
  nginx_start
}
# 关闭所有中间件
function middleware_all_stop() {
  zookeeper_cluster_stop
  redis_sentinel_stop
  elasticsearch_stop
  filebeat_stop
  kibana_stop
  skywalking_stop
  nginx_stop
}

# 检查linux基础命令
function verify_commands() {
  linux_commands_verify wget unzip curl tee tar sed cat sudo nohup python2 make
  run_in_all_nodes "linux_commands_verify wget unzip curl tee tar sed cat sudo nohup make"
}

# 部署前执行机器环境设置
function prepage_deploy() {
  # 加执行权限
  chmod a+x $current_path/tfp.sh
  # 创建链接
  if [ ! -f ~/tfp ]; then

    ln -s $current_path/tfp.sh ~/tfp
  fi
  # 检查linux命令
  verify_commands
}


#jdk_install
#zookeeper_install
#zookeeper_start
#zookeeper_stop
#redis_make
#redis_install

# 先检查文件服务
http_file_server_check
# 传递的参数作命令运行
$*
