# Docker_Buildx_Danmuji

前往[Dockerhub](https://hub.docker.com/r/zzcabc/danmuji)  前往[Github](https://github.com/zzcabc/Docker_Buildx_Danmuji)

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/BanqiJane/Bilibili_Danmuji?label=danmuji&style=flat-square)](https://github.com/BanqiJane/Bilibili_Danmuji/releases/latest) [![Docker Image Version (latest by date)](https://img.shields.io/docker/v/zzcabc/danmuji?label=DockerHub&style=flat-square)](https://hub.docker.com/r/zzcabc/danmuji/tags?page=1&ordering=last_updated)

### 如果你发现上面图标版本不一致，请点击一下star，这样会触发自动构建镜像，即使你之后取消star

本项目使用Docker Buildx构建全平台镜像，支持linux/386、linux/amd64、linux/armv6、linux/armv7、linux/armv8、linux/ppc64le、linux/s390x框架，并使用openjdk:8u212-jre-alpine3.9作为底包

|构建方式|底包采用|Amd64镜像大小|
|--|--|--|
|源码构建|openjdk:8u212-jre-alpine3.9|110M|

使用GitHub Action中国时间 **0:00** 自动拉取[BanqiJane/Bilibili_Danmuji](https://github.com/BanqiJane/Bilibili_Danmuji)的源码进行构建Docker镜像，**但当源码版本和Docker镜像版本一致将不会构建镜像**，由源码构建时间大概6分钟

### [测试版本加入重启更新](https://github.com/zzcabc/Docker_Buildx_Danmuji#测试环境加入重启容器更新版本)

[B站用户西凉君君提供的Docker镜像地址](https://registry.hub.docker.com/r/xilianghe/danmuji)

# 使用方式

```
在2.4.9版本之后将取消inux/386、linux/armv6、linux/ppc64le、linux/s390x的镜像构建

如果你想拉取armv7的镜像，请使用 zzcabc/danmuji:latest-arm32 进行拉取

或者使用 zzcabc/danmuji:2.4.9-arm32 拉取指定版本

```

## DockerHub镜像(无自动更新 将`zzcabc/danmuji`改为`registry.cn-hangzhou.aliyuncs.com/zzcabc/danmuji`即可使用阿里镜像仓库)

```sh
docker run -d \
    --name danmuji \
    --dns=223.5.5.5 \
    -p 本机端口:23333 \
    -e JAVA_OPTS="-Xms64m -Xmx128m" \
    -v 本机路径:/danmuji/Danmuji_log \
    -v 本机路径:/danmuji/guardFile \
    -v 本机路径:/danmuji/log \
    zzcabc/danmuji
```

或者，你也可以使用

```sh
docker run -d \
    --name danmuji \
    -p 本机端口:23333 \
    zzcabc/danmuji
```

**默认拉取最新版的镜像，如果你想指定版本可以将`zzcabc/danmuji`改为`zzcabc/danmuji:2.4.9`**

## DockerHub镜像(有自动更新 将在2.4.9之后的版本加入)

容器采用获取官方的releases的danmuji.zip 解压并使用

releases下载使用国内的免费服务，可能说不定就挂了

但是可能无法正常更新版本，毕竟Github的网络条件你懂

当版本更新的时候，你只需要使用 `docker restart danmuji` 即可完成更新操作

**注意：我不敢保证自动更新的可靠性，因为目前为止我还没有测试过**

将`zzcabc/danmuji:autoupdate`改成`registry.cn-hangzhou.aliyuncs.com/zzcabc/danmuji:autoupdate` 即可使用阿里镜像仓库

```sh
docker run -d \
    --name danmuji \
    --dns=223.5.5.5 \
    -p 本机端口:23333 \
    -e JAVA_OPTS="-Xms64m -Xmx128m" \
    -v 本机路径:/danmuji/Danmuji_log \
    -v 本机路径:/danmuji/guardFile \
    -v 本机路径:/danmuji/log \
    zzcabc/danmuji:autoupdate
```

## docker-compose方式

**确保你安装了docker-compose，并且可以使用**

使用下面命令获取本项目的docker-compose

可能因为CDN的原因无法获取

`wget https://cdn.jsdelivr.net/gh/zzcabc/Docker_Buildx_Danmuji@main/docker-compose.yaml`

之后通过nano或者vim命令修改docker-compose.yaml

最后使用 `docker-compose up -d` 命令启动

你可以使用docker-compose启动多个容器

添加多个service
```yaml
  danmuji: # 变更命名
    image: zzcabc/danmuji
    container_name: danmuji # 变更容器名
    restart: always
    privileged: true
    environment:
      TZ: Asia/Shanghai
      JAVA_OPTS: "-Xms64m -Xmx128m"
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "23333:23333" # 变更端口
    volumes:
      - /danmuji/Danmuji_log:/danmuji/Danmuji_log
      - /danmuji/guardFile:/danmuji/guardFile
      - /danmuji/log:/danmuji/log
    logging:
      driver: json-file
      options:
        max-size: "1m"
        max-file: "2"
```

# 更新容器方式

## 测试环境加入重启容器更新版本

**仅用于抢先体验，之后会在正式版本加入**

目前仅支持Amd64，Arm64

```sh
docker run -d \
    --name danmuji \
    --dns=223.5.5.5 \
    -p 本机端口:23333 \
    -e JAVA_OPTS="-Xms64m -Xmx128m" \
    -v 本机路径:/danmuji/Danmuji_log \
    -v 本机路径:/danmuji/guardFile \
    -v 本机路径:/danmuji/log \
    zzcabc/danmuji-test
```

**当版本更新的时候，你只要使用`docker restart danmuji`**

## 方案一——手动更新

 - 停止并删除容器
 - 拉取最新的镜像
 - 启动容器

## 方案二——自动更新
 
 - 使用 Watchtower 镜像，具体方式请百度

# 映射路径说明

此说明对应Docker容器内

| Docker运行参数 | 说明 |  
| --- | --- |
| `run -d` | 后台的方式保持运行 |
| `--name danmuji` | 设置Docker容器名称为danmuji(非必要设置) |
| `--dns=223.5.5.5` | Docker容器使用阿里DNS |
| `JAVA_OPTS="-Xms64m -Xmx128m"` | 限制内存(**可能无效果**) |
| `/danmuji/Danmuji_log` | 弹幕姬保存弹幕文件夹(非必须映射) |
| `/danmuji/guardFile` | 弹幕姬上舰私信文件夹(非必须映射) |
| `/danmuji/log` | 弹幕姬日志文件夹(非必须映射) |

### ~~注意：本项目会拉取releases最新的danmuji.zip构建镜像,因包内名称为BiliBili_Danmuji-版本号beta.jar,如上游发生变化，则无法成功构建镜像~~

# TODO

- [x] 添加判断，如果releases的版本与DockerHub的版本一致，则不重新构建镜像

- [x] 每日定时构建镜像，当上有发布新版本最长也就时隔24小时更新

- [x] 使用源码构建镜像，解决上述注意事项(但我不会！！！！)  上面三项同时解决

- [x] 将镜像上传阿里镜像仓库
