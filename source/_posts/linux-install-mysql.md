title: Linux下安装mysql
show: true
date: 2017-03-14 10:22:33
tags: [mysql]
categories: 技术人生
---
# 背景
安装Mysql不知道安装了多少次了，但是每次装的时候都要重新查看文档，每次又会遇到不一样的问题。还是记录一下安装步骤吧，省的每次都要重新翻文档了。

# 安装步骤
以安装mysql5.6版本为例，其他版本可以下载官网对应版本，然后查看附带的INSTALL文档。
<!--more-->

1. 下载
`wget http://cdn.mysql.com/archives/mysql-5.6/mysql-5.6.26-linux-glibc2.5-x86_64.tar.gz `

2. 解压并改名
`tar -xvf mysql-5.6.26-linux-glibc2.5-x86_64.tar.gz && mv mysql-5.6.26-linux-glibc2.5-x86_64 mysql`

3. 创建用户组
```
#建议将mysql安装在/usr/local目录
mv mysql /usr/local
cd mysql
sudo groupadd mysql
sudo useradd -r -g mysql mysql
```

4. 修改权限
```
sudo chown -R mysql:mysql *
```

5. 初始化数据库
	```
	sudo scripts/mysql_install_db --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data --user=mysql
	#也可以事先指定配置文件
	cp support-files/my-default.cnf my.cnf
	#修改my.cnf中basedir地址为/usr/local/mysql
	vi my.cnf
	sudo scripts/mysql_install_db --user=mysql
	```

6. 启动数据库
  `sudo bin/mysqld_safe &` 
  如果启动失败，可以去data目录下查看err结尾的错误日志，查看错误信息

7. 添加mysql为系统服务
  `sudo cp support-files/mysql.server /etc/init.d/mysql`
  之后就可以使用`/etc/init.d/mysql start|stop|restart`来管理mysql了

8. 添加环境变量
  ```
  sudo vi /etc/profile
  #修改PATH=$PATH:/usr/local/mysql/bin
  source /etc/profile
  ```
  添加环境变量之后即可任意目录下直接输入mysql进行连接而不用在mysql/bin目录下了。

9. 连接mysql
`mysql -uroot -p #新安装没有密码，直接回车连接`

10. 设置密码和用户
```
#如给root添加密码
mysqladmin -u root password "new password"
#添加新用户
mysql -u root -p
mysql> insert into mysql.user(Host,User,Password) values ("localhost","name",password("passwd"));
```

# 常见错误
启动过程中报错可以去日志查看，然后针对性的搜索。这里列一下我安装过程中遇到的错误。

#### Can't open the mysql.plugin table. Please run mysql_upgrade to create it
这个原因是在运行`mysql_install_db`初始化数据库的过程中出了问题，基本上是配置没有对应上。可以修改配置或者直接传递basedir和datadir，然后重新运行命令解决。


