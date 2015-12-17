title: git学习笔记（1）
date: 2015-07-07 14:14:00
tags: git
categories: 技术人生
show: true
---
没有系统的学习过git，工作过程中遇到一些使用git的问题，在网上搜寻经常被一些误人子弟的博主或者网站主们"伤害"，相信很多人也曾被网上转来转去未经验证的错误技术贴坑过。之前使用git也仅限于clone、commit、pull、push倒是没有遇到多少问题，在正式使用git来开发维护项目的时候就遇到很多问题了，尤其是在搞分支、主干，本地仓库、远程仓库的时候，那叫一个头晕。于是本着"工欲善其事必先利其器"的原则，跟随[廖雪峰的git教程](http://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000)系统的学习了下git。本篇博文即是我的git学习笔记，廖雪峰的教程非常浅显易懂，适合入门，但对于有技术基础的同学来说，未免显得"聒噪"了些。闲言少叙~

<!--more-->

#1.创建版本库
##1.1设置用户以及邮箱
设置git用户及邮箱，以便提交代码时仓库知道是谁的操作
```js
git config --global user.name "xx"
git config --global user.email "xx@xxx"
```

##1.2创建一个空仓库
git仓库就是一个目录，只要在任何的目录里创建了git的跟踪信息，该目录就成为了一个git仓库。
```js
mkdir test
cd test
git init  <-  //初始化git，将test目录变成git仓库
```
##1.3添加文件到仓库
与svn一样，git添加文件也是add命令
```js
touch README.md
git add README.md
```
添加所有新增文件可以使用add .
```js
touch a b c
git add .
```
不过如果新增的空目录是没办法新增的，如果要add目录，必须目录非空
```js
[jihong.zjh@xxx:~/learngit]$mkdir empty
[jihong.zjh@xxx:~/learngit]$git add empty/
[jihong.zjh@xxx:~/learngit]$git status
# On branch master
nothing to commit (working directory clean)
[jihong.zjh@xxx:~/learngit]$touch empty/test
[jihong.zjh@xxx:~/learngit]$git add empty/
[jihong.zjh@xxx:~/learngit]$git status
# On branch master
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#       new file:   empty/test
#
```
#1.4提交修改
```js
git commit README.md -m "指定某个提交"
git commit -a -m "提交所有改动"
```

#1.5将本地仓库改动推送到远程仓库
要将改动同步到远程仓库上还需要多一步push，由于是第一次，git需要知道要推送的仓库是什么，所以还需要使用add remote命令指定远程仓库地址
```js
git remote add origin git@gitlab.alibaba-inc.com:jihong.zjh/test.git
git push origin master 或者直接 git push
```

#2.想吃一颗后悔药
穿插两个常用命令：
- git status
- git diff
使用status可以时刻查看当前仓库的状态，是否有新增、修改文件，是否有修改还未提交等等
git diff则可以用来查看当前仓库里修改的文件和远程仓库的修改点。

我在使用git的时候经常有两个时刻非常想吃颗后悔药：
- 1.没有开分支改代码，结果改坏了。。
- 2.使用add .或者commit -a的时候把不想缓存的修改缓存了
- 3.刚保存的文件调试后发现有问题，但改了好多文件，回滚了别的文件怎么办啊
第一种情形下，我通常非常怀念我上一个还能工作的版本；第二个情形当然是有笨办法的，大不了传了后再删呗，但要是有方法能撤销掉错误的缓存就好了

#2.1版本回退
git的每次提交修改都有日志可循，使用git log查看提交历史：
```js
[test@xxx:~/tap-node]$git log
commit 4186c5b885d6d3dcd3250836941cb8e0a07a75f6
Author: xx <xx@xxx>
Date:   Tue Jul 7 16:27:57 2015 +0800
...
```
第一行commit后面跟着的commit id即对应了一次commit记录，有了commit id，接下来就好进行回退操作了。
假设上述commit id即是我上一个可正常工作的版本，那么：
```js
git reset --hard <commit id>
```
在git中，HEAD表示当前版本，对应git log显示的最新的commit id，HEAD^对应上一个版本，上上版本就是HEAD^^，上n个版本可以写成HEAD~n。


#2.2撤销修改

经过git reset都可以解决上述描述的情形1,2了，但情形3，我只想取消错误修改的文件怎么办呢？整体回滚的成本太大了，可以使用checkout命令只撤销对应文件的修改即可
```js
git checkout <file>
```


在git中，任何已经提交到git中的修改都会被记录，因此不用担心任何的文件丢失，即使在已被删除的分支中提交的代码都可以被恢复。
你仅仅会丢失的修改只会是本地仓库中没有提交过的代码，它们对于git来说就像没有存在过一样。
