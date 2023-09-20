# 自动部署脚本说明

[使用文档链接](./user_guide.md)

## 进度及TODO
1. jdk
    - [x] 安装
2. zookeeper
    - [x] 单节点
    - [x] 集群
3. redis
    - [x] 编译
    - [x] 单节点部署、启停
    - [x] 集群哨兵
4. tomcat
    1. 应用
        - [x] 应用安装
        - [x] 应用启停
        - [x] 应用更新
    2. 特殊情况
        - websys https (需手动配置)
        - [x] dubbo-monitor 
        - [x] dubbo-amdin
    3. 全部批量
        - [x] 安装
        - [x] 启停
        - [x] 更新
5. efk
    - [x] elasticsearch
    - [x] kibana
    - [x] filebeat
6. skywalking
    - [x] 主程序安装
    - [x] 主程序启停
    - [x] 探针安装
7. ftp
    - [x] 安装（试验失败，需手动安装）
    - [ ] 启停
8. linux （这个手动检查）
    - [x] 命令检查
    - [ ] 命令自动补全
    - 中文字体
    - ntp、时区
9. nginx 1.16.1
    - [x] 安装
    - [x] 启停
    - 配置 (需配合websys手动配置)
10. dsp
    - 手动配置
11. otter
     - 数据库强相关，手动配置
12. 校验
     - [x] http端口校验
     - [ ] 文件完整性校验（这个很有必要，要不然折腾老半天遇到很诡异的错，是因为压缩包不完整导致的）

## 问题
1. 一些比较基础的，比如各主机时间同步、时区设置、中文字体，他们给的基础系统是不是已经提供？
    1. 时间同步
    2. 时区设置
        - 这两个文档有要求提供，就不做了
2. 用户权限
    1. 这里默认普通用户，
    2. 有sudo权限，可以免密sudo
    3. 这个用户能免密ssh

## 操作系统相关性
### 操作系统大概无关
1. jdk，及java应用
2. elasticsearch
3. filebeat
4. kibana
5. skywalking
6. zookeeper

### 操作系统版本相关
1. 中文字体
2. redis
3. linux软件：wget zip unzip net-tools gcc ntp

## 注意事项
### dubbo-admin、dubbo-monitor
需要先在war包里面把zookeeper地址改好，登录密码也在这里配置。

dubbo-admin配置文件的位置：
```
WEB-INF/dubbo.properties
```
dubbo-monitor配置文件的位置：
```
WEB-INF/classes/application.properties
```

## 架构
1. 其中选一台服务器做操作服务器
    1. 起http文件服务（可以全部用scp替代）
    2. 固定目录：
        1. 脚本
        2. 中间件安装包
        3. 应用更新包
            - 暂定为应用在新的文件夹
            - 这个方案之后再定
2. 需部署端（非操作服务器）
    1. 起ssh服务
    2. wget/scp下载安装包、更新安装包
    3. wget/scp更新环境信息、脚本
    4. ssh触发远程脚本执行
  

缺陷： ssh 用户需要做免密处理




