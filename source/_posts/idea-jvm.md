title: idea调整jvm参数加快启动编译速度
show: true
date: 2016-12-08 10:09:57
tags: [idea,jvm]
categories: 技术人生
---
## 背景
最近换了个团队，被逼搞起了java+react。在使用webpack打包编译react代码或者使用maven启动java的时候，IntelliJ IDEA卡的跟孙子似的，人生就在这一分一秒的等待中度过，真是让人焦虑的不行。可是我大Think carbon x1可是8G的大内存机器，怎么会这么慢呢。。一开始听说idea就是内存杀手的我还以为是正常的，直到又一次项目直接起不来，并且还报错内存不够用，这真是让人不能接受了，8G的内存起个java说内存不够用？于是听说过jvm参数一说的我怀疑了下是不是idea设置的不太对。。

## JVM参数
设置JVM内存的参数有四个：
1. -Xmx    Java Heap最大值，默认为物理内存的四分之一
2. -Xms    Java Heap初始值，最好将-Xmx和-Xms设置为相同值，避免垃圾回收时由于差值造成时间开销增大
3. -Xmn    Java Heap Young区大小，最好保留默认值
4. -Xss    每隔线程Stack的大小，最好保留默认值

## 修改Idea JVM参数
打开idea的安装目录，切换到bin目录下，找到jvm的参数配置文件，32位程序为`idea.exe.vmoptions`，64位位`idea64.exe.vmoptions`
我的打开后看了下，-Xmx和-Xms默认都是设置了128m。。尼玛，什么年代了，给分配128兆内存，怪不得卡成翔。
果断调整设置分配4096m，其他保持默认不修改。

```
	-Xms4096m
	-Xmx4096m
	-XX:ReservedCodeCacheSize=240m
	-XX:+UseConcMarkSweepGC
	-XX:SoftRefLRUPolicyMSPerMB=50
	-ea
	-Dsun.io.useCanonCaches=false
	-Djava.net.preferIPv4Stack=true
	-XX:+HeapDumpOnOutOfMemoryError
	-XX:-OmitStackTraceInFastThrow
	-Xverify:none                  //关闭Java字节码验证，从而加快了类装入的速度，并使得在仅为验证目的而启动的过程中无需装入类，缩短了启动时间。
```

如果想提高启动速度，还可以将idea打开时默认加载的插件去掉一些自己不用的。路径是`File->Settings->Plugins`，勾掉自己不常用的。

关闭重启idea，那酸爽，没系安全带的我差点翻了车。。再试一下webpack打包，那是飞一样的感觉~~	
