title: Maven仓库类型总结
show: true
date: 2018-03-03 21:09:46
tags: maven
categories: 技术人生
---
<i class="iconfont" style="color: #1296db">&#xe65d;</i>  2/53，每周一篇博，坚持！

#### Maven仓库类型
Maven有几种不同的仓库类型：
1. 中央仓库，中央仓库是由Maven官方提供维护的资源仓库
2. 私有仓库，一般私有仓库由企业自己维护，不对外开放，和中央仓库一起可以称之为远程仓库。
3. 本地仓库，本地仓库顾名思义就是开发者自己本机所处的仓库环境，通常是自己打包的jar包目录。
配置的方式是修改maven配置文件的"repositories"部分。
```
<!--中央仓库默认为http://repo1.maven.org/maven2-->
<!--nexus私服设置-->
<repositories>
	 <repository>
		<id>central</id>
		<url>http://mvnrepo.alibaba-inc.com/mvn/repository</url>
	</repository>
</repositories>
<!--本地仓库-->
<!--默认仓库默认是在${user.home}/.m2/repository下-->
<localRepository>/path/to/local/repo</localRepository>
```

<!--more-->

#### Maven仓库加载机制
当我们在项目pom依赖里配置好了依赖的jar包三元组后，Maven首先会去本地仓库查询是否有对应依赖，如果查询到则直接开始编译，否则就去查询私服，如果查询到则返回开始编译，否则继续去查询中央仓库，如果还没有查到则报依赖不存在错误。
![](http://wx4.sinaimg.cn/mw690/62d95157gy1fp00ndn1y3j20hs06z0tc.jpg)

#### 使用本地仓库调试
我们在实际项目开发过程中，经常会依赖其他应用提供的jar包服务。通常的流程是被依赖方更新后发布提交到公司的私服，然后应用依赖方再去下载对应版本的依赖。如果依赖方同时也是自己维护的应用时，在调试阶段频繁发布jar包版本会造成开发效率的低下，此时我们就可以借助本地仓库来提高开发效率。
我们开发完依赖的程序逻辑后，在本地进行打包，然后依赖方使用本地打包版本进行测试，直到测试通过再进行依赖包的正式发布。
```
// maven本地打包
mvn install -Dmaven.test.skip
// 运行上述命令后，maven就将按照应用工程pom中定义的三元组打包成本地jar存储在本地仓库中
// 如果是非maven工程，也可以手工指定三元组信息打包
mvn install -Dfile=xxx -DgroupId=xxx -DartifactId=xx -Dversion=xx -Dpackaging=jar
// 然后就可以在maven工程中指定pom依赖了
```


