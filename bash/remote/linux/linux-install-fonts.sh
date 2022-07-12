#!/usr/bin/env bash
# 说明：
#

set -e

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh
export tfpPath="${env_tfpPath}"
export baseUrl="${env_baseUrl}"

yum install -y fontconfig dejavu-lgc-sans-fonts

export fontsPath=$tfpPath/software/fonts

mkdir -p $fontsPath
cd $fontsPath

wget -c $baseUrl/software/fonts/msfonts.zip
mkdir -p /usr/share/fonts/msfonts/
unzip $fontsPath/msfonts.zip -d /usr/share/fonts/msfonts/

fc-cache
fc-list
