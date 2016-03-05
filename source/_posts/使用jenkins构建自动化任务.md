title: 使用jenkins构建自动化任务
show: true
date: 2016-03-05 15:11:33
tags: [jenkins]
categories: 技术人生
photos:
    - http://www.searchsoa.com.cn/upload/article/2011/2011-07-26-13-40-50.gif
---
#### 背景
jenkins是一个基于Java开发的持续集成工具，通常用于监控持续重复的工作，用于自动化测试领域再合适不过了。
本文是我利用jnekins来进行任务分发而做的一篇关于jenkins的学习使用初步入门。
通常在进行简单的远程任务调度上，我们可以使用`ssh`进行远程操作运行命令，但一旦机器增加（多机器调度）或者运行命令复杂（多参数任务）时，`ssh`就显得不那么方便了：命令写起来麻烦，参数的各种转义也很容易出错，可读性变差。这时候通过jenkins来管理多机器调度就显得很方便了。

#### 安装
###### 1. [依赖及安装](https://wiki.jenkins-ci.org/display/JENKINS/Installing+Jenkins)
以下以`Red Hat`发行版为例，其他安装方式可以戳标题链接查看
jenkins依赖Java7及以上版本，可以通过[java官网](http://www.java.com/en/download/)安装也可以通过命令行安装
以`yum`安装为例
`sudo yum install java`

然后安装jenkins：
```sh
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install jenkins
```

<!-- more -->

###### 2. 服务启停
安装完毕启动服务：
```sh
sudo service jenkins start/stop/restart
sudo chkconfig jenkins on          //添加开机启动
```
如果`Java`安装没有问题，这时候应该提示`Starting Jenkins OK`

服务启动后，打开`http://<serverhost>:<port>`即可看到jenkins的界面了，默认端口是`8080`。
![](http://ww2.sinaimg.cn/mw690/62d95157gw1f1m12mt99wj21hh0hbadq.jpg)

###### 3. 安装语言包汉化界面
毕竟不是学英语，汉化一下还是有必要的。
打开jenkins页面，进入`Manage Jenkins`->`Manage Plugins`安装下语言插件，搜索并安装`Locale Plugin`即可。
安装完毕后回到`Manage Jenkins`->`Congigure System`，在`Locale`设置项下将`Default Language`值设置为`zh_CN`。

#### 节点管理
安装完成后，jenkins的安装机器默认为`master`节点，此外我们还可以给jenkins定义额外的节点，这样就可以让jenkins将任务分发到不同的机器上去。
进入系统管理->管理节点->新建节点
![](http://ww1.sinaimg.cn/mw690/62d95157gw1f1m1hjz30kj21ha0lodi4.jpg)
在上图中的`Host`处填写要绑定的节点`IP`，`name`处为节点定义名字，设置jenkins的远程工作目录，并设置任务的并发数目（`# of executors`）。
添加完成以后如下图所示：
![](http://ww1.sinaimg.cn/mw690/62d95157gw1f1m1ljf2u5j216v070t9l.jpg)

#### 创建任务
返回jenkins页面，点击新建任务，弹出的选项中选择合适的项目类型，以自由风格为例：
大部分待填项都很明了，简单说明几处：
源码管理部分，可以设置一个代码库，一旦检测到代码库有变动则自动触发一次构建。支持`cvs`和`svn`不支持`git`。

如果需要严格设置任务需要在哪个机器上运行，可以勾选`Restrict where this project can be run`，然后在`Label Expression`中填入节点管理中给节点设置的`Label`名。即当时填写的`Name`字段。

我的需求是让jenkins分发并运行一段`shell`脚本，因此在`增加构建步骤`中添加`Excute shell`，在`Command`中填入我要运行的`shell`命令。由于脚本需要接收很多参数，因此还要勾选`参数化构建过程`，并`添加参数`选择`String parameter`，填写好参数名字并可以给参数设置默认值，在运行的命令中可以使用`${name}`方式调用传递进来的参数。

当然，还可以`增加构建后操作步骤`，如`收集运行报告`，`发送通知邮件`等功能，jenkins都提供了相应的插件来支持。

#### jenkins API
至此，一个jenkins任务就配置成功了，点击立即构建就可以run起来了。网上很多的教程文章也就到此为止了。。作为使用svn来作为触发器的当然是没问题了，而我并没有使用源码管理器，那么要怎么触发jenkins进行构建呢？我需要的是可以使用命令行的方式进行触发。好在jenkins还提供了相当强大的`REST API`。

首先，让我们来看一下如何通过命令行方式触发一个要接收参数的jenkins任务。
```html
http://<serverhost>:<port>/job/<jobName>/buildWithParameters?<key=value>&<key=value>...
```
发送一个上述`http`请求即可触发一次jenkins构建了。

然后，如果我们需要自动获取此次构建的日志，那么只有获取了此次构建的id号才行，jenkins任务每次构建，id都会自增一次，如何才能获取到呢？
```html
http://<serverhost>:<port>/job/<jobName>/api/json
```
请求上述`URL`，我们可以看到关于jenkins的很多信息：
![](http://ww1.sinaimg.cn/mw690/62d95157jw9f1m2y61besj20hc0lhtbg.jpg)

`nextBuildNumber`即为下一次构建的id号。知道了构建号，再通过
```html
http://<serverhost>:<port>/job/<jobName>/<buildNumber>/api/json
```
我们可以看到关于本次构建的很多信息：
![](http://ww1.sinaimg.cn/mw690/62d95157jw9f1m32trbbuj20fk0glac0.jpg)
`duration`:运行时间
`result`：运行状态

有了上述接口，我们通过自动化手段触发以及轮询任务状态都不是问题了。

有的人也许会觉得`记住API也太不人道了 && 如果我不用json接口怎么办`，其实在jenkins的页面上就提供了，看看右下角：
![](http://ww4.sinaimg.cn/mw690/62d95157gw1f1m3aib1ovj20cq01jwee.jpg)
点开就是API页面：
![](http://ww1.sinaimg.cn/mw690/62d95157gw1f1m3br27n5j20w40dd410.jpg)
不但有`json`的，还有`XML`和`python`的，是不是很良心？


