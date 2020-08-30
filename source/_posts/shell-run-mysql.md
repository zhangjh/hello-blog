title: Linux Shell中运行mysql命令
show: true
date: 2017-03-14 18:08:27
tags: [shell,mysql]
categories: 技术人生
---

## 背景
我们经常需要批量地执行很多mysql命令，这时候如果直接在mysql终端下执行，效率很低。如果借助Shell来进行自动化地操作，则会大大方便我们操作。这里就记录一下我用来进行数据库表重建的方法。

## 准备mysql脚本
首先我们要准备相应的mysql命令脚本，以便shell调用。
如：
```
DROP TABLE IF EXISTS `attachment`;
CREATE TABLE `attachment` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `init_name` varchar(100) NOT NULL,
  `file_path` varchar(100) NOT NULL,
  `gmt_create` datetime NOT NULL DEFAULT now(),
  `gmt_modified` timestamp NOT NULL DEFAULT now(),
  `creator` varchar(100) NOT NULL DEFAULT 'system',
  `modifier` varchar(100) NOT NULL DEFAULT 'system',
  `is_deleted` char(1) NOT NULL DEFAULT 'N',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=460 DEFAULT CHARSET=utf8;
```
正常写mysql命令即可。

<!--more-->

## 编写Shell脚本
接着我们编写Shell脚本调用sql，我们要知道可以在Shell中使用
```
mysql <<EOF
EOF
```
的方式来运行mysql命令，在mysql段中还可以使用`source` sql命令来运行sql。

由于我的建表sql命令是导出的，只有建表命令，没有选择数据库的命令，因此正式使用之前还需要进行一点修改。

我们可以把要批量运行的sql命令按照任务的不同分放在不同的文件中，然后使用Shell统一调用。
如：
```
#!/bin/bash
SQL_DIR="./sqlinit"
cd ${SQL_DIR}
ls *.sql | while read line;
do
    mysql -uroot << EOF
        ## 选中要处理的数据库
        USE db_name; 
        source $line
EOF
done
```

简单的sql命令，可以使用`mysql -uxx -pxx -e "sql cmd"`来运行，其他的方式就不多说了，文中这种应该算是最好用的方式了。
