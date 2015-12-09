title: '学习Chrome插件开发制作--简易去广告插件&自动修改url'
date: 2015-09-15 19:58:30
tags: [去广告,Chrome插件]
categories: 技术人生
---
　　算不上什么高大上的玩意儿，只是记录下最近研究的Chrome扩展开发技术。了解的很还不够，不过爱因斯坦说过：
>"没有应用场景的学习都是扯淡！" (爱因斯坦：我™没说过。。)☜☜

#背景
　　了解灰度发布，A/B实验的同学应该都知道，很多时候在发布新版的时候都不是一蹴而就的，而是默认访问老版本，而将新版本向用户隐藏或是小流量放出，内部人员查看新版本时通常会有"命中参数"（即访问时传入相应的新版本参数可以强制命中新版）。
　　然而，页面是有很多内部逻辑的，比如点击跳转之类，这种动作是不会自动将参数带上的，因此实际中面临的问题是经常需要来回复制黏贴参数，再考虑到初始访问的可能是静态页面（静态页面传递参数使用?param=value），跳转后可能是动态页面（动态页面传递参数使用&param=value）。这样来回复制黏贴起来就更加费事了。。
　　在多次"惨遭蹂躏"后，开始琢磨是否可以有什么方式能够帮我完成判断页面是动态or静态然后自动添加参数的事情呢？

<!--more-->

#Chrome扩展
　　利用Chrome的扩展功能，对页面注入js脚本即可。下面简单记录下整个扩展的编写过程。用到的点不是很多，基本上都是比较初级的功能，没办法，英语泪目啊。。官方的API文档360翻译过一份，[**戳这儿查看**](http://open.chrome.360.cn/extension_dev/overview.html)，然而实际开发过程中发现，不少的用法已经过时了，官方的文档[**戳这儿**](https://developer.chrome.com/extensions/getstarted)，纯英文例子还少。。基本当个手册有需要的时候上去查查，[**这儿**](https://github.com/GoogleChrome/chrome-app-samples)还有份官方的samples，可以借鉴参考。
　　使用中通常会有两种场景，一种是注入后默默在后台运行就好了，"默默无闻，我是人民好雷锋"；还有一种就是需要你点击并弹出一个框框跟用户交互，"存在感爆表"。下面会以两个小例子来说明：简易的去广告插件--雷锋型，自动修改url--存在感型。
	
#一个扩展的基本结构
　　Chrome的扩展说白了其实就是网页，也是由HTML，CSS，JS等文件构成，所不同的是这个网页需要和Chrome的API进行交互，需要遵循一定的基本准则。这个基本准则就是manifest.json文件，这个文件必不可少，里面定义了插件的基本信息。
1. manifest.json
2. popup.html(可选)(HTML+CSS)
3. JS业务逻辑

#存在感型扩展--自动修改url添加实验参数
##清单文件
```
{
	"name": "自动添加实验参数",
	"version": "2.0",
	"manifest_version": 2,               //此处必须是2
	"description": "自动添加实验参数",
	"permissions": ["tabs","storage","notifications"],
	"icons": {
		// "16": "icon-16-coco.png",
		// "48": "48.png",
		// "128": "128.png"
	},
	"browser_action": {
		// "default_icon": "icon-16-coco.png",
		"default_popup": "popup.html"
	},
	"content_scripts": [{
		"run_at":"document_end",
		"matches": ["*://*.alibaba.com/*","*://*.aliexpress.com/*"],    
		"js": ["jquery.min.js", "addParam.js"]     //依序加载
	}]
}
```
　　如上述定义信息，必须属性为name,version以及manifest_version。
　　**name,version**不必赘述，指插件的名字和版本，manifest_version指清单文件即manifest.json文件格式的版本，在Chrome18后应该都是2了。
　　**permissions**属性指定需要和Chrome交互的一些权限设置，如tab标签，storage本地存储以及notifications可以发送桌面通知等，另外一些跨域请求也需要将跨域的目的url写在此处。
　　**icons**也没什么好说的了，就是指定插件的图标，不指定会由Chrome分配一个默认的。
　　**browser_action**顾名思义是浏览器的一些工作，这里default_popup指定了点击扩展图标后弹出的窗口，上述雷锋型扩展就不需要指定该字段。
　　**content_scripts**属性指明需要向页面注入的js脚本，run_at指明什么时候开始运行js，而matches则表明哪些场景下该扩展适用。

　　我觉得这份清单文件才是扩展的核心所在，弄明白了这个写起来基本就没问题了，当然官方的属性多如牛毛。。

##业务代码
　　搞定了清单文件，下面就是真正干活的业务代码了。
　　为了将插件做的更通用一点，我们希望提供用户输入"实验参数"的功能，否则写死了的话只能用一次就嗝屁了。。因此我需要一个popup页面供用户输入实验参数，并且还需要将实验参数存储在浏览器本地，否则每打开一个页面都需要重复再输入一次"实验参数"这样就没法玩了。
```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>点击自动添加实验参数</title>
    <link rel="stylesheet" type="text/css" href="./style.css">
    <script type="text/javascript" src="jquery.min.js"></script>
</head>
<body>
    <div id="div1">
        <input type="text" id="test_param" value="" placeholder="输入要添加的实验参数">
        <button id="btn">确认</button>
    </div>
	
</body>
<script type="text/javascript" src="addParam.js"></script>
</html>
```
　　很简单，啥玩意儿也没有，就一个框一个按钮。值得说明的是，不像普通的html，扩展的js文件一定要使用外部引入方式，否则没法运行！

　　核心的逻辑代码在js文件中，当然也是非常简单：
```
(function addParam(){
    $("#btn").click(function() {
        var buckettestValue = $("#test_param").val();
        chrome.storage.sync.remove("buckettestValue");
        chrome.storage.sync.set({"buckettestValue":buckettestValue},function(){
            new Notification("Save ok.",{body: "保存成功."});
        });
        
    });

    console.log("start");

    chrome.storage.sync.get("buckettestValue",function(result){
        var curUrl = window.location.href;
        if(!curUrl.match(/buckettest/)){
            //已经添加实验参数的url不再添加
            if(curUrl.match(/htm$|html$/) || !curUrl.match(/\&/)){
                window.location.href = curUrl + "?buckettest=" + result.buckettestValue;
                console.log("静态url");
            }else {
                window.location.href = curUrl + "&buckettest=" + result.buckettestValue;
                console.log("动态url");
            }       
        }
        
    })
})();
```
　　`chrome.storage.sync`用来跟chrome交互，保存之前先清理下本地的存储，然后将用户输入的保存到本地。这个操作需要用户点击扩展按钮在popup页面进行操作，否则就直接读取本地已经保存的实验参数值通过判断页面静态动态来自动拼接url跳转访问。
　　是不是很简单？只用到了两个API即完成了"蹂躏"我多时的问题。

#雷锋型扩展--简易去广告插件
##清单文件
```
{
    "name": "清除页面广告",
    "version": "2.0",
    "manifest_version": 2,
    "description": "简易制作的清除页面广告的chrome插件",
	//"permissions" : [],
    "icons": {
        // "16": "icon-16-coco.png",
        "128": "128.png"
    },
    "browser_action": {
        // "default_icon": "icon-16-coco.png",
        // "default_popup": "popup.html"
    },
    "content_scripts": [{
    	"run_at":"document_end",
        "matches": ["*://*/", "*://*/*"],
        "js": ["jquery.min.js", "my-del-ad-script.js"]
    }]
}
```
　　雷锋型扩展由于不需要跟用户交互，因此不需要**browser_action**属性，这款简易的去广告小插件也不需要使用Chrome的API或者是发送跨域请求因此我把**permissions**属性也去掉了。

##业务代码
```
(function clearAd (argument) {
    console.info("clear start");

    var ad_ids = [
    	//脚本之家
    	"cproIframe2001holder",
    	"baidu300",
    	"cproIframe2002holder",
    	"art_1",
    	"art_2",
    	"art_3",
    	"tonglan1",
    	"con_all",
    	"logo_m",
    	"con_da2",
    	//微博
    	"v6_pl_content_biztips",
    	"v6_pl_rightmod_rank",
    	"v6_trustPagelet_recom_member",
    	//baidu
    	"5001",
    	"5002"
    ];

    var ad_classes = [
    	"art_bot_ad",
    	"tonglanad",
    	"sm"
    ];

    $(document).ready(function(){
	    for(var i=0,len=ad_ids.length;i<len;i++){
	    	$("#" + ad_ids[i]).remove();
	    }

	    for(var i=0,len=ad_classes.length;i<len;i++){
	    	$("." + ad_classes[i]).remove();
	    }

	    //简单的广告智能预测	
	    $("iframe").hide();
	    $("div[id*='ad']").not("div[id*='head']").remove();
	    $("div[class*='ad']").not("div[class*='head']").remove();
	    if($("a:contains('推广链接')").parent().parent().attr("id").match(/content/)){
	    	$("a:contains('推广链接')").parent().hide()
	    }else{
	    	$("a:contains('推广链接')").parent().parent().hide();
	    }
	    
    	console.log("clear end");
    });
})();
```
　　很简单的逻辑，把页面上是广告的元素去掉不展示，一开始做这个的目的只是为了干掉"脚本之家"的广告，百度搜索一些问题的时候经常会跳转到脚本之家，这网站做的简直就是，*"广告比内容还多"*，相信林子聪、屠龙宝刀什么的，见过的人也是不在少数了，挺醉人的。
　　一个很明显的缺陷在于，不够通用。需要自己收集广告元素的id或class名，网上尝试搜索了下智能检测广告的方法，没get到什么东西。
　　自己分析了几个网站，尝试着写了几个简单的广告智能预测的逻辑：
　　1. 通常现在的网站大多数已经不使用内嵌iframe了，而多数的广告内容都是广告提供商提供内容，网站主将广告主提供的iframe内嵌入网页中。因此可以将网页中的iframe元素隐藏。当然这个存在一定的副作用：正常使用的iframe也会被误杀掉。
　　2. 通过命名方式。通常广告内容的ic或class名都还是带有"ad"标志的，将带有"ad"标志的元素隐藏也能干掉一票广告。注意排除带有"head"的，否则就会误杀百度搜索框啦~~
　　3. 还有一种情况是百度或者谷歌联盟的广告，通常都带有"推广链接"的链接标志，将其隐藏掉即可。

　　作为一个简易的去广告插件，已经满足了我90%的日常上网去广告的需求。在智能检测广告算法的问题上，如果你有更好的想法可以跟我讨论，也可直接改代码，[**戳这上github**](https://github.com/zhangjh/practice/tree/master/chrome_ext)。

#开发者模式下安装插件
　　直接上图：
	![](http://ww3.sinaimg.cn/mw690/62d95157gw1ew4cr3qbv6j20l102sglw.jpg)

　　也可以打包成crx格式文件，拖动到浏览器里即可。
	![](http://ww3.sinaimg.cn/mw690/62d95157gw1ew4crd97glj20fh054t91.jpg)
