title: iptables端口转发
date: 2015-07-14 20:26:20
tags: [iptables,端口转发]
categories: 技术人生
show: true
---
#背景
我有个网站部署在我linux服务器的自己账户下，我们都知道，如果要以1000以下的端口启动服务需要root权限。而我又没有root权限。
所以我的网站应用启动在8090端口上，然而访问的时候url带端口的方式看起来很山寨，很土贼，能不能不带端口访问到我的服务呢？

#iptables端口转发
使用linux的iptables可以设置端口转发，于是百度查了下，可惜试了很多条都没有生效。于是将我尝试可用的做法记录已备忘。

<!--more-->

- 机器环境
`uname -a`
> Linux xxx(mac name) 2.6.32-220.23.2.ali878.el6.x86_64 #1 SMP Mon Jan 28 17:12:52 CST 2013 x86_64 x86_64 x86_64 GNU/Linux

- 查看当前iptables状态
`sudo service iptables status`
> Chain PREROUTING (policy ACCEPT)
>
> Chain POSTROUTING (policy ACCEPT)
> num  target     prot opt source               destination         
>
> Chain OUTPUT (policy ACCEPT)
> num  target     prot opt source               destination        

- 配置端口转发
将本机80端口的访问请求转发到8090端口上
`sudo /sbin/iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8090`

- 保存配置
`sudo service iptables save`
> iptables: Saving firewall rules to /etc/sysconfig/iptables:[  OK  ]

- 重启iptables[可能不需要，确保]
`sudo service iptables restart`
> Flushing firewall rules:                                   [  OK  ]
> Setting chains to policy ACCEPT: nat                       [  OK  ]
> Unloading iptables modules:                                [  OK  ]
> Applying iptables firewall rules:                          [  OK  ]

- 再次查看当前iptables状态
确认是否多了下面这条内容：
> Table: nat
>Chain PREROUTING (policy ACCEPT)
> num  target     prot opt source               destination         
> 1    REDIRECT   tcp  --  0.0.0.0/0            0.0.0.0/0           tcp dpt:80 redir ports 8090 


试试看是不是可以不加端口访问了呢？
