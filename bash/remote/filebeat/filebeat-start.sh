#!/usr/bin/env bash
# 说明：
#

set -e

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh
export tfpPath="${env_tfpPath}"
export baseUrl="${env_baseUrl}"

export filebeatSoftwarePath=$tfpPath/software/filebeat/filebeat-6.4.2-linux-x86_64
cd $filebeatSoftwarePath

nohup $filebeatSoftwarePath/filebeat -c $filebeatSoftwarePath/filebeat.yml \
  >> $filebeatSoftwarePath/filebeat.out 2>&1 &

echo 'filebeat启动成功'
