title: 给hexo博客文章添加阅读次数统计
show: true
date: 2016-04-12 13:38:49
tags: [hexo,访问统计,阅读量，文章浏览统计]
categories: 技术人生
---
#### 背景
Hexo作为纯静态的博客系统决定了它要想实现一些诸如评论、统计等需要后台支持的功能时只能依赖第三方服务了。
站点的访问量统计，我使用的是"站长统计"，但有时候我们写了博客文章也想更方便的查看每篇文章的阅读量。这时候站长统计就不太方便了，要是能在每篇博文上直观地展现阅读量数据就好了。

网上搜索了下"hexo 访问统计"绝大部分都是提到了一个叫做"卜算子"的第三方服务，但使用个人的工具总是不那么让我放心，于是一直没有采用还是决定自己动手，鉴于不想自己搭建后端服务(穷，买不起vps...)，还是想找找看有没有更专业点的第三方服务。于是一番搜寻后还真找到个：[firebase](https://www.firebase.com)。
本篇博文即是在firebase的基础上，为hexo博客增加文章阅读量统计，适用于"Next"主题，其他主题可供参考。

#### firebase使用
1. 首先需要注册一个firebase账户
访问[firebase官网](https://www.firebase.com/)，注册账户
![](http://imglf.nosdn0.126.net/img/ODVTOGEyRktTQlJ6Vm5qY3o5S2JJcFdVWjdtSFNjUkY1ZTJOTS9TZVNsSHhKbmZVWElhd0ZRPT0.png?imageView&thumbnail=500x0&quality=96&stripmeta=0&type=jpg%7Cwatermark&type=2&text=wqkgSEVMTE8gV09STETvvIEgLyBqaHNwaWRlci5sb2Z0ZXIuY29t&font=bXN5aA==&gravity=southwest&dissolve=30&fontsize=240&dx=8&dy=10&stripmeta=0)
点击右上角"SIGN UP WITH GOOGLE"

2. 创建应用
注册以后会自动创建一个应用，也可以自己创建一个新的应用
![](http://imglf.nosdn0.126.net/img/ODVTOGEyRktTQlE5YVFRWXMxd1YyZlBWMGVkWXZaem1qd1BQYy9iaElJOExuSXhYYnVlL2tRPT0.png?imageView&thumbnail=500x0&quality=96&stripmeta=0&type=jpg%7Cwatermark&type=2&text=wqkgSEVMTE8gV09STETvvIEgLyBqaHNwaWRlci5sb2Z0ZXIuY29t&font=bXN5aA==&gravity=southwest&dissolve=30&fontsize=240&dx=8&dy=10&stripmeta=0)

3. 官网提供了[QuickStart文档](https://www.firebase.com/docs/web/quickstart.html)，可以看看，也可以直接跟着我下面的步骤操作

4. 读写数据API
根据官方的文档，写入数据通过`set`命令，读取数据通过`on(value)`触发。`transaction`方法可以在原有基础上修改数据，这个方法正好可以给我们用来统计阅读量。
全部的API见[这里](https://www.firebase.com/docs/web/api/),我们只用上述的`on`和`transaction`在合适的时候触发更新数据即可。

#### 博客修改操作
1. 引入firebase.js
`<script src='https://cdn.firebase.com/js/client/2.0.4/firebase.js'></script>`
考虑到国外网站访问速度问题，建议将上述js文件下载到本地，再本地引用。
以下是我的修改操作，供参考，引入部分在`visit.swig`内：
```
//主题配置文件_config.yml中增加开关
firebase: true
//修改layout/_partials/footer.swig，在最后增加
{% if theme.firebase %}
    {% include '../_scripts/analytics/visit.swig' %}
{% endif %}
```

2. 增加文件调用firebase实现统计记录
在第一步的代码中，我在`_scripts/analytics/`目录下创建了`visit.swig`文件，该文件就是实现统计记录的业务文件。

##### 思路
- 考虑到代码的简洁性，首页文章摘要列表内不显示访问统计，只在具体文章页显示访问统计
- 使用页面的url作为`key`
- 每次访问时，总数和当前页面数据+1

##### 容器修改
修改html容器增加统计数据字段
```html
<!--修改layout/_macro/post.swig，在post-meta部分新增统计数据字段根据开关以及是否是首页来判断是否显示-->
{% if theme.firebase and not is_home() %}
    <span class="post-visit-count">
      &nbsp; | &nbsp; 
      <!--眼睛图标-->
      <i class="fa fa-eye"></i>&nbsp;
      <span id="detail_cnt">1</span>
    </span>
{% endif %}
```

##### 统计代码

```js
//首先新建自己的firebase对象,使用自己创建应用时给的那个firebase URL
var firebase = new Firebase("https://zhangjh.firebaseio.com");

//获取当前url作为记录的key，将"/"替换未"_"，并decode
var curUrl = decodeURI(window.location.pathname.replace(/\/|\./g,"_"));

//获取总数展示
//这里的意思是获取firebase实例下的`sum`字段值
firebase.child("sum").on("value",function(data){
    var curCnt = data.val();
    if(curCnt > 1){
        if($("#totalCnt").length){
            $("#totalCnt").remove();
        }
        //我将总量放在了底部，当然位置是随意的
        $("span.author").append(" | <span id='totalCnt'>总访问量：" + curCnt + "次");
    }
});

//获取page明细
//这里的意思是获取firebase实例下的`page`字段下`cruUrl`key对应的值
firebase.child("page/" + curUrl).on("value",function(data){
    var pageCnt = data.val();
    if(pageCnt > 1){
        $("#detail_cnt").text(pageCnt);
    }
});

//将访问总数和明细+1
firebase.child("sum").transaction(function(curCnt){
    return (curCnt || 0) + 1;
});

firebase.child("page/" + curUrl).transaction(function(curCnt){
    return (curCnt || 0) + 1;
});
```

##### 设置后的效果

添加完后刷新访问几下，可以看到这货竟然是实时更新的，很强大
![](http://imglf.nosdn0.126.net/img/ODVTOGEyRktTQlJzMUlTK2FYQmd5QVdYY0ttTU95S2RBbUNuNGZZeVJSQXhzQkNIbHc2VU93PT0.png?imageView&thumbnail=500x0&quality=96&stripmeta=0&type=jpg%7Cwatermark&type=2&text=wqkgSEVMTE8gV09STETvvIEgLyBqaHNwaWRlci5sb2Z0ZXIuY29t&font=bXN5aA==&gravity=southwest&dissolve=30&fontsize=240&dx=8&dy=10&stripmeta=0)

![](http://imglf0.nosdn0.126.net/img/ODVTOGEyRktTQlFhcHpqVlZkZDdtZzBwYkhiRldWZDN3ZGl3N3JNNHVjWUpNZjhJM3Z6M1VRPT0.png?imageView&thumbnail=500x0&quality=96&stripmeta=0&type=jpg%7Cwatermark&type=2&text=wqkgSEVMTE8gV09STETvvIEgLyBqaHNwaWRlci5sb2Z0ZXIuY29t&font=bXN5aA==&gravity=southwest&dissolve=30&fontsize=240&dx=8&dy=10&stripmeta=0)
看见那个小眼睛了没？
