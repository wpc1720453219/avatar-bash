#!/usr/bin/env bash
# 说明：
# opensuse12.1的vsftpd默认的版本是
# vsftpd -v
# vsftpd: version 2.3.4
# 此脚本只提供一个参考，未必可用。
# opensuse12.1的2.3.4版本试验失败；
# centos7的版本3.0.2可以成功（不过还需要改配置文件vsftpd.conf的位置）。

set -e

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh

set -x
sudo zypper -n install vsftpd
sudo systemctl start vsftpd.service
sudo systemctl status vsftpd.service
sudo systemctl stop vsftpd.service

mkdir -p /etc/vsftpd/

export ftp_root_path=${env_tfpPath}/ftp

cat << EOF > /etc/vsftpd/vuser.txt
$env_ftp_username
$env_ftp_password
EOF

db_load -T -t hash -f /etc/vsftpd/vuser.txt /etc/vsftpd/vuser.db
chmod 600 /etc/vsftpd/vuser.db
rm -f /etc/vsftpd/vuser.txt

set +e
useradd -d ${ftp_root_path} -s /sbin/nologin virtualvsftpd
set -e
mkdir -p ${ftp_root_path}
chmod -Rf 755 ${ftp_root_path}
chown -Rf virtualvsftpd:users ${ftp_root_path}

cat << EOF > /etc/pam.d/vsftpd.vu
auth     required     pam_userdb.so  db=/etc/vsftpd/vuser
account  required     pam_userdb.so  db=/etc/vsftpd/vuser
EOF

mkdir -p /etc/vsftpd/vusers_dir

cat << EOF > /etc/vsftpd/vusers_dir/${env_ftp_username}
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
EOF

cat << EOF > /etc/vsftpd.conf
anonymous_enable=NO
anon_umask=022
local_enable=YES
guest_enable=YES
guest_username=virtualvsftpd
allow_writeable_chroot=YES
write_enable=YES
local_umask=022
local_root=${ftp_root_path}
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
listen_port=21
listen=YES
listen_ipv6=NO
pam_service_name=vsftpd.vu
userlist_enable=YES
tcp_wrappers=YES
user_config_dir=/etc/vsftpd/vusers_dir
pasv_min_port=45000
pasv_max_port=49000
EOF

sudo systemctl start vsftpd.service
sudo systemctl status vsftpd.service
