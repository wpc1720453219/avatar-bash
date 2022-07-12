#!/usr/bin/env bash

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh
export tfpPath="${env_tfpPath}"

env_ntp_server="${env_ntp_server}"

rpm -q ntp
ntpdate -u ntp.aliyun.com

cat << EOF > /etc/ntp.conf
driftfile /var/lib/ntp/drift
restrict 127.0.0.1
restrict ::1
server $env_ntp_server
restrict $env_ntp_server nomodify notrap noquery
server  127.127.1.0
fudge   127.127.1.0 stratum 10
includefile /etc/ntp/crypto/pw
keys /etc/ntp/keys
disable monitor
EOF

ntpdate -u $env_ntp_server
systemctl restart ntpd
systemctl enable ntpd
systemctl status ntpd
timedatectl status
# 重启依赖于系统时间的服务
timedatectl set-local-rtc 0
systemctl restart rsyslog
systemctl restart crond
sleep 3
ntpq -p
ntpstat
echo $?
