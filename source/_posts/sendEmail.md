title: 使用sendEmail在命令行下自动发送邮件
show: true
date: 2016-08-16 18:11:20
tags: [sendEmail,发送邮件,中文乱码]
categories: 技术人生
---

> 偷懒是优秀程序员的美好品德。

# 背景

作为一个码农，我们的原则是尽量把能自动化完成的任务交给机器。工作上一些流程性的邮件完全可以通过自动化实现。前端获取邮件信息，后端将信息组装发送出去。本篇博文将如何使用sendEmail发送邮件做一记录。

# 安装

点击[此处](http://caspian.dotconf.net/menu/Software/SendEmail/)，从官网下载sendEmail二进制文件。

# 使用

官网的说明已经很完善，或者直接运行`sendEmail`命令，会打出详尽的命令参数。

主要的参数有：

```
-t 收件人
-f 发件人
-u 邮件主题
-m 邮件内容 (也可以通过读取文件方式)
-s 发送邮件服务器
-a 发送附件
-cc 抄送人
-xu 发件人验证
-xp 发件人密码
```

<!--more-->

# 脚本封装

```sh
#!/bin/bash

function USAGE(){
	echo "sh $0 <-t toEmail> <-u subject> <-m message> <-C ccEmail> <-a appendFile>"
} 

if [ $# -lt 1 ];then
	USAGE
	exit 1
fi

while getopts t:u:m:C:a:h OPTION
do
	case $OPTION in
		t) to="${OPTARG}"
		;;
		u) subject="${OPTARG}"
		;;
		m) message="${OPTARG}"
		;;
		C) cc="${OPTARG}"
		;;
		a) append="${OPTARG}"
		;;
		h) USAGE
		;;
	esac
done

params=" -t ${to} -u ${subject} -f ${from} -s xxxx(绿色围墙) -xu xxxx(绿色围墙) -xp xxxx(绿色围墙)"

if [ "${cc}" != "" ];then
	params="${params} -cc ${cc}"
fi

if [ "${append}" != "" ];then
	params="${params} -a ${append}"
fi

echo ${params}

cat txt | sendEmail ${params}
```

