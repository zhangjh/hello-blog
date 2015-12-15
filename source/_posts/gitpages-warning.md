title: 解决hexo博客gitpages的page build warning问题
show: true
date: 2015-12-11 14:06:45
tags: [page build warning,github,gitpages warning,hexo,dns]
categories: 技术人生
---
#### 背景
每次博客在写完文章发布之后，邮箱都会收到一封提醒邮件：
> The page build completed successfully, but returned the following warning:

> Your site's DNS settings are using a custom subdomain, www.5941740.cn, that's set up as an A record. We recommend you change this to a CNAME record pointing at zhangjh.github.io. Instructions on configuring a subdomain for use with GitHub Pages can be found at: https://help.github.com/articles/setting-up-a-custom-domain-with-github-pages/ 

> For information on troubleshooting Jekyll see:

>  https://help.github.com/articles/using-jekyll-with-pages#troubleshooting

> If you have any questions you can contact us by replying to this email.

说我的域名dns解析有问题云云。之前也是在[github的帮助页面](https://help.github.com/articles/tips-for-configuring-an-a-record-with-your-dns-provider/)上看的如何将自己的域名解析到gitpages上来。
> With your DNS provider, create A records that resolve to the following IP addresses:

> 192.30.252.153
> 192.30.252.154
> To confirm that your A records have been set correctly, use the dig command:

> dig example.com +nostats +nocomments +nocmd
> ;example.com
> example.com.   73  IN  A 192.30.252.153
> example.com.   73  IN  A 192.30.252.154

由于一直也不影响访问就没当回事，奈何每次都发邮件还没法设置取消提醒，很烦。。

<!--more-->

#### 解决方法
根据邮件提示，我需要将我的www域名解析到gitpages的`zhangjh.github.io`上才是。

于是在github上搜索了下，官方的解决方法如下：[链接](https://help.github.com/articles/tips-for-configuring-a-cname-record-with-your-dns-provider/)
1. 域名解析商处
- 创建A记录
> 创建A记录，将顶级域名解析到`192.30.252.154`或`192.30.252.153`

- 创建CNAME记录
> 创建CNAME记录，将子域名(www)解析到gitpages的用户名，就是邮件里提到的`zhangjh.github.io`啦。

2.项目仓库
gitpages项目仓库里增加一个CNAME文件，其内容写上自己的域名
```
www.5941740.cn

```
等一会儿，dig域名查看dns是否解析生效。


###12.12更新--解决百度爬虫无法爬取问题
做如上修改解决报警邮件问题后有一个副作用，我在做了修改一天之后才发现。
该副作用是：百度不能收录！
原因在网上搜索一番后发现，gitpages博客不能被百度收录，百度站长工具的抓取诊断也确实显示了抓取失败。
>HTTP/1.1 403 Forbidden
Cache-Control: no-cache
Content-Type: text/html
Transfer-Encoding: chunked
Accept-Ranges: bytes
Date: Sat, 12 Dec 2015 12:50:53 GMT
Via: 1.1 varnish
Connection: close
X-Served-By: cache-itm7426-ITM
X-Cache: MISS
X-Cache-Hits: 0
X-Timer: S1449924652.915626,VS0,VE183
Vary: Accept-Encoding
X-Fastly-Request-ID: 42a7750c17762bbaab530893bae393682c58a4b9

由于刚好之前是可以被爬取的，改了之后就不能爬取了，于是迅速定位到是否是由于修改了DNS解析造成的。
网上搜索了下，基本没有好的解决方法，CDN加速抑或海外VPS（基本就是放弃gitpages托管了）都不能很好的解决问题。
于是没办法，只有继续忍耐warning，改回原来的DNS解析了。当然如果在你看来，强迫症比百度爬取更重要的话，那就另说了。
```
A www 192.30.252.153     //解决warning时将子域名解析到了zhangjh.github.io
A @   192.30.252.153
```

修改后，使用百度站长重试了下：
>HTTP/1.1 200 OK
Server: GitHub.com
Content-Type: text/html; charset=utf-8
Last-Modified: Fri, 11 Dec 2015 07:18:54 GMT
Access-Control-Allow-Origin: *
Expires: Sat, 12 Dec 2015 11:29:59 GMT
Cache-Control: max-age=600
Content-Encoding: gzip
X-GitHub-Request-Id: 67F5E01A:448F:908CB80:566C02DE
Content-Length: 11740
Accept-Ranges: bytes
Date: Sat, 12 Dec 2015 14:17:28 GMT
Via: 1.1 varnish
Age: 241
Connection: close
X-Served-By: cache-itm7426-ITM
X-Cache: HIT
X-Cache-Hits: 2
X-Timer: S1449929848.900641,VS0,VE0
Vary: Accept-Encoding
X-Fastly-Request-ID: 3d0dcaa1f8e132e8d6ed056c6c6f1e28f7bcd8eb

