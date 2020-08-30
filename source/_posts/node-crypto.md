title: nodejs使用crypto进行加密/解密操作
show: true
date: 2016-06-17 15:00:18
tags: [crypto,加密,解密]
categories: [技术人生]
---
#### 背景
前面博文总结了[favlink](http://favlink.me)的用户登录验证系统。说到登录验证那必然少不了用户名、密码的验证过程，而密码的操作也离不开加密，解密，毕竟不能明文存储吧！本篇就简单总结一下favlink开发过程中用到的nodejs加解密库。

#### crypto简介
[Crypto](http://nodejs.org/api/crypto.html)是包含在nodejs内核中的，主要提供加密、解密、签名、验证等功能。利用了OpenSSL来实现其加密技术。

#### 使用方式
```
var crypto = require('crypto');
//加密
function encrypt(str,secret){
	var cipher = crypto.createCipher('aes192',secret);
	var enc = cipher.update(str,'utf8','hex');
	enc += cipher.final('hex');

	return enc;
}

//解密
function decrypt(str,secret){
	var decipher = crypto.createDecipher('aes192',secret);
	var dec = decipher.update(str,'hex','utf8');
	dec += decipher.final('utf8');
	return dec;
}
```
- 我们先来看加密操作。
`crypto.createCipher(algo,pwd)`,该函数接收两个参数，一个加密算法，一个密钥字串，返回一个'Cipher'对象。
加密算法有很多种，我这里使用的是'aes192'，可以运行下面的代码查看所有支持的算法：
	```
	var crypto = require('crypto');
	console.log(crypto.getCiphers());
	```
	`cipher.update(data[,input_encoding][,output_encoding])`,该函数可接收三个参数，编码可选(输入只能是`'utf8','ascii','binary'`之一，输出只能是`'binary','base64','hex'`)，返回指定编码后的加密数据，如果编码缺省，则返回`buffer`类型。
	`cipher.update()`可以运行多次，但只能在`cipher.final()`之前运行。
	`cipher.final(output_encoding)`,返回指定编码的加密字串。

- 解密操作
解密操作类似，首先先定义解密用`decipher`对象，保持和加密所用的密钥、加密算法一致；
然后使用decipher将加密字串解密即可。

#### 示例
1. 加密
```
encrypt("helloworld","weird sheep");
//Output: faf46f87e8befb82bc643805cfd753a6
```

2. 解密
```
decrypt("faf46f87e8befb82bc643805cfd753a6","weird sheep");
//Output: helloworld
```
