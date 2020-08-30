title: 当node遇上远程执行shell命令
show: true
date: 2016-08-05 14:26:32
tags: [node,ssh,shell,远程执行]
categories: 技术人生
---
## 背景
我有个Node.js项目，需要在node环境下调用shell命令。开始时只是单机调用，很简单，拼接好了shell命令，使用node的child_process调用一下就好了。随着系统规模的扩大，需要在node下进行调度，将任务分发到不同的机器上，于是就需要使用到ssh远程执行。简单一点的命令也还是可以执行的，但随着执行命令也复杂起来，参数里面有开始包含`",'`时，问题就开始复杂了。

## node执行shell命令或脚本
让我们一步步来看一下这个问题是如何复杂起来的。首先先看一下，node下如何执行shell脚本或命令。
以执行命令为例：(执行脚本可以等同于执行命令，只需要将大量命令先写成脚本，再执行脚本即可)

node提供了一个child_process的子进程API，借助该API可以调用系统命令。
```
var exec = require('child_process').exec;

var cmd = "ls -al";

var out = exec(cmd);

out.stdout.on('data',function(data){
	console.log("stdout: " + data);
});

out.on('exit',function(code){
	console.log(code);
});
```

上述代码片段将运行`ls -al`后输出结果，并输出命令执行后的返回码。

<!-- more -->

## node远程执行
如果需要将任务分发到其他机器上，在其他机器上远程执行命令，该怎么做呢？命令简单的话，一句话也能执行。
```
//以下方式执行需要先在机器间[建立信任关系](http://blog.sina.com.cn/s/blog_68158ebf0100vf8l.html)
var remoteMach = "$hostname";
var account = "$account";
var cmd = "ls -al";
var cmd = "ssh -tT " + account + "@" + remoteMach + '"' + cmd + '"';

var out = exec(cmd);
out.stdout.on('data',function(data){
	console.log(data);
});

```
上述情形，在执行比较简单命令或脚本时是适用的。该方式的明显缺点就是不支持格式化，写起命令来比较困难。
不过可以换一种方式来运行。
1. 先创建远程执行命令的脚本，这样在脚本里面可以格式化命令
2. 再调用该脚本

脚本内容写法：

```
#!/bin/bash
cmd="hostname -I && ls -la"
account="xx"
hostname="xx"
ssh -tT $account@$hostname << EOD
	$cmd
EOD
```

node中远程调用写法：

```
var exec = require('child_process').exec;
var cmd = "sh -x remote.sh";   //remote.sh即上述脚本

var out = exec(cmd);

... ...

```
该写法避免了直接写远程执行命令不能格式化的缺点，但是缺点也很明显，需要额外编写一个脚本文件。在命令简单的时候缺点还不是很明显，试想，如果该执行脚本需要接收很多参数，那么不可避免地，在node中调用的时候需要传递很多参数给该脚本，一样会遇到字符串命令格式化的问题。

## 使用simple-ssh
下面来看一下本篇博客的主角--simple-ssh的解决方案。将node，ssh，shell结合起来估计也没多少文章提到了吧，我在网上查了一圈也没甚收获。在该问题困扰了我许久之后，我终于发现了[simple-ssh](https://github.com/MCluck90/simple-ssh)。

simple-ssh将远程执行命令变得分外简单，首先我们不必依赖信任关系了，可以直接传递用户名和密码，其次，简明的逻辑让代码写起来逻辑也清晰了很多，即使是复杂命令，由于不用再额外使用`ssh account@host "cmd"`这种方式包裹，使得参数包含引号时的引号冲突问题也避免了。

下面的示例由于是简单的`ls -al`，因此看不太出来其优越，正如上面的例子看不出来使用`ssh`包裹这种方式直接执行的困难一样，相信我使用simple-ssh来编写要好的多了。

```
//先行安装simple-ssh
npm install simple-ssh

//code
var SSH = require('simple-ssh');
var host = "xx";
var account = "xx";
var passwd = "xx";
var ssh = new SSH({
	host: host,
	user: account,
	pass: passwd
});

var cmd = "hostname -I && ls -al";
ssh.exec(cmd,{
	out: function(stdout){
		console.log(stdout);
	},
	exit: function(code){
		console.log(code);
	}
}).start();
```
