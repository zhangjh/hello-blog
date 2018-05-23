title: mysql中CASE...WHEN的使用
show: true
date: 2018-05-20 14:23:49
tags: [mysql,case when]
categories: 技术人生
---

<i class="iconfont" style="color: #1296db">&#xe65d;</i> 13/53，每周一篇博，坚持！

#### 背景
Mysql一直是我的弱项之一，以前跟数据库打交道比较少，基本只限于基本的操作。现在专职做后端之后，跟数据库打交道的机会多了很多，Mysql这块也在有意识的补强。这篇博客就记录一下最近项目中使用到的CASE...WHEN的使用。

很多情况下，我们会用到映射结构，如将某个类型描述映射为某个数字，常见的如页面下拉框中通常我们会把文本赋值具体显示的值，把value赋值映射过的数字，如下代码所示：
```
<select name="status">
	<option value="0">全部</option>
	<option value="1">试运营</option>
	<option value="2">运营中</option>
	<option value="3">已退出</option>
</select>
```
我们在代码中拿到了相应的数字通常是使用Switch...Case结构来获取映射的状态值。而Mysql中的CASE...WHEN结构就是做类似的事情。

<!--more-->

#### 使用方式
假设下面的场景：
我们要从某个表中同步数据，源表的status字段存储的为tinyint的数字用来表示状态，映射关系如上述select中所述。我们希望同步过来后直接以文本形式存储在目的表中。
采用MySQL的CASE...WHEN可以这么写：
```
INSERT TABLE dest_table
	SELECT CASE status
		WHEN 1 THEN "试运营"
		WHEN 2 THEN "运营"
		WHEN 3 THEN "已退出"
	END
FROM origin_table;
```

类似这样的需求，将后端程序中的映射提前到了数据库处理，减少了后端开发的成本。

我们再看一个稍微复杂一点的需求：
我们需要将具体的数值对外脱敏，脱敏层级为0-50，50-100，100-200，200+。意味着对应区间内的数值渲染时都将映射为区间显示。
如果要在后端程序里做，我们需要额外编写数据映射处理方法，就不如直接在Mysql中处理来的简单方便：
```
SELECT CASE
	WHEN (ord_cnt > 0 AND ord_cnt <= 50) THEN "0-50单"
	WHEN (ord_cnt > 50 AND ord_cnt <= 100) THEN "50-100单"
	WHEN (ord_cnt > 100 AND ord_cnt <= 200) THEN "100,200单"
	WHEN (ord_cnt > 200) THEN "200单以上"
FROM origin_table;
```
