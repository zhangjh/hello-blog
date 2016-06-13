title: Nodejs使用session、cookie进行登录验证功能的实现
show: true
date: 2016-06-08 13:23:32
tags: [nodejs,session,cookie,登录验证]
categories: 技术人生
---
#### 背景
我在业余开发了一个[**藏经阁**](http://favlink.me)项目，它是一个完全针对用户定制化的网址收藏导航网站。因此用户注册和登录验证就成了最基本的需求和问题。
藏经阁使用了`Node Express`框架进行开发，因此本篇简单总结一下Node使用session和cookie进行登录以及权限验证的过程。

#### Cookie和Session
首先我们先来了解一下登录验证的原理。

众所周知，HTTP是一个无状态协议，所以客户端每次发出请求时，下一次请求无法得知上一次请求所包含的状态数据，如何能把一个用户的状态数据关联起来呢？

比如在淘宝的某个页面中，你进行了登录操作，当你跳转到商品页时，服务端如何知道你是已经登录的状态？

##### Cookie
首先产生了Cookie这门技术。Cookie是http协议的一部分，它的处理分为几步：
1. 服务端向客户端发送cookie
2. 浏览器保存cookie
3. 每次请求浏览器都将cookie发送给服务器

cookie虽然很方便，但存在一个很大的弊端，就是cookie中的数据可以在客户端被修改，这就存在很大的风险隐患。恶意用户可能会通过伪造cookie来假冒别人登录。
为了解决这个问题，就产生了Session。

##### Session
Session的数据是保留在服务器端的，session的运作通过一个`session_id`来进行。session_id通常存在cookie中，在express中，默认是`connect.sid`这个字段。当请求到来时，服务端检查cookie中保存的session_id，并通过session_id与服务器端的session数据关联起来。

因此，当你访问网页时，服务端随机产生了一个1024比特的字符串存在客户端的cookie中。当你下次访问时，cookie会带有这个字段，然后浏览器就知道你是上次访问过的某某啦。由于session数据是存储在服务器的，并且session_id是随机产生的，位数也足够多，所以也不用担心被人伪造。伪造的成功率比坐在电脑前写代码被突然天降的流星砸死的概率还低。

<!-- more -->

#### Express中使用cookie、session
在express中使用session要用到`express-session`这个模块，因此需要先安装依赖
##### 1. 安装模块
```
npm install express-session -d --save
```

##### 2. 使用方式
主要的方式就是`session(options)`,options参数主要有：
- name：设置cookie中，保存session的字段名称，默认为`connect.sid`
- store: session的存储方式，默认存在在内存中，也可以使用redis，mongodb等
- secret：通过设置secret来计算hash值并存在cookie中，防止篡改
- cookie：设置存放session_id的cookie的相关选项，默认为：
`(default: { path: '/', httpOnly: true, secure: false, maxAge: null })`
- genid: 产生一个新的session_id时，所用的函数
- rolling：每个请求都重设一个cookie，默认为false
- resave：即使session没有被修改也保存session值，默认为true。

##### 3. 实例
下面是我的使用方式，供参考：
###### 1. 引入express-session
```js
app.use(session({
  secret: "weird sheep",
  resave: false,
  saveUninitialized: true,
  cookie: {user:"default",maxAge: 14*24*60*60*1000}
}));
```
cookie默认设置为写入一个`user`字段，并且设置超时时间为14天。使用内存来保存session，比较方便毕竟存储的数据较少。

###### 2. 登录成功记录session
```js
users.login = function(mongoose){
	return function(req,res){
		var user = req.body.user,
		passwd = req.body.passwd;
		mongoose.find("user",{user:user},function(resu){
			//判断用户名密码，登录成功后写入cookie，session
			if(resu.length){
				if(passwd == decrypt(resu[0].passwd),secret){
					//登录成功
					req.session.user = user;
					req.session.isLogin = true;
					res.json({status: 0,msg: "登录成功."});
				}else {
					res.json({status: 1,msg: "密码错误！"});
				}
			}else {
				res.json({status: 1,msg: "该用户未注册，请先注册！"});
			}
		});
	};
};
```
以上有一些跟session无关的逻辑，如mongoose查询，密码解密等，后续文章里会做分享。主要关注登录成功后的操作逻辑，这里我将用户信息以及登录状态写入了session。

###### 3. 退出清理session

退出时记得清理session信息，清理使用`destroy`方法：
```js
users.logout = function(){
	return function(req,res){
		//清除session，cookie
		req.session.destroy(function(){
			res.clearCookie("user",{});
			res.cookie("isLogin","false");
			res.redirect("/");
		});
	};
};
```

###### 4. 登录验证
通过比对cookie中记录的user和session中记录的user来进行登录验证
```js
routes.index = function(mongoose){
	return function(req,res){
		var findPattern = {user: "default"};
		var cookie = req.headers.cookie || "";
		cookie = cookie.split(";");
		var cookieUser = "default",
			sessionUser = "default";
		//解析cookie获取cookieUser，略去
		if(req.session && req.session.user){
			sessionUser = req.session.user;
		}

		//防止伪造cookie登录
		if(cookieUser == sessionUser){
			findPattern = {user: sessionUser};
		}else {
			res.clearCookie("user",{});
			res.cookie("isLogin","false");
		}

		//查询数据库逻辑，略去
	};
};
```
当请求来临时，通过获取cookie中存放的user，然后对比session中存放的user，如果一致则表明cookie可信。否则清除cookie，不接受服务。

以上就是我的实际使用，是不是还挺简单的？
当然了，现在还有很多的第三库提供登录验证功能，比如`Passport,EverAuth`等，可以支持社会化登录，支持更多的网站登录，就不用自己维护登录系统啦。有空可以折腾一下~
