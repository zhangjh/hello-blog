title: 从零开始，教你写留言板（二）
show: true
date: 2018-04-22 20:13:46
tags: [留言板,评论]
categories: 技术人生
---

<i class="iconfont" style="color: #1296db">&#xe65d;</i>  9/53，每周一篇博，坚持！

[续上篇](http://zhangjh.me/2018/04/15/write-comment/)

上一篇我们主要讲了一下一个评论系统的基本设计思路和数据库的设计，这篇我们主要讲一下如何使用Node.js来构建评论系统所需要的后端服务。

## 第二部分 搭建后端应用
#### Express框架介绍
这里我们使用Node.js的Express框架来构建相应的后端应用，相应的准备工作大致包括Node.js环境的安装，npm的安装，MongoDB的安装等，不赘述。

首先我们需要安装Node下的Express框架：
```
npm i express-generator -d -g
```
上述命令为我们安装了Express框架的生成器，我们只需调用：
```
express comment
```
即可生成一个comment的Express框架工程的目录。
然后安装工程依赖：
```
cd comment
npm install
```
依赖安装完成后，该目录即已完成一个Express工程的初始化了，启动后就是一个WEB服务器了。
```
npm start
```
该命令在本地的3000端口启动了一个WEB服务器，可以通过访问：http://localhost:3000来测试下是否正常。

以上只是一个简单的Node.js下Express框架的介绍，详细可以查看[官方文档](http://expressjs.com/en/starter/generator.html)。

<!--more-->

#### 开始编码
这里我们假设开发环境已经部署完成，下面开始本篇的正式部分。

1. 数据库配置
	按照上篇的分析，我们需要先建立数据库配置，在comment下建立conf目录并创建config文件如下：
	```
	// mongoose config
	var mongooseClient = require('mongoose-client');
	var mongooseClientInstance = new mongooseClient({
	  DB_IP: 'localhost',
	  DB_PORT: '20172',
	  DB_NAME: 'comment',
	  schema: {
	    infos: {
	      name: { type: String },
        email: { type: String },
        website: { type: String },
        content: { type: String },
        url: { type: String },
        replyId: { type: String },
        isDeleted: { type: Boolean, default: false},
        gmtCreate: { type: Date, default: Date.now},
        readed: { type: Boolean, default: false}
			}
		}
	});

	module.exports = mongooseClientInstance;
	```

2. 数据读写接口
	根据上篇的分析，我们需要评论数据的保存、查找、删除、更新等接口。这里以保存和查找接口为例，详细的可以参见[Git上的项目源码](https://github.com/zhangjh/comment)。
	我们在项目routes目录下创建comment.js文件，用来编写评论接口，该文件一会儿会作为路由文件供web服务器使用。
	保存接口我们使用POST方式来写，因为需要传递的数据还是比较多的。
	这个接口我们需要接收前端传递的姓名、邮箱、网站、评论内容、文章的url以及如果是回复的他人的评论还有评论的ID。
	POST收集参数的方式如下：
	```
	router.post('/save',function(req,res){
		let name = req.body.name;
		let email = req.body.email;
		let website = req.body.website;
		let cotent = req.body.content;
		let url = req.body.url;
		let replyId = req.body.replyId;
	});
	```
	保存前需要对数据进行一定的校验，以保证程序的健壮性。并且为了防止恶意提交，需要加上一定的校验机制，如设置连续提交需要间隔十秒以上。
	```
	if(!name){
	    res.send({
	    status: false,
	        errorMsg: "大侠请留名"
	    });
	}
	if(!email){
	    res.send({
	        status: false,
	        errorMsg: "留个邮箱吧，一有回复我就提醒你"
	    });
	}
	if(!content){
	    res.send({
	        status: false,
	        errorMsg: "大侠，逗我呢？一个字不留咋提交啊"
	    });
	}
	```
	将数据整合后，利用mongooseClient封装的接口插入数据库中：
	```
	// 此处collection为mongodb表名，这里未infos，可回看数据库设置
	mongooseClientInstance.find(collection,{name: name, url: url},function(ret){
	    if(ret.status){
	        if(ret.data.length){
	            // 此处为限制评论频率逻辑，同一人同一文章两次评论间隔需大于十秒
	            let createTime = ret.data[0].gmtCreate;
	            if(Math.abs(createTime - new Date()) < 10000){
	                return res.send({
	                    status: false,
	                    errorMsg: "大侠手速惊人，练过弹指神通？"
	                });
	            }else {
                  mongooseClientInstance.insert(collection,data,function(ret){
	                    return res.send(ret);
	                });
	            }
	        }else {
	            mongooseClientInstance.insert(collection,data,function(ret){
	                return res.send(ret);
	            });
	      }
	    }
	},{gmtCreate: -1});
	```

	同样地，评论数据读取接口要更为简单一些，以查询所有评论数据为例，只需要构造查询条件然后交给封装好的mongooseClient查询，将结果数据返回即可：
	```
	router.get('/queryAll',function(req, res, next){
	  mongooseClientInstance.find(collection,{isDeleted: false},function(ret){
	    return res.send(ret);
	  });
	});
	```

	完整的接口代码，可以[点击查看](https://github.com/zhangjh/comment/blob/master/routes/comment.js)

3. 编写HTTP接口
	完成上一步之后，数据库的数据读写算是可以了，但如何编写对应的HTTP接口以便可以访问到这些数据库读写接口呢？

	Express下，项目工程目录的app.js定义了各个接口的路由方式。我们只需新增几个我们所需的接口并绑定到相应的路由方法上即可。如新增一个评论数据保存HTTP接口，对应的操作方法为路由文件中刚刚定义的保存接口：
	```
	// 首先我们需要在app.js中引入刚刚新建的路由文件
	const commentRouter = require('./routes/comment');
	// 然后再设置一下接口的跨域访问权限，这里我设置的是所有接口都可以被http://zhangjh.me这个域访问
	app.all('*', function(req, res, next) {
	  res.header("Access-Control-Allow-Origin", "http://zhangjh.me");
	  res.header("Access-Control-Allow-Headers", "X-Requested-With");
	  res.header("Access-Control-Allow-Methods","PUT,POST,GET,DELETE,OPTIONS");
	  res.header("X-Powered-By",' 3.2.1')
	  res.header("Content-Type", "application/json;charset=utf-8");
	  next();
	});
	// 最后我们关联一下接口的路由方式，这句话告诉应用所有请求/comment/*的请求均有commentRouter路由文件来承接
	app.use('/comment',commentRouter);
	```
	上述设置之后，如果我要获取一个GET请求"/comment/queryAll"，服务器将从comment.js中查找是否有定义"/queryAll"的get请求。这里正好访问到我们上一步中编写的查询所有评论数据的接口并将数据返回。

	设置完成以后，重启应用，试试访问我们新编写的接口是否已经生效了。


这一篇主要讲了如何利用Node.js的Express构建评论数据的后端读写接口应用，在Express下编写纯粹的后端HTTP接口还是非常简便的。
下一篇我再讲一下有了评论接口后，如何在Hexo博客下进行评论部分的前端渲染，可以看一下我现在评论部分的效果，是仿的畅言的样式，并且比畅言更佳的地方是更好的适配了移动端，不会存在畅言那样在移动端屏宽不够的情况下撑开页面的情况。我们下篇博文继续说一下评论系统的前端交互实现。
