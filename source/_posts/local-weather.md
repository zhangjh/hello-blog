title: 业余项目之利用天气API实现简单的城市天气预报
show: true
date: 2015-12-24 15:31:52
tags: [天气API,城市定位]
categories: 技术人生
---
近期在学习一些web全栈的东西，业余时间做了些小项目。这个天气预报的小项目属于其中之一。本身技术没有什么难的，主要是找免费可用的天气API比较费劲。最后还是使用了百度的开放API，中国天气的就不说了，打开个链接都费劲，好不容易进去了，注册的时候提示你"内部服务器错误"。。据说还不免费，纳税人交钱建立的组织，数据使用下还要交钱，哪说理去。百度的API还不错，只是没有雾霾指数。简单记录如下。

#### HTML容器
使用bootstrap布局，当天的预报信息显示一行，其余三天信息缩小放在下一行（百度API只提供四天的天气预测）。
每天的天气信息包括：一个天气图标（可随天气变化），一个温度显示。
再下一行显示本地城市信息、天气情况以及风力情况。
效果如下：
![](http://ww3.sinaimg.cn/mw690/62d95157gw1ezav90p4qcj211y0hek0d.jpg)

<!--more-->

#### 天气API

1.首先需要加载百度的API库
```js
<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=你的key"></script>
```

2.定位城市
定位城市我之前想用浏览器的navigator获取经纬度来实现，实践中发现难度还是比较大的。而用IP来定位的话，上述百度API直接提供了，那直接用IP来定位好了，虽然精度不那么准确，也许获取不到牛家庄的天气获取个杭州南京什么的还是不在话下的。
```js
var myCity = new BMap.LocalCity();
myCity.get(myFun);
```

加载了API库后，直接生成一个BMap LocalCity对象即可，传入get方法的函数（获取到城市后的回调函数）里就可以做各种事情了。

3.获取天气数据
接口调用方式：
```plain
http://api.map.baidu.com/telematics/v3/weather?location=<城市名>&output=<json|xml>&ak=yourkey
```
只需传入参数城市名以及输出格式即可。
这里需要注意的是，传入的城市名形如,"南京","北京"这样，而通过API获取的城市名是"南京市","北京市"这样，因此在传入的前需要做一下处理。
```js
cityName.split("市")[0];
```
输出格式建议使用JSON，便于解析处理。
另外，js在请求数据时，由于跨域请求不被允许，因此需要使用jsonp访问。
```js
$.ajax({
    url: "http://api.map.baidu.com/telematics/v3/weather?location=" + cityName + "&output=json&ak=你的key",
    dataType: "jsonp",
    callback: "callback",
    success: function(ret){
		//do something
		... ...
	}
});
```

4.解析数据
上述接口返回的信息格式如下：
![](http://ww2.sinaimg.cn/mw690/62d95157gw1ezaudtknrtj20lu0h4gmq.jpg)
取出results的weather_data字段即可，数组每个元素存储了一天的天气情况。使用js将对应的信息填充到相应的HTML容器里去即可。
```js
var container = ["#today","#next1","#next2","#next3"];
var result = ret.results[0];
var weather_data = result.weather_data;

//城市、风力
$("#location").html(result.currentCity);
$("#weather").html(result.weather_data[0].weather);
$("#wind").html(result.weather_data[0].wind);

//天气情况
for(var i in weather_data){
  $(container[i] + " img").attr("src",weather_data[i].dayPictureUrl);
  $(container[i] + " .temp").html(weather_data[i].temperature);
}
```
至于根据天气情况变换背景什么的，准备几张不同天气的背景图，根据不同的天气状况使用js替换相应的background-image的url就好了~

[点击查看效果](http://www.5941740.cn/local-weather/index.html)
[项目开源地址](https://github.com/zhangjh/localWeatherApp)。
