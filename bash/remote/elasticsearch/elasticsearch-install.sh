#!/usr/bin/env bash
set -e

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh
export baseUrl="${env_baseUrl}"
export tfpPath="${env_tfpPath}"
export elasticsearch_port="${env_elasticsearch_port}"
export env_elasticsearch_jvm_mem="${env_elasticsearch_jvm_mem}"

# 建文件夹
export elasticsearchPath=$tfpPath/software/elasticsearch
mkdir -p $elasticsearchPath
cd $elasticsearchPath
pwd

# 建用户
## 这个里面遇到已建组、用户会报错退出
# 这里默认非root用户
#set +e
#sudo groupadd elasticsearch
#sudo useradd elasticsearch -g elasticsearch -p elasticsearch
#chown -R elasticsearch:elasticsearch $elasticsearchPath
#set -e

# 解决文件操作数量受限
sudo sed -i "/* hard nofile 65536/d" /etc/security/limits.conf
sudo sed -i "/* soft nofile 65536/d" /etc/security/limits.conf
echo "* hard nofile 65536" | sudo tee -a /etc/security/limits.conf
echo "* soft nofile 65536" | sudo tee -a /etc/security/limits.conf
sudo cat /etc/security/limits.conf
# 解决线程数量受限
sudo sed -i "/* hard nproc 65536/d" /etc/security/limits.conf
sudo sed -i "/* soft nproc 65536/d" /etc/security/limits.conf
echo "* hard nproc 65536" | sudo tee -a /etc/security/limits.conf
echo "* soft nproc 65536" | sudo tee -a /etc/security/limits.conf
sudo cat /etc/security/limits.conf

# 解决内存受限
sudo sed -i "/vm.max_map_count=655360/d" /etc/sysctl.conf
echo "" | sudo tee -a /etc/sysctl.conf
echo "vm.max_map_count=655360" | sudo tee -a /etc/sysctl.conf
sudo cat /etc/sysctl.conf
sudo /sbin/sysctl -p

# 切换用户
# wget 下载包
wget -q -c $baseUrl/software/elk/elasticsearch-6.4.2.tar.gz
tar -zxf elasticsearch-6.4.2.tar.gz
cd $elasticsearchPath/elasticsearch-6.4.2/config

# 改配置
cat << EOG > elasticsearch.yml
network.host: 0.0.0.0
http.port: $elasticsearch_port
xpack.monitoring.enabled: true
xpack.monitoring.collection.enabled: true
bootstrap.system_call_filter: false
EOG

sed -i "s/-Xms1g/-Xms$env_elasticsearch_jvm_mem/g" jvm.options
sed -i "s/-Xmx1g/-Xmx$env_elasticsearch_jvm_mem/g" jvm.options

echo 'elasticsearch安装成功'
