title: git学习笔记（3）
date: 2015-07-24 14:31:39
tags: git
categories:  技术人生
show: true
---
本篇对Git的学习做一个扫尾笔记，主要是标签、配置等一些杂项。
三篇下来，基本上对日常使用中常用到的方法和命令都基本掌握了，以后有需要再查漏补缺了。

# 4.标签
标签相当于给分支取了一个好记的别名，这在git里称为里程碑。比如我们的代码版本达到了发布版本，可以取个别名叫做v1.0等等。方便后续更容易访问，而不是查看git log找到对应的commitid。

标签即版本库快照。

<!--more-->

## 4.1 创建标签
git中打标签非常简单，拢共分两步：
- 首先切换到待打标签的分支上
```
git checkout <branch name>

```
- 然后git tag打标签
```
git tag <tag name>
```

默认是给最新提交打标签，也可以给某次的历史commit打标签：
```
git tag <tag name> <commit id>

```
## 4.2 查看标签
可以使用`git tag`查看标签，`git show <tag name>`可以查看标签信息。
![](http://ww3.sinaimg.cn/large/62d95157gw1eudveokukyj20lt09kn0b.jpg)

## 4.3 删除标签
删除本地标签：
```
git tag -d <tag name>
```
如果要删除远程标签：(先删除本地再删除远程)
```
git tag -d <tag name>
git push origin :refs/tags/<tag name>
```

## 4.4 推送标签
```
git push origin <tag name>
```
一次性推送全部本地尚未推送到远程的标签：
```
git push origin --tags
```

# 5. 杂项
##5.1 配置git显示颜色
```
git config --global color.ui true
```

##5.2 配置git命令别名
给常用git命令设置简短别名：
```
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.ci commit
git config --global alias.br branch
git config --global alias.pu push
git config --global alias.unstage 'reset HEAD'  //放弃暂存区的修改
```
## 5.3 配置忽略特殊文件
我们在管理代码时，有时候有些文件不想列入代码管理，比如nodejs工程的node_modules安装模块目录，这种属于系统生成不是我们开发的文件，每次在查看git修改的时候都会提示"untracked xxx"，看着让强迫症患者还是挺不爽的。
庆幸的是，git提供了忽略这些明确不用加入代码管理的文件的方式。只需配置下配置文件忽略掉他们即可。
```
touch ./.gitignore      //创建该配置文件，并添加待忽略文件，支持正则
```

对于熟悉svn的来说，使用git只是熟能生巧的事情，最后附上一张总结的Git常用命令图。
[点击查看源图](http://byte.kde.org/~zrusin/git/git-cheat-sheet-large.png)
![](http://byte.kde.org/~zrusin/git/git-cheat-sheet-large.png)
