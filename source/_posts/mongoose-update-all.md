title: mongoose更新所有命中的文档
show: true
date: 2015-12-21 16:44:27
tags: [mongodb,mongoose,update all]
categories: 技术人生
---
#### 背景
我的mongodb数据库通过mongoose读写，自定义了mongoose的读写接口。之前的历史数据在写的时候由于一个小bug，导致插入的数据id字段都一样（本来是作为主键区分数据的）。
于是在修改数据的时候，使用id就不可用了，因此额外写了个脚本想批量将这些历史数据订正。
结果在实际运行的过程中发现，总是有数据不生效，反复调试了很长时间，最终怀疑是更新时只更新到了第一次匹配的数据，而后实践表明确实如此。
写完mongoose读写接口之后就再也没有研究mongoose了，对mongoose API不熟悉了。。这篇文档以为记。

#### 解决方法
mongoose的[**API**](http://mongoosejs.com/docs/api.html#model_Model.update)里写到mongoose的update方法使用方法如下：
```js
Model.update(conditions, doc, [options], [callback])
```

<!--more-->

参数均json格式，conditions为命中条件，doc为待更新的目标文档，options是可选条件，callback为更新成功后操作。
这里可选的options操作我在封装的读写接口里置空了，要更新全部匹配的文档则需要利用到options可选条件。

此处，options的合法选项有(取值均为boolean)：
```js
 safe      （默认true）
 upsert    （默认false，如果文档不存在时是否自动创建）
 multi     （默认false，是否更新多个匹配文档） <-- 解决该问题所需用到的条件
 strict    （默认true，确保不会把scheme中没有定义的值写入数据库）
 overwrite （默认false，允许覆写）
```

了解到这些，于是解决方案呼之欲出：
将更新命令中的options条件改为:`{multi: true}`
