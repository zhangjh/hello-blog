title: 记一次aws虚机mongodb数据库被黑及后续处理
show: true
date: 2017-02-04 15:49:09
tags: [aws,mongodb,备份,安全防护]
categories: 技术人生
---
# 1. 背景

我的[藏经阁网站](http://favlink.me)是部署在aws的虚拟机上的，年前一次访问的时候发现被黑掉了，数据全丢了不说，还被注入了勒索比特币的信息。
逗比的是，年前一直没来及处理，年后过来准备处理时，发现原来被黑过一遍的数据库又被黑了第二遍！勒索比特币数值也从0.1变成了0.2。。
![](http://wx3.sinaimg.cn/mw1024/62d95157gy1fcdi9hiv0jj212d0753z7.jpg)

比特币勒索病毒现在非常嚣张，由于比特币交易网络的特殊性，基本上查处不到犯罪分子，中了基本上只能认栽。

# 2. 安全防护

布置在外网上的服务器，如果不进行安全防护，基本就是暴露于危险环境下的肉鸡。之前购买的搬瓦工虚拟主机也是几次被用来发送恶意邮件。
经过这次数据被黑的惨痛教训，急需补上相应的安全防护。几点简单的防护，可以提升我们的服务免于黑客的攻击。

<!-- more -->

### 1. 修改SSH端口
```
cd /etc/ssh/
vi sshd_config
//修改其中的Port字段，重启ssh服务
/etc/init.d/sshd restart
```
针对aws主机，由于aws的登录都需要指定的`key.pem`文件，基本上是不存在这种被恶意远程登录的问题。

### 2. 数据库防护
这里只说下mongodb数据库的防护。
```
//以绑定ip并且修改默认端口的方式启动
./mongod --port xxx --bind_ip 127.0.0.1 [其他参数]
```
这种启动方式指定了mongodb只能本机连接，并且修改了默认端口号，防止恶意连接。
缺点就是我们想通过图形客户端去连接mongodb也不行了，如果有固定ip的话可以在bind_ip中增加可信ip以逗号分隔。

### 3. 安全组设置
针对aws主机特有的，需要设置一下安全组。
在aws控制台找到安全组设置，修改设置只开启提供对外服务的端口，封禁其他一切端口。
如，开放80端口的http流量，443的https的流量，ssh服务对应的端口，ftp对应的端口等。其他不在服的端口封禁掉，可以极大地防止恶意连接。

# 3. 备份机制

除了上述防护工作，线上数据库的备份恢复机制也要相应的建立起来。
以我的藏经阁网站来说，现在的数据量还不多，可以考虑每周做一次全量备份。
以下是基本的备份恢复脚本命令：
```
#!/bin/bash
## 定期备份mongodb数据库
## mongodb启动命令： ./mongod -h xx --port xx --bind_ip xxx --dbpath xx --logpath xx

MODE=$1
if [ "X$MODE" == "X" ];then
  MODE="bak"
fi

MONGO_DIR="/home/`whoami`/mongodb"
DB_NAME="xx"
DB_PORT="xxx"
BAK_BASE="xxx"
CURTIME=`date +%Y%m%d`
BAK_NAME=${BAK_BASE}${CURTIME}

if [ "$MODE" == "bak" ];then
  echo "开始备份..."
  cd ${MONGO_DIR}/bin
  ./mongodump --port ${DB_PORT} -d ${DB_NAME} -o ${BAK_NAME}
  if [ $? -ne 0 ];then
    echo "备份失败"
    exit 1
  fi
  echo "备份成功"
  exit 0
fi

if [ "$MODE" == "restore" ];then
  echo "开始恢复..."
  cd ${MONGO_DIR}/bin
  ./mongorestore --port ${DB_PORT} -d ${DB_NAME} --directoryperdb $2
  if [ $? -ne 0 ];then
    echo "恢复失败"
    exit 1
  fi
  echo "恢复成功"
  exit 0
fi
```
设置定时任务：
```
0 1 * * mon cd /home/ubuntu/favlinks/ && sh -x bak_restore.sh  
//每周一1点运行备份任务
```

当数据量变大以后，可以考虑使用[mongobackup](http://dl.nosqldb.org/mongobackup_user_guide_zh_CN.pdf)进行增量备份。
