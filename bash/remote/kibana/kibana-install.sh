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
export kibana_port="${env_kibana_port}"

# 建文件夹
export kibanaPath=$tfpPath/software/kibana
mkdir -p $kibanaPath
cd $kibanaPath
pwd

# 下载解压
wget -q -c $baseUrl/software/elk/kibana-6.4.2-linux-x86_64.tar.gz
tar -zxf kibana-6.4.2-linux-x86_64.tar.gz
export kibanaSoftwarePath=$kibanaPath/kibana-6.4.2-linux-x86_64

# 改配置
cd $kibanaSoftwarePath/config

cat << EOF > kibana.yml
server.host: 0.0.0.0
server.port: $kibana_port
elasticsearch.url: "http://$elasticsearch_host:$elasticsearch_port"
xpack.monitoring.enabled: true
xpack.monitoring.kibana.collection.enabled: true

EOF

echo 'kibana安装成功'

