title: 解决git报错:".git/hooks/pre-commit No such file or directory"
show: true
date: 2016-12-22 16:22:00
tags: git
categories: 技术人生
---
第二次遇到这个问题了，第一次删除了.git目录重新下载了项目，结果commit记录什么的都不对了，损失惨重，这次又遇到这个问题没敢轻举妄动了，折腾了很久，终于找到了问题的根源，这里记录一下以备忘，顺便给遇到同样问题的朋友们一点启发。

这个问题的根源在于跨平台造成的换行符的不一致造成。回想两次操作，都是在push的时候提示要将CRLF替换成LF，"warning: CRLF will be replaced by LF"。接受IDE的建议修改以后，所有的文件的换行符都被替换，于是pre-commit文件的行尾也多了"\r"字符，导致运行时报错。
```
.git/hooks/pre-commit: line 4: [: 127 : integer expression expected
.git/hooks/pre-commit: line 5: exit: 0 : numeric argument required
```

找到问题的原因后，解决方案就呼之欲出了。删除掉多余的字符即可。

```
cp .git/hooks/pre-commit /tmp/pre-commit
tr -d '\r' < /tmp/pre-commit > .git/hooks/pre-commit
```
如果还有其余文件报错，一并处理即可。
