title: 从零开始，教你写留言板（三）
show: true
date: 2018-04-30 23:54:46
tags: [留言板,评论]
categories: 技术人生
---

<i class="iconfont" style="color: #1296db">&#xe65d;</i>  10/52，每周一篇博，坚持！

[续上篇](http://zhangjh.me/2018/04/22/write-comment2/)

上一篇里我们主要讲了评论系统的后端应用搭建及主要评论接口的实现，这篇里继续讲一下后端应用里其他一些逻辑的实现，如评论提醒功能。
前端的交互逻辑和渲染放到下一篇里进行。

## 第三部分 后端应用的其他功能逻辑实现

为了给评论系统提供更好的体验，我们有必要给评论系统添加上消息提醒，这里存在两种场景：
一个是当有评论被回复时，评论者应该收到提醒消息，
二是若评论时选择了记住个人信息，那么在同一个人再次访问时如果有未读的评论消息应该在页面上显示出提醒框。

<!--more-->

我们先来看第一个功能：

#### 评论回复提醒
当用户发表评论时，收集的信息里包括了邮箱，这里邮箱就是用来接收评论回复的提醒，将被评论的文章url放在消息里发给被评论者，方便后续查看交互。
这里主要的功能就是发送邮件，在Node生态下已经有完善的工具支持，这里我们使用[nodemailer](https://nodemailer.com/about/)。

1. 安装
```
npm i nodemailer --save
```

2. 配置
使用nodemailer发送邮件之前，我们需要做下简单配置，我们将配置封装成函数如下：
```
const nodemailer = require('nodemailer');

const sendMail = function(to,subject,text,html,cb){
	nodemailer.createTestAccount((err, account) => {
		let transporter = nodemailer.createTransport({
			// 这里以我的smtp 126服务为例
			host: 'smtp.126.com',
			port: 465,
			secure: true, // true for 465, false for other ports
			auth: {
				user: "填写邮箱",
				pass: "填写密码"
			}
		});

		// setup email data with unicode symbols
		let mailOptions = {
			from: '需要跟上面的邮箱一致',
			to: to, // 支持多个，逗号分隔
			subject: subject, // 主题
			text: text || "", // 文本内容
			html: html || "" // html 内容
		};

		// send mail with defined transport object
		transporter.sendMail(mailOptions, (error, info) => {
			if (error) {
				console.log(error);
			}
			// 将错误信息传递给回调函数
			if(cb)cb(error,info);
		});
	});
};
module.exports = sendMail;
```

3. 使用封装的函数发送提醒邮件
我们先自行封装一个用来发送邮件的HTTP接口，方便使用：
```
// 将此内容放置在前文的router.js路由文件中
// 封装的sendmail函数放置在../conf/sendmail.js中
const sendmail = require('../conf/sendmail');

router.post('/sendMail',function (req, res, next) {
	let mail = req.body.email;
	let url = req.body.url;
	let subject = req.body.subject;
	let isReply = req.body.replyId;
	// 发送全局提醒给我自己
	let html = "收到评论：<a href='" + url + "'>点击查看</a>";
	if(isReply){
		html = "你的评论收到了回复，<a href='" + url + "'>点击查看</a>";
	}

	sendmail({
		from: "xxxx@zhangjh.me",
		to: mail,
		subject: subject,
		html: html
	},function (err, reply) {
		console.log(err && err.stack);
		console.dir(reply);
    });
});
```
非常简单的post HTTP接口，接收收件人，文章链接，邮件主题等信息，然后调用刚刚封装的sendmail函数将邮件发送出去。

这样在前台的文件中在用户点击了回复评论按钮时，获取被回复评论的作者的邮箱信息组装后调用sendMail接口发送提醒邮件给被回复者。

#### 页面消息提醒框
接下来我们再看下页面上显示评论消息的提醒框功能如何实现？
这里先不讨论前端的内容，只讨论下如果要支持前端显示这个功能，后端应该要做哪些事？
其实非常简单，只需要去数据库里查找出当前用户被回复并且未读过的评论信息即可。
根据上面的分析，可以看出其实后端只需给数据库里评论数据增加一个readed字段代表是否已经读过即可，查找评论的接口已经封装实现过了，只需客户端调用即可：
```
/** 首先在访问网站时，请求该用户评论过的数据
	然后将这些评论id作为被评论id查询是否有被回复且未读的数据
*/
let replyComments = [];
$.ajax({
	url: "/comment/find",
	data: {
		name: name,
		url: url
	}
}).done(ret => {
	if(ret.status){
		for(let item of ret.data){
			$.ajax({
				url: "/comment/find",
				data: {
					replyId: item.id,
					readed: false
				},
				async: false
			}).done(result => {
				if(result.status){
					// 拼接结果到评论数组里
					replyComments.concat(result.data);
					// replyComments供前端渲染提醒框，这节暂且不表
				}
			});
		}
	}
});
```

至此，一个功能完善的评论系统的后端就已经完全搭建完毕。下节我们最后讲讲如何利用这些接口方法实现前台应用的渲染，模仿一个畅言风格的前端评论系统。
