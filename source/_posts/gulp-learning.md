title: gulp入门初步--使用gulp压缩前端代码
show: true
date: 2016-02-19 09:43:28
tags: ["gulp","代码压缩"]
categories: 技术人生
---
#### gulp简介
gulp是一个前端项目构建工具,用自动化构建工具增强你的工作流程[gulp中文官网语](http://www.gulpjs.com.cn/)
gulp利用Node.js流的威力,减少了频繁的IO操作,让构建更快速,学习起来也是非常迅速.
本篇博客就将对使用gulp进行前端代码的压缩方面做一个入门级的介绍,也是我的gulp入门学习总结.

#### 安装
1. 首先假设已经安装了node环境,如果没有安装请出门左转[node官网](https://nodejs.org/)参考

2. 全局安装gulp
```js
npm install -g -d gulp 
```

3. 运行`gulp -v`,如果正常打印版本号则安装成功

<!--more-->

#### 安装常用插件
在项目根目录下安装gulp常用插件.
gulp的完全插件列表可以参考gulp的插件官网:[http://gulpjs.com/plugins/](http://gulpjs.com/plugins/).可以上去淘一淘插件.
比较常用的插件大概有:
- `gulp-minify-css         压缩css`
- `gulp-minify-html        压缩html`
- `gulp-uglify             压缩js`
- `gulp-rename             重命名文件,通常压缩后的带.min后缀`
- `gulp-jshint             jshint,js静态检查`
- `gulp-concat             合并多个文件`
- `gulp-imagemin           压缩图片`
- `gulp-clean              清理文件或目录`

安装:
    `npm install [plugins-name] --save`
    上述命令安装插件的同时也会把插件作为项目依赖写入package.json文件.

#### gulp API
##### gulp.src(globs)
- src用来指明待处理文件的路径,globs参数必填(源文件路径)
- globs参数string或array类型
- 可以使用通配符,*表示匹配一层目录,**表示匹配所有子目录
- 具体实例:
    ```js
        gulp.src("js/a.js");              //指定js目录下a.js文件
        gulp.src("js/*.js");              //指定js目录下任意js文件
        gulp.src("js/**/*.js");           //指定js目录下所有js文件,包括任意子目录
        gulp.src(["js/**/*.js","!js/**/*.min.js"])   //指定js目录下所有非压缩js文件
    ```

##### gulp.dest(path)
- dest用来指明处理完以后的文件存放路径(目的文件路径)
- 如果path不存在会自动创建
- 具体实例:
    ```js
        gulp.src("js/a.js")
        .pipe(gulp.uglify())
        .pipe(gulp.dest("dst/js/"))        //将js/a.js处理完以后输出到dst/js目录下,保持原名
    ```

##### gulp.task(name[,deps],fn)
- name,任务的名字
- deps,任务依赖的别的任务的名字,string或array,依赖任务完成以后才会执行当前任务
- fn,任务操作函数
- 实例:
    ```js
        gulp.task("example",["task1","task2"],function(){
            //做一些事情
        });
    ```
- 任务甚至可以支持异步执行,只要fn能做到以下其中一点:
    1. 接受一个回调函数
        实例来自gulp中文官网.
        ```js
        var exec = require('child_process').exec;
        gulp.task('jekyll',function(cb) {
            exec('jekyll build',function(err) {
                if(err)return cb(err);
                cb();
            });
        });
        ```
    2. 返回一个stream
        ```js
        gulp.task('somename',function(){
            var stream = gulp.src('client/**/*.js')
                .pipe(minify())
                .pipe(gulp.dest('build'));
            return stream;
        });
        ```
    3. 返回一个promise
        ```js
        gulp.task('somename',function() {
            return new Promise(function(resolve,reject){
                //做一些事
            });
        });
        ```
##### gulp.watch(glob [,opts],tasks)
- watch方法用来监听文件变化,文件一修改就会执行指定任务
- 实例:
    ```js
    gulp.task("watchtask",function() {
        gulp.watch('js/*.js',[js]);            //如果js目录下的js文件变化,则执行js任务
        gulp.watch('**/*.html',[html]);
    });
    ```
gulp一共就只有上述四个API.

#### 使用gulp压缩html,css,js
1. 我们利用上述gulp API来对项目的HTML,css,js文件进行压缩并设置监听,当文件有变动时自动运行任务

2. 实例
- 首先在项目根目录下创建gulpfile.js
- 加载插件
```js
var gulp = require('gulp'),
    minifyCss = require('gulp-minifyCss'),
    minifyHtml = require('gulp-minifyHtml'),
    uglify = require('gulp-uglify'),
    rename = require('gulp-rename'),
    clean = require('gulp-clean');
```
- 清理任务
```js
gulp.task("clean",function() {
    return gulp.src("dst/")
    .pipe(clean());
});
```
- 压缩html
```js
gulp.task("html",function() {
    return gulp.src("**/*.html")
    .pipe(minifyHtml())
    .pipe(gulp.dest("dst/html"));
});
```
- 压缩CSS
```js
gulp.task("css",function() {
    return gulp.src("**/*.css")
    .pipe(minifyCss())
    .pipe(rename({suffix:".min"}))
    .pipe(gulp.dest("dst/css"));
});
```
- 压缩JS
```js
gulp.task("js",function() {
    return gulp.src("**/*.js")
    .pipe(uglify())
    .pipe(rename({suffix:".min"}))
    .pipe(gulp.dest("dst/js"));
});
```
- 默认任务
```js
gulp.task("default",["clean","js","css","html"],function() {
    console.log("gulp task finished!");
});
```
以上默认任务在只执行`gulp`时,由于定义了依赖任务,会依次运行clean,js,css,html任务,等任务都运行完毕后结束.默认任务自身只输出一句提示.
- 监听任务
```js
gulp.task("watchtask",function() {
    gulp.watch("**/*.html",["html"]);
    gulp.watch("**/*.css",["css"]);
    gulp.watch("**/*.js",["js"]);
});
```
