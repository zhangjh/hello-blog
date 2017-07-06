title: 使用gulp精简hexo博客代码
show: true
date: 2016-02-19 13:16:20
tags: ["hexo","gulp","minify","代码精简","Hexo博客优化","压缩"]
categories: 技术人生
---
#### 背景
Next主题在Hexo引擎解析md时生成的代码会包含大量的无用空白,见下图.
![](http://ww3.sinaimg.cn/mw690/62d95157gw1f14j30rf5xj20z00kv76i.jpg)
这对有完美主义倾向的我们来说是个很折磨的体验,并且多余的空白也会增加文档的大小,使得网站在响应上不够迅速,影响体验.
[上一篇博文](/2016/02/19/gulp-learning/)提到了使用gulp压缩前端代码,本篇博文趁热打铁,就gulp在Hexo博客优化上进行一番实践.

#### 优化实践
##### 1. 博客根目录下创建gulpfile.js文件
##### 2. 安装gulp以及依赖插件并保存到项目依赖
```js
npm install -d --save gulp gulp-clean gulp-load-plugins gulp-minify-css gulp-minify-html gulp-rename gulp-uglify gulp-shell
```
##### 3. 编写gulp优化任务

<!--more--> 

hexo编译后生成的代码文件都在`public`目录下,因此我们的待优化源文件都在该目录下.并且所有的子目录下的文件也都要被优化,并且开源的库文件比如jquery等一般已经是优化压缩过的,不需要再压缩,因此需要将带有`.min`后缀的文件排除.于是待优化源文件的路径就可以确定了.
优化过的文件统一输出到项目根目录下的`dst`目录下.
###### 3.1 清理任务
```js
gulp.task("clean",function() {
    return gulp.src("./dst/*")
    .pipe(plugins.clean());           //plugins为加载的gulp-load-plugins插件,它可以自动加载项目依赖(package.json定义)
});
```
以上任务清空`dst`目录

###### 3.2 压缩css
```js
gulp.task("css",function() {
    return gulp.src(["public/**/*.css","!public/**/*.min.css"])
    .pipe(plugins.minifyCss({compatibility: "ie8"}))
    .pipe(gulp.dest("./dst/"));      
});
```
以上任务以原目录结构输出到`dst`目录,保持原有文件名不变

###### 3.3 压缩js
```js
gulp.task("js",function() {
    return gulp.src(["public/**/*.js","!public/**/*.min.js"])
    .pipe(plugins.uglify())
    .pipe(gulp.dest("./dst/"));
});
```
###### 3.4 压缩html
```js
gulp.task("html",function() {
    return gulp.src("public/**/*.html")
    .pipe(plugins.minifyHtml())
    .pipe(gulp.dest("./dst/");
});
```
以上三个任务基本上就将博客的所有静态文件都优化压缩过了,当然如果博客内还有本地图片的话,还可以对图片进行压缩.
为了更加方便的进行代码的优化压缩,有必要定义默认任务以及文件监听.
###### 3.5 默认任务
```js
gulp.task("default",["css","js","html"],function() {
    console.log("gulp task finished!");
});
```
以上默认任务依赖前述定义的所有任务,在依次执行完所有任务后仅输出任务完成提示.
###### 3.6 文件监听
每次手动执行还是不够高效,我们再来定义一个监听任务,让Hexo每次编译之后自动进行优化.
```js
gulp.task("watch",function() {
    gulp.watch("public/*",["default"]);
});
```
上述监听任务可以使用`nohup gulp watch`运行在后台,一旦public目录有变动就会自动运行`default`任务,即整个博客的优化任务.
###### 3.7 代码替换
优化以后的代码存在在`dst`目录下,我们还需要将他们移回到`public`目录下才可以生效.由于没找到原地优化的方法,因此只能先存在到别的地方再移回去,如果你有更好的方法,欢迎分享.
```js
gulp.task("mv",function() {
    return gulp.src("./dst/*")
    .pipe(plugins.shell([
        "cp -r ./dst/* ./public/"
    ]));
});
```
###### 3.8 额外的说明
需要说明的是,由于`mv`任务会将优化后的文件移回`public`目录,如果运行了`watch`任务,可能会造成循环任务.我没有开启后台监听任务,我是在外包shell脚本中运行`gulp`任务并提交代码.
另外,`clean`任务,`mv`任务和其他任务之间是有顺序依赖的,`clean`任务需要最先执行,`mv`任务最后执行,如果写在一个任务中(如作为`default`任务的依赖),可能会由于异步执行的原因导致一些不可预期的结果.
###### 3.9 优化效果
我的博客目前所有静态文件均经过了优化压缩,可以通过右键查看源码.
![](http://ww4.sinaimg.cn/mw690/62d95157gw1f14m6xopnuj21gl0dsk1w.jpg)


#### 3.14日更新
针对上述`3.8`节额外说明第二点任务依赖的问题，随着近期gulp实践中的进一步了解，有了更好的解决方式，将此种情形下的"半自动化"提升到"全自动化"方式。免去了需要人为先执行一遍`clean`任务的步骤。

可以通过gulp的`stream`来解决任务依赖。亦即使gulp变成串行运行任务。
```
gulp.task("clean",function(){
    ...
});

gulp.task("js",["clean"],function(){
    var stream = gulp.src(...)          //执行操作
        .pipe(...)
        .pipe(...);
    return stream;                      //返回stream表示任务已经完成
});

gulp.task("css",["clean"],function(){ 
    var stream = gulp.src(...)
        .pipe(...);
    return stream;
});

gulp.task("defaul",["css","js"]);       //虽然clean任务作为依赖被调用了两次但并不会被执行两次，
                                        //css和js任务将异步执行，clean任务作为依赖将在执行完以后再执行主体任务
```

