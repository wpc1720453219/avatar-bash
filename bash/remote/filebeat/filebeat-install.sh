#!/usr/bin/env bash
# 说明：
#

set -e

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh
export tfpPath="${env_tfpPath}"
export baseUrl="${env_baseUrl}"

export elasticsearch_host="${env_elasticsearch_host}"
export elasticsearch_port="${env_elasticsearch_port}"
export kibana_host="${env_kibana_host}"
export kibana_port="${env_kibana_port}"
export filebeat_log_index_pattern="${env_filebeat_log_index_pattern}"
export filebeat_log_path_pattern="${env_filebeat_log_path_pattern}"

# 建文件夹
export filebeatPath=$tfpPath/software/filebeat
mkdir -p $filebeatPath
cd $filebeatPath
pwd

# 下载解压
wget -q -c $baseUrl/software/elk/filebeat-6.4.2-linux-x86_64.tar.gz
tar -zxf filebeat-6.4.2-linux-x86_64.tar.gz
export filebeatSoftwarePath=$filebeatPath/filebeat-6.4.2-linux-x86_64

# 改配置
cd $filebeatSoftwarePath

cat << EOF > filebeat.yml
filebeat.inputs:
  - type: log
    enabled: true
    paths:
      - "$filebeat_log_path_pattern"
    json.keys_under_root: true
    json.overwrite_keys: true
setup.template.name: "log"
setup.template.pattern: "log-*"
setup.kibana:
  host: "$kibana_host:$kibana_port"
output.elasticsearch:
  hosts: ["$elasticsearch_host:$elasticsearch_port"]
  index: "log-$filebeat_log_index_pattern-%{+yyyy.MM.dd}"
xpack.monitoring.enabled: true

EOF

echo 'filebeat安装成功'
