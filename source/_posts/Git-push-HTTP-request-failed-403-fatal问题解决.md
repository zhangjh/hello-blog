title: Git push HTTP request failed 403 fatal问题解决
date: 2015-06-30 11:26:40
tags: git
categories: 技术人生
---
我在搭建这个博客的时候，在更新了文件后使用git push到远程仓库时报错，报错信息如下：

`error: The requested URL returned error: 403 while accessing https://github.com/zhangjh/myblog.git/info/refs`

`fatal: HTTP request failed`

百度了一下，有很多类似的问题，解决方法较多的一种是：

<!--more-->

将.git/config文件的[remote "origin"]部分的repo地址修改为username@githubxxx，即：
原：`url=https://github.com/zhangjh/myblog.git/`
修改为：`url=https://zhangjh@github.com/zhangjh/myblog.git`

我试了下，确实是可以的，在push的时候弹出输入密码的提示，输入自己的github密码即可。

可是如此修改之后岂不是每次push的时候都要输入密码了？这么反人类怎么可以。。

于是继续搜寻更好的解决办法，在github的[官方HELP页面](https://help.github.com/articles/https-cloning-errors/)上找到了这个问题的根本解决之道：

官方的说明是，出现这个问题，
- 首先看自己的git版本是不是太旧了（为此我专门升级了git结果不奏效）；
- 其次确保仓库地址没有写错，大小写是有区分滴（我是直接复制黏贴的也不是这个问题）；
- xxxtoken的问题直接忽略（因为我看不明白）；
- 最后官方给出了一个解决方案：使用SSH代替HTTPS。

我尝试了行之有效，将.git/config文件的[remote "origin"]部分的repo地址修改为ssh协议

`url=ssh://git@github.com/zhangjh/myblog.git/`

当然官方建议还是使用HTTPS协议，有时候你的服务器死活就是不行的时候，官方建议就另说啦。
