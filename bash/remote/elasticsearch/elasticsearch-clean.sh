#!/usr/bin/env bash
set -e

# 读取配置
current_path=`cd $(dirname $0);pwd -P`
source $current_path/../env.sh
export tfpPath="${env_tfpPath}"

# 见文件夹
export elasticsearchPath=$tfpPath/software/elasticsearch
rm -rf $elasticsearchPath

echo 'elasticsearch清理成功'

