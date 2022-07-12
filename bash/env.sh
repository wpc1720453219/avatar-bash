#!/usr/bin/env bash

set -e

##########################################################################
# 环境配置
##########################################################################

################################ 通用配置 ##############################
# 软件安装包url地址  需修改
export env_http_file_server_host='10.60.44.113'
export env_http_file_server_port='5000'
# 在这台主机自动部署项目控制路径
export env_deployPath='/data/deploy'
# 远程主机项目部署路径
export env_tfpPath='/data/tfp'
################################ 主机配置 ##############################
# 所有主机名 需修改
export env_nodes_all=(suse1)
# 主机ssh
# 所有可选应用名：
# jdk
# redis redis_master redis_slave redis_sentinel_1 redis_sentinel_2 redis_sentinel_3
# dubbo_monitor dubbo_admin
# elasticsearch filebeat kibana
# ftp
# nginx
# skywalking skywalking_agent
# zookeeper zookeeper_cluster_1 zookeeper_cluster_2 zookeeper_cluster_3
# acccore adminhomepage adminsys basecore cachemanager checksys fundbudsys homepage intraccsys
# settlesys taskser usercore warningser websys workflow

## 定义个map 存放主机信息 及这台主机要安装的应用
declare -A env_node_suse1=(["user"]="shijianjs" ["host"]="192.168.52.130" ["ssh_port"]="22" \
  ["apps"]="(jdk ftp nginx zookeeper redis elasticsearch kibana filebeat skywalking skywalking_agent dubbo_monitor \
  dubbo_admin zookeeper_cluster_1 zookeeper_cluster_2 zookeeper_cluster_3 \
  redis_master redis_slave redis_sentinel_1 redis_sentinel_2 redis_sentinel_3 \
  acccore adminhomepage adminsys basecore cachemanager checksys fundbudsys homepage intraccsys \
  settlesys taskser usercore warningser websys workflow)")

declare -A env_node_suse2=(["user"]="shijianjs" ["host"]="192.168.52.131" ["ssh_port"]="22" \
  ["apps"]="()")
################################ elasticsearch ######################
# elasticsearch的端口
export env_elasticsearch_port='9200'
# elasticsearch的jvm内存大小，建议大于4g
export env_elasticsearch_jvm_mem='1g'
################################ kibana ##############################
# kibana的ip 这个用上面的配置自动解析
#export env_kibana_host='192.168.52.130'
# kibana的端口
export env_kibana_port='5601'
################################ skywalking ############################
# skywalking后台grpc端口
export env_skywalking_grpc_port='11800'
# skywalking后台http端口
export env_skywalking_rest_port='12800'
# skywalking网页访问界面的端口
export env_skywalking_webapp_port='8081'
################################ filebeat ##############################
# 应用的日志路径
export env_filebeat_log_path_pattern='/data/tfp/logs/**/*-filebeat.*.log'
# 应用在es里生成的index名称，最终index示例：log-{pattern}-2019.06.24
export env_filebeat_log_index_pattern='tfp'
################################ redis #################################
# redis端口
export env_redis_port='6379'
# redis密码，为空表示不设置密码
export env_redis_password=''
# redis集群哨兵模式端口配置
export env_redis_master_port='6379'
export env_redis_slave_port='6378'
export env_redis_sentinel_1_port='6377'
export env_redis_sentinel_2_port='6376'
export env_redis_sentinel_3_port='6375'
################################ zookeeper #############################
# zookeeper端口
export env_zookeeper_port='2181'
# zookeeper集群的每个节点需要三个端口，
# 第一个是客户端连接的，后两个是集群的原子广播端口、选举端口
# 同一台机器部署多个节点，必需保证端口不冲突；
# 分别在3台机器的话，建议全用默认端口(2181 2888 3888)
export env_zookeeper_cluster_1_ports=(2181 2881 3881)
export env_zookeeper_cluster_2_ports=(2182 2882 3882)
export env_zookeeper_cluster_3_ports=(2183 2883 3883)

################################ jdk ##############################
# jdk-xxx.tar.gz，解压后，那个文件夹的名称，需要设置正确
export JAVA_HOME=$env_tfpPath/software/jdk/jdk1.8.0_181
export JRE_HOME=$JAVA_HOME
################################ ntp ##############################
# ntp用于时间同步，尽量在内网搭起一个ntp服务
export env_ntp_server="ntp.aliyun.com"
################################ ftp ##############################
# ftp服务
export env_ftp_username="atscloud"
export env_ftp_password="atscloud"

################################ 应用 tomcat-app ##############################
# 所有的应用名，设置在这里供提醒
export env_app_names="dubbo_monitor dubbo_admin acccore adminhomepage adminsys basecore cachemanager \
  checksys fundbudsys homepage intraccsys settlesys taskser usercore warningser websys workflow"
# 应用默认jvm参数
export env_app_jvm_opts="-Xms200m -Xmx300m"
# 应用log位置
export env_app_log_path="$env_tfpPath/logs/"

# 应用的个性化配置
## 配置示例说明：
## 这个应用对应的jar包名字
##    export env_app_name_warningser="warningser-service-provider-2.0.0-SNAPSHOT.war"
## 单独为应用设置jvm参数，没设置的话，将使用默认值env_app_jvm_opts
##    export env_app_jvm_opts_warningser="-Xms300m -Xmx300m"
## 这个应用的tomcat的三个端口，分别是对应(shutdown_port http_port ajp_port)
##    export env_app_tomcat_ports_warningser=(8600 8086 8006)

# acccore
export env_app_name_acccore="acccore-service-provider-2.0.0-SNAPSHOT.war"
export env_app_jvm_opts_acccore="-Xms200m -Xmx400m"
export env_app_tomcat_ports_acccore=(8701 8702 8703)
# adminhomepage
export env_app_name_adminhomepage="adminhomepage-provider-2.0.0-SNAPSHOT.war"
export env_app_jvm_opts_adminhomepage="-Xms200m -Xmx400m"
export env_app_tomcat_ports_adminhomepage=(8704 8705 8706)
# adminsys
export env_app_name_adminsys="adminsys.war"
export env_app_jvm_opts_adminsys="-Xms200m -Xmx400m"
export env_app_tomcat_ports_adminsys=(8707 8708 8709)
# basecore
export env_app_name_basecore="basecore-provider-2.0.0-SNAPSHOT.war"
export env_app_jvm_opts_basecore="-Xms200m -Xmx400m"
export env_app_tomcat_ports_basecore=(8710 8711 8712)
# cachemanager
export env_app_name_cachemanager="cachemanager-provider-2.0.0-SNAPSHOT.war"
export env_app_jvm_opts_cachemanager="-Xms200m -Xmx400m"
export env_app_tomcat_ports_cachemanager=(8713 8714 8715)
# checksys
export env_app_name_checksys="checksys-provider-2.0.0-SNAPSHOT.war"
export env_app_jvm_opts_checksys="-Xms200m -Xmx400m"
export env_app_tomcat_ports_checksys=(8716 8717 8718)
# fundbudsys
export env_app_name_fundbudsys="fundbudsys-service-provider-2.0.0-SNAPSHOT.war"
export env_app_jvm_opts_fundbudsys="-Xms200m -Xmx400m"
export env_app_tomcat_ports_fundbudsys=(8719 8720 8721)
# homepage
export env_app_name_homepage="homepage-provider-2.0.0-SNAPSHOT.war"
export env_app_jvm_opts_homepage="-Xms200m -Xmx400m"
export env_app_tomcat_ports_homepage=(8722 8723 8724)
# intraccsys
export env_app_name_intraccsys="intraccsys-provider-2.0.0-SNAPSHOT.war"
export env_app_jvm_opts_intraccsys="-Xms200m -Xmx400m"
export env_app_tomcat_ports_intraccsys=(8725 8726 8727)
# settlesys
export env_app_name_settlesys="settlesys-provider-2.0.0-SNAPSHOT.war"
export env_app_jvm_opts_settlesys="-Xms200m -Xmx400m"
export env_app_tomcat_ports_settlesys=(8728 8729 8730)
# taskser
export env_app_name_taskser="taskser-provider-2.0.0-SNAPSHOT.war"
export env_app_jvm_opts_taskser="-Xms200m -Xmx400m"
export env_app_tomcat_ports_taskser=(8731 8732 8733)
# usercore
export env_app_name_usercore="usercore-provider-2.0.0-SNAPSHOT.war"
export env_app_jvm_opts_usercore="-Xms200m -Xmx400m"
export env_app_tomcat_ports_usercore=(8734 8735 8736)
# warningser
export env_app_name_warningser="warningser-service-provider-2.0.0-SNAPSHOT.war"
export env_app_jvm_opts_warningser="-Xms200m -Xmx400m"
export env_app_tomcat_ports_warningser=(8737 8738 8739)
# websys
export env_app_name_websys="webx.war"
export env_app_jvm_opts_websys="-Xms200m -Xmx400m"
export env_app_tomcat_ports_websys=(8740 8741 8742)
# workflow
export env_app_name_workflow="workflow-provider-2.0.0-SNAPSHOT.war"
export env_app_jvm_opts_workflow="-Xms200m -Xmx400m"
export env_app_tomcat_ports_workflow=(8743 8744 8745)
# dubbo-monitor
export env_app_name_dubbo_monitor="dubbo-monitor.war"
export env_app_jvm_opts_dubbo_monitor="-Xms300m -Xmx300m"
export env_app_tomcat_ports_dubbo_monitor=(8911 8910 8912)
# dubbo-admin
export env_app_name_dubbo_admin="dubbo-admin.war"
export env_app_jvm_opts_dubbo_admin="-Xms300m -Xmx300m"
export env_app_tomcat_ports_dubbo_admin=(8921 8920 8922)

#########################################################################################################################
#########################################################################################################################
#########################################################################################################################
#########################################################################################################################
# 注意：
# 其他通用脚本，尽量不要修改下面的内容！！
##########################################################################
export env_baseUrl="http://${env_http_file_server_host}:${env_http_file_server_port}"

# 把java路径添加到PATH
export PATH=$JAVA_HOME/bin:$PATH

# 使用方式：`stop_process [$stop_process_arg] $PROCESS_PATTERN`
# 例如：
# stop_process $skywalkingPath/apache-skywalking-apm-bin/webapp/skywalking-webapp.jar
# stop_process -9 $skywalkingPath/apache-skywalking-apm-bin/webapp/skywalking-webapp.jar
function stop_process() {
  if [ -z $2 ]; then
    kill_arg=''
    cmd_contain=$1
  else
    kill_arg=$1
    cmd_contain=$2
  fi
  appid=$(ps -ef |grep "$cmd_contain" |grep -v grep | awk '{print $2}')
  echo appid=$appid
  if [ -n "$appid" ];
  then
    echo stopping $kill_arg $cmd_contain
    kill $kill_arg $appid
  fi
}

# 检查java
# 使用示例：
# checkJava
function checkJava {
  if [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]];  then
      _java="$JAVA_HOME/bin/java"
  elif type -p java > /dev/null; then
    _java=java
  else
      echo "Could not find java executable, please check PATH and JAVA_HOME variables."
      exit 1
  fi

  if [[ "$_java" ]]; then
      version=$("$_java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
      # shellcheck disable=SC2072
      if [[ "$version" < "1.8" ]]; then
          echo "Java version is $version, please make sure java 1.8+ is in the path"
          exit 1
      fi
  fi
}

# 等待应用启动，2分钟超时，支持http接口
# 使用示例：
# checkServerAlive http://www.baidu.com
function checkServerAlive {
  declare -i counter=0
  declare -i max_counter=24 # 24*5=120s
  declare -i total_time=0

  SERVER_URL="$1"

  until [[ (( counter -ge max_counter )) || "$(curl -X GET --silent --connect-timeout 2 --max-time 5 --head $SERVER_URL | grep "HTTP")" != "" ]];
  do
    printf "."
    counter+=1
    sleep 5
  done

  total_time=counter*5

  if [[ (( counter -ge max_counter )) ]];
  then
    return $total_time
  fi

  return 0
}



# 根据节点名在远程执行
# 示例： run_remote suse1 'top b'
# 1. suse1--> env_node_suse1=(["user"]="shijianjs" ["host"]="192.168.52.130" ["ssh_port"]="22"
# 2. 获取env_node_suse1数据执行ssh操作
function run_remote() {
  # 节点名
  node_name=$1
  # ssh_clause
  ssh_clause=$2
  eval ssh_port=\$\{env_node_${node_name}["ssh_port"]\}
  eval ssh_user=\$\{env_node_${node_name}["user"]\}
  eval ssh_host=\$\{env_node_${node_name}["host"]\}
  ssh_option="-p $ssh_port $ssh_user@$ssh_host"
  # 实例：ssh -p 22 avatar@124.223.96.129  top -b
  # $ssh_clause=“top b”
  ssh $ssh_option "$ssh_clause"
}

# 遍历所有节点 [主机]，在远程执行 将env.sh复制过去，并执行env.sh
function run_in_all_nodes() {
  # ssh_clause
  ssh_clause=$1
  # shellcheck disable=SC2068
  for node_name in ${env_nodes_all[@]} ; do
    run_remote $node_name "mkdir -p $env_tfpPath/bash; \
      wget -q -x -O $env_tfpPath/bash/env.sh $env_baseUrl/bash/env.sh; \
      source $env_tfpPath/bash/env.sh; \
      $ssh_clause"
  done
}


# 在远程执行shell脚本
# 示例：
# run_shell_remote suse1 'jdk/jdk-install.sh'
#将 env.sh 与 脚本复制进去，并执行脚本
function run_shell_remote() {
  # 节点名
  node_name=$1
  # 脚本名
  shell_file=$2
  # 脚本参数
  shell_args=$3
  # 远程执行脚本前插入一些字符，比如：sudo，或者更长的命令
  before_bash_inject=$4

  # 获取目录名
  OLD_IFS="$IFS"
  IFS="/"
  array=($shell_file)
  IFS="$OLD_IFS"
  shell_dir=${array[0]}

  run_remote $node_name "set -x; \
    mkdir -p $env_tfpPath/bash/$shell_dir; \
    wget -q -x -O $env_tfpPath/bash/env.sh $env_baseUrl/bash/env.sh; \
    wget -q -x -O $env_tfpPath/bash/$shell_file $env_baseUrl/bash/remote/$shell_file; \
    $before_bash_inject bash $env_tfpPath/bash/$shell_file $shell_args;"
}


# 获取要安装的节点，结果装在变量nodes_to_install数组里面
# 参数：应用名
# 示例：
# get_nodes_to_install jdk
function get_nodes_to_install() {
  app_name=$1
  nodes_to_install=()
  # shellcheck disable=SC2068
  for node_name in ${env_nodes_all[@]} ; do
    #echo $node_name
    eval node_apps_str=\$\{env_node_${node_name}["apps"]\}
    eval node_apps=$node_apps_str
    for node_app in ${node_apps[@]} ; do
      if [ $app_name = $node_app ]; then
        nodes_to_install[${#nodes_to_install[@]}]=$node_name
      fi
    done
  done
}

# 在配置好的节点安装指定应用
function app_install() {
  # 应用名
  app_name=$1
  # 脚本名
  shell_file=$2
  # 脚本参数
  shell_args=$3
  # 远程执行脚本前插入一些字符，比如：sudo，或者更长的命令
  before_bash_inject=$4
  get_nodes_to_install $app_name
  echo "将在节点【${nodes_to_install[*]}】对组件【${app_name}】执行【${shell_file}】"
  for node_to_install in "${nodes_to_install[@]}" ; do
    echo "正在节点【${node_to_install}】对组件【${app_name}】执行【${shell_file}】"
    run_shell_remote $node_to_install $shell_file "$shell_args" "$before_bash_inject"
  done
}

# 解析应用安装节点
# 并设置环境变量，类似于：env_elasticsearch_host、env_kibana_host
#resolve_app_host elasticsearch --> env_elasticsearch_host 地址
#resolve_app_host kibana --> env_kibana_host 地址
#resolve_app_host skywalking --> env_skywalking_host 地址
#
function resolve_app_host() {
  # 应用名
  app_name=$1
  get_nodes_to_install $app_name
  nodes_count=${#nodes_to_install[*]}
  if [ $nodes_count -lt 1 ]; then
    echo "应用【$app_name】没配置安装节点，请检查配置"
    exit 1
  elif [ $nodes_count -gt 1 ]; then
    echo "应用【$app_name】配置了多个安装节点【${nodes_to_install[*]}】，请检查配置"
    exit 1
  fi
  node_name=${nodes_to_install[0]}
  eval env_${app_name}_host=\$\{env_node_${node_name}["host"]\}
}

# 校验linux命令
function linux_commands_verify() {
  unsupported_commands=""
  for i in $* ; do
    which $i
    local result=$?
    if [ "$result" != "0" ]; then
      unsupported_commands="$unsupported_commands $i"
    fi
  done
  if [ -n "$unsupported_commands" ]; then
    echo "该主机不支持以下linux命令，请先解决：$unsupported_commands"
    exit 1
  fi
}


