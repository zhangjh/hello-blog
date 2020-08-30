title: 小项目：使用树莓派自动播报当前时间和当天天气
show: true
date: 2017-07-31 15:19:59
tags: [树莓派,raspberry]
categories: 技术人生
---

# 背景
本篇博文分享下使用树莓派结合百度语音合成API进行当前时间和天气自动播报功能的实现。转载请注明出处。

阅读本文需要你有一定的Linux编码水平(主要是Bash)及一些python基础。
这个项目的想法初衷是希望树莓派能够定时地将一些信息通过蓝牙播放设备自动播放出来，初期先播放时间和天气，能够代替一个闹钟了呢，哈哈~~

# 方案设计
方案很简单，设置定时任务，将运行时时间获取到，并同时获取当前天气状况，然后使用百度语音合成API将获取到的信息转换成语音通过蓝牙连接的播放设备播放出来。

获取天气也使用了百度开放平台提供的接口，因此一共需要有百度开放平台和语音合成API两个接口的调用权限。

[**开放平台注册**](http://lbsyun.baidu.com/index.php?title=webapi)
[**语音合成API注册**](http://yuyin.baidu.com/sdk)

## 获取天气
我们先来获取天气信息,API的返回结果结构如下：
![](http://wx1.sinaimg.cn/mw690/62d95157gy1fi344u1xbqj20nc0ewac8.jpg)
我舍弃了穿衣指数什么的，只获取天气数据。

<!--more-->

```py
#!/usr/bin/python
# coding: utf-8

import sys
import urllib
import urllib2
import json

reload(sys)
sys.setdefaultencoding('utf-8')

# 城市信息参数传入
url = "http://api.map.baidu.com/telematics/v3/weather?location=" + argv[1] + "&output=json&ak=开放平台的API key"
req = urllib2.Request(url)
#print req

res_data = urllib2.urlopen(req)
res = res_data.read()
#print res
jsonStr = json.loads(res)
todayDate = jsonStr['results'][0]["weather_data"][0]["date"]
todayWeather = jsonStr['results'][0]["weather_data"][0]["weather"]
todayTemp = jsonStr['results'][0]["weather_data"][0]["temperature"]

print "今天天气",todayWeather,"气温",todayTemp
```

## 合成语音
然后将获取的天气信息让百度API变成语音读出来：
```py
#!/usr/bin/python
# -*- coding: utf-8 -*-

from sys import argv
from aip import AipSpeech

## 语音合成API的key
APP_ID="xxx"
API_KEY="xxx"
SECRET_KEY="xxx"

# audioText: The text will be synthesis to audio
# audioPath: The audio will be saved as.
audioText = argv[1]
audioPath = argv[2]

aipSpeech = AipSpeech(APP_ID, API_KEY, SECRET_KEY)

result = aipSpeech.synthesis(audioText,'zh',1,{
    'vol': 5,       # 0-15,default 5 medium
    'pit': 6,
    'spd': 4,
    'per': 3
})

if not isinstance(result, dict):
    with open(audioPath, 'wb') as f:
        f.write(result)
```
获取的天气文本作为第一个参数存入，第二个参数指定语音保存文件。具体选项值可以参考百度API手册。

时间的类似，完整代码请[**戳此查看**](https://github.com/zhangjh/raspberry_autoPlay/tree/master)

## 播放语音
有了语音文件，播放就很简单了。就跟平常的放音乐一样，找个播放器当然要可以命令行执行的，树莓派下(linux)推荐`mplayer`，然后直接运行
```
mplayer xxx.mp3
```
声音就通过播放设备播放出来了。对了，最好你是要有个蓝牙音箱，否则你不会还要插个耳机听吧？那样的话，这个项目还有什么折腾的意义呢？^_^


利用crontab设置一个定时任务，是不是就成了一个定时播放的闹钟了？
