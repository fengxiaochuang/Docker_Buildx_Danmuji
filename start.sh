#!/bin/bash
LATEST_VERSION=$(curl -sX GET "https://api.github.com/repos/BanqiJane/Bilibili_Danmuji/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]')

# 判断旧的版本时候存在
if [ ! -f "/danmuji/old" ];then
    # 不存在说明是第一次启动容器
    # 将当前版本写入old文件
    echo ${LATEST_VERSION} > old
    # 下载版本
    wget https://github.do/https://github.com/BanqiJane/Bilibili_Danmuji/releases/download/$(cat old)/danmuji.zip
    # 解压最新版本
    unzip danmuji.zip
    # 将BiliBili_Danmuji-版本beta.jar 移动至/danmuji文件夹下，并重命名为danmuji.jar
    cp $(find ./ -name "*.jar") danmuji.jar
    # 删除下载的压缩文件
    rm -rf danmuji
else
    # 存在说明重启过容器
    # 将重启时的版本写入新的文件
    echo ${LATEST_VERSION} > new
fi

if [ -f "/danmuji/new" ];then
    # 判断版本是否不一样
    if [$(cat old) != $(cat new)];then
        # 不一样，获取最新的版本
        # 下载新的版本
        wget https://github.do/https://github.com/BanqiJane/Bilibili_Danmuji/releases/download/$(cat new)/danmuji.zip
        # 解压最新版本
        unzip danmuji.zip
        # 将BiliBili_Danmuji-版本beta.jar 移动至/danmuji文件夹下，并重命名为danmuji.jar
        cp $(find ./ -name "*.jar") danmuji.jar
        # 删除下载的压缩文件
        rm -rf danmuji
        # 并将new改名为old
        mv /danmuji/new /danmuji/old
    fi
fi

# 运行弹幕姬
java ${JAVA_OPTS} -jar danmuji.jar