title: git学习笔记（2）
date: 2015-07-10 14:35:17
tags: git
categories: 技术人生
show: true
---
#3.远程仓库
svn只在一个仓库里管理文件，而git是分布式版本控制系统，同一个git仓库可以分布到不同的机器上。
不同机器上的版本库其实都一样，没有主次之分。通常实际上，我们是有一台充当服务器的电脑，开源项目有很多的项目托管网站如github，gitcafe等，自己公司也会搭建自己的git服务器。我们每个人都从这个服务器上克隆一份仓库到自己本地上，再把自己的提交推送到服务器仓库里。
在向远程仓库提交修改之前，需要设置一下本地与远程服务器之间的信任关系，这也是svn与git的区别之一。svn通过账号即可，而git本地和远程仓库之间的传输是通过ssh加密的，需要设置一下key，本质上等价于两台服务器之间的信任关系建立。这里简单记录一下key生成的步骤。
<!--more-->
##3.1设置本地与远程的信任关系
- 创建SSH KEY
在本机用户主目录下如果已有密钥文件id_rsa、id_rsa.pub则可以跳过此步骤，否则需要先生成密钥，生成方法：
```js
ssh-keygen -t rsa -C "email@xxx.com"
```
使用默认设置，一路回车即可
- 将生成的KEY添加到远程库
以github为例，打开用户配置
![](http://ww2.sinaimg.cn/bmiddle/62d95157gw1etxonuntbqj20p60gqta2.jpg)
在设置页面选择"SSH Keys"，点击"Add SSH Keys"，将生成的id_rsa.pub文件的内容黏贴进框中，需要注意不要有多余的字符。

这样在向远程仓库推送的时候git就可以识别出提交推送的人确实是有权限的。（跟主机间建立信任关系免密码登录一个道理）
按照同样的步骤，可以添加多个Key，这个就可以在不同的电脑上进行提交了。

##3.2添加远程仓库
略去在服务器上添加新的空仓库的过程不表，通常新建仓库之后服务器会提示我们如何新建仓库或者将本地已有的仓库与远程关联。
![](http://ww4.sinaimg.cn/bmiddle/62d95157gw1etxp7xfwq3j20g6098jt4.jpg)
添加后，远程库的名字就是*origin*，这是git默认的叫法，也可以改成别的，但*origin*这个名字一看就知道是远程库。

上图中第一次推送的时候使用的是
`git push -u origin master`
实际上是把当前分支*master*推送到远程。
由于远程库是空的，第一次推送master分支时，加上-u参数，git不但会把本地的master分支内容推送到远程库新的master分支，还会把本地的master分支和远程的master分支关联起来，在后续的推送中即可简化推送命令：
`git push`

#4.分支管理
分支管理之前弄的不是很明白，主要还是实际工作中分支开发的使用不多。以前我在写工具的时候通常要修改的时候都是拷贝一份代码出来，修改好了之后再替换原来的。这样不但山寨，也让我付出过惨痛代价：硬盘挂了或者被同事误删除导致代码丢失。。
git的分支管理可以让你随时修改代码，想提交就提交，开发完成后再合并到主干即可。安全可靠。虽然在刚学git的时候发生过由于操作*reset*命令有误导致将已修改的代码回滚掉，表象看起来都是丢了代码，但本质上已经完全不一样啦，硬盘挂或者被误删之类的再也不用担心了。
##4.1创建分支
在git里，分支的管理操作非常快，这是由于git在创建分支时仅仅是指针的修改，见图：
![](http://ww3.sinaimg.cn/thumbnail/62d95157gw1etxpo3n0e5j208d047q2w.jpg)
初始时，HEAD指针指向master分支，每当创建一个分支时，git会新建一个指针指向该分支（未做改动前，该分支指针和master分支指向一致），HEAD指向改指针（原先指向master，表示当前分支），工作区文件都不会变化。当分支提交改动时，该分支指针即向前移动一步，而master指针不会改变。
当分支的工作完成，合并分支到master时，git直接将master的指针指向了要合并的分支，改变HEAD指针指向master。合并也相当迅速，不涉及文件操作。过程见图：
![](http://ww4.sinaimg.cn/bmiddle/62d95157gw1etxpwrt26lj20dq06hmx7.jpg)

![](http://ww2.sinaimg.cn/bmiddle/62d95157gw1etxpwv53w5j20br0660st.jpg)
`git checkout -b dev`
创建dev分支并切换到dev分支（-b表示切换）
可以使用`git branch`查看当前分支，使用`git branch -a`查看远程仓库有几个分支
##4.2合并分支
当分支开发完毕需要合并到master上时
```js
git checkout master
git merge dev
```
首先切回master分支，然后merge待合并分支
这种默认的merge合并方式是*Fast-forward*，git直接把master指向dev的当前提交，合并非常快，所以叫*快进模式*。
并不是每次都可以"快进"成功，还有其他的合并方式。
##4.3删除分支
`git branch -d dev`

##4.4获取远程分支
很多时候我们需要将远程分支上的代码check下来修改，这时候如果本地工作机器没有已经check好的分支代码的话直接`git pull`是不行的，该怎么获取远程分支代码呢？
```js
git branch -a  //查看远程分支信息
git fetch      //获取远程库代码
git checkout -b local-branch origin/remote-branch   //新建本地分支并映射到远程名为remote-branch的分支上
git branch     //可以查看下确认是否已经在local-branch分支上了
```

