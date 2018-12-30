title: JAVA内部类反序列化问题
show: true
date: 2018-12-31 01:10:34
tags: [JAVA,内部类,反序列化]
categories: 技术人生
---

#### 背景
通常我们在Controller层接收前端传递的复杂参数时，都会封装一个请求参数类，然后将前端传递过来的参数解析成该请求对象。
这次我遇到的场景，前端传递的参数结构比较复杂，但只有三个字段，其中一个字段又是一个复杂结构，类似这样的结构：
```
id: xxx;
name: xxx;
data: {
	id: xxx,
	parentId: xxx,
	item1: xxx,
	item2: xxx,
	......
}
```
其中的data部分数据结构类已经在其他应用中定义，通过二方包的形式引入，为了省事，不想再在外部定义一个只有"id,name,data"三个字段的请求参数类，于是就在Controoler方法内部定义了一个内部类，供方法自己使用。
然后问题就来了，在参数解析的时候报错：
```
Exception in thread "main" com.alibaba.fastjson.JSONException: create instance error, xxxxx
```
。
<!--more-->

#### 问题复现
新建测试类，搭建简单的测试代码如下：
```java
public class Test {



    @Getter @Setter
    class Param {
        private String id;
        private String name;
        private String data;
    }

    public static void main(String[] args) {
        String str = "[{id: 1, name: \"test\", data: \"test data\"}]";
        JSONObject.parseArray(str, Param.class);
    }
}
```
运行后报错: : "Exception in thread "main" com.alibaba.fastjson.JSONException: create instance error, class xxxx.xxxx.Test$Param"
一开始一直以为是不是自己JSONObject的parseArray方法用的有问题，然而在debug模式下手动执行`JSONObject.parseArray(str)`命令可以正常解析出参数类，只是没有传入类型参数而已，至此大概知道是不是类写的有问题，然而如此简单的一个类定义......
又猜测是不是因为在main函数里调用，Param类需要定义为静态类？于是在Param前加static定义，再次运行竟然成功了。于是这个问题微妙起来，难道真的是因为在main函数测试模式下导致的？那么换一种写法。

```
public class Test {

    @Getter @Setter
    class Param {
        private String id;
        private String name;
        private String data;
    }

    public void test(){
        String str = "[{id: 1, name: \"test\", data: \"test data\"}]";
        JSONObject.parseArray(str, Param.class);
    }

    public static void main(String[] args) {
        new Test().test();
    }
}
```
这回不在main函数中测试，结果运行还是报错，这就不是静态不静态的问题了。肯定是内部类的问题了。再次验证，将Param类转移到外部文件中重新定义。
重新运行测试，可以正常解析成类了。

#### 结论
至此，通过测试基本可以断定，fastJson在反序列化内部类的时候有问题或者不支持。
于是网上查找了下关键词"fastjson 反序列化 内部类"，答案呼之欲出：
[官方的issue](https://github.com/alibaba/fastjson/issues/302)中已经指出：: "内部非静态类无法实例化"。
