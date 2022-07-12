#!/usr/bin/env bash
set -e

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh
export tfpPath="${env_tfpPath}"

export kibanaBinPath=$tfpPath/software/kibana/kibana-6.4.2-linux-x86_64/bin

# 省的其他地址没kibana用户的写权限
cd $kibanaBinPath
# 后台启动
nohup $kibanaBinPath/kibana >> $kibanaBinPath/kibana.out 2>&1 &
checkServerAlive http://$env_kibana_host:$env_kibana_port
#$kibanaBinPath/kibana

echo 'kibana启动成功'
