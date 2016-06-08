title: mongodb数据备份与恢复
show: true
date: 2016-06-08 12:45:22
tags: [mongodb,备份,恢复]
categories: 技术人生
---
#### MongoDB数据备份
##### 1. 语法
```
mongodump -h dbhost -d dbname -c collection -o dbdirectory
```
- -h: mongodb所在服务器地址
- -d: 需要备份的数据库实例名称，如test，如果不指定将备份所有的数据库
- -c: 指定需要备份的数据表，如果不指定备份所有collection
- -o: 数据备份存放的路径，如不存在需要提前建立，如：./backup，备份完成后备份数据会被存放在./backup/test

##### 2. 示例
```
mongodump -d favlink -o ./favlinks
```
上述命令将本地数据库的favlink实例备份到当前路径的favlinks目录下，备份完成后的数据如图显示：
![](http://ww4.sinaimg.cn/mw690/62d95157gw1f4nqfens68j20np01ydg6.jpg)

<!-- more -->

#### MongoDB数据恢复
##### 1. 语法
```
mongorestore -h dbhost -d dbname -c collection --directoryperdb dbdirectory
```
以上参数同备份参数，`--directoryperdb`指明需要恢复的数据路径，如上述备份，恢复的时候需要指定为：`./backup/test`
更多的参数可以通过`--help`查询。

##### 2. 示例
```
mongorestore -d favlink --directoryperdb ./favlinks
```
上述命令将保存在当前路径下的favlink数据库恢复到本机mongodb数据库里。恢复完成后如图显示：
![](http://ww1.sinaimg.cn/mw690/62d95157gw1f4nqrkd0ddj20sr069mzf.jpg)
