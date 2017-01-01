title: ant-design的select组件onSelect事件简析
show: true
date: 2017-01-01 17:53:45
tags: [react,ant-design,select,onSelect]
categories: 技术人生
---

## 背景
最近刚入react的坑，前端的布局和控件设计用的是阿里的开源框架：[ant-design](http://ant.design)。ant-design不失为一款好用的设计框架，与bootstrap类似，比bootstrap好看，只是必须结合react使用。跟阿里其他的开源工具类似地，存在一个共同的通病，亦或者可以说是所有国有开源软件的通病：文档写的不够细致。
ant-design也是这样，在官方文档中经常有一些说的不够的地方，让使用者看的莫名所以。最典型的要数针对控件的API的事件参数的说明了，在这上面已经踩了很多的坑。有的是不知道参数传入的意义，有的是参数传递的使用方法说的不够具体等。本篇就一个具体的问题：Select选择器的onSelect事件记录一下踩坑的经历。

## 问题
我在开发中用到了如下代码片段：
```
const options = options.map(d => {
	return <Option key={d.id}>{d.value}</Option>;
});
<Select onSelect={this.props.onSelect}>
	{options}
</Select>
```
其中key属性是按照react的官方要求，遍历数组元素生成控件时要添加一个唯一的key属性供react的diff算法渲染。
渲染没有问题，在下拉选择的时候onSelect获取的参数值总是跟预期的不一致，在上例中，onSelect接收的总是key的值，然而官方文档里说：被选中时调用，参数为选中项的value值。

## 探索
文档除了那一句话外就没多说了，既然文档写的语焉不详，那么只好写测试自己琢磨了。

1. 测试代码1

	```
	import { Select } from 'antd';
	const Option = Select.Option;


	ReactDOM.render(
	  <Select value="test"
		onSelect={function(value){alert(value);}}
	  >
		<Option key={1}>
		  111
		</Option>
		<Option key={2}>
		222
		</Option>
	  </Select>
	  , mountNode);
	```
	运行后发现确实是选择111时弹出1，选择222时弹出2，获取的是key。。。

2. 测试代码2

	```
	import { Select } from 'antd';
	const Option = Select.Option;


	ReactDOM.render(
	  <Select value="test"
		onSelect={function(value){alert(value);}}
	  >
		<Option value={1}>
		  111
		</Option>
		<Option value={2}>
		222
		</Option>
	  </Select>
	  , mountNode);
	```
	怀疑官网说的value不是option的value值而是value属性，于是将key属性换成value。结果果然是选择111时弹出1，选择222的时候弹出2了。

验证了猜想，文档里说的onSelect的参数是被选中项的value属性而不是值，并且可恶的地方在于，没有设置value属性的时候竟然会返回key属性。。。要么说明下，要么按照文档的如实返回，返回key属性这不是挖坑了吗！
