title: 使用awk BEGIN、END统计文件求和
show: true
date: 2015-12-14 11:04:43
tags: [awk,awk求和,awk BEGIN,awk END]
categories: 技术人生
---
#### 背景
我在处理一个自动化报告时，需要统计其中成功的用例个数和失败的用例个数，报告文件的格式类似：
>......
FAIL 2 tests executed in 5.622s, 1 passed, 1 failed, 0 dubious, 0 skipped.
......
PASS 55 tests executed in 54.976s, 55 passed, 0 failed, 0 dubious, 0 skipped.
......
PASS 15 tests executed in 20.642s, 15 passed, 0 failed, 0 dubious, 0 skipped.

#### 使用awk统计
在Linux下进行文本处理，没什么比sed/AWK更强大了。于是乎直接想到了用awk将报告中的"PASS"，"FAIL"数目统计一下即可。
代码示例如下：
<!--more-->

```js
PASS数目:
grep -o ".*tests executed in" reportName | awk 'BEGIN{sum=0}{if($1 ~ /PASS/)sum+=$2}END{print sum}'

FAIL数目：
grep -o ".*tests executed in" reportName | awk 'BEGIN{sum=0}{if($1 ~ /FAIL/)sum+=$2}END{print sum}'
```

首先从报告文件中，取出匹配的最终运行概述信息，然后再用awk统计对应的条目。
此处用到了awk的BEGIN和END，顺便记录一下BEGIN和END的用法。

#### BEGIN和END
BEGIN和END顾名思义，在awk中，BEGIN只在开始处理之前运行一次，END只在结束处理之后运行一次，其余正常的文本行处理过程不运行。
非常适合用在做一些前置操作时使用，通常求和类初始化值、设定分隔符等经常会用。

语法：
```js
awk '[BEGIN]{..}{..}[END{..}]' file
```
形式均为'{}'样，其中BEGIN和END语句块均可省略。

examples：
以统计数字文本（文本内容每行均为数字）为例
```js
//1. 求和
awk 'BEGIN{sum=0}{sum+=$1}END{print sum}' file

//2. 求均值
awk 'BEGIN{sum=0}{sum+=$1}END{print sum/NR}' file
NR为总记录数

//3. 求最大值
awk 'BEGIN{max=0}{if($1 > max)max = $1}END{print max}'

```

配合grep、正则表达式以及条件表达式等使用，效果更佳。
