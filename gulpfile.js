var gulp = require('gulp');
var plugins = require('gulp-load-plugins')();

gulp.task("clean",function() {
    return gulp.src("./dst/*")
    .pipe(plugins.clean());
});

gulp.task("css",["clean"],function(){
    var stream = gulp.src(["public/**/*.css","!public/**/*.min.css"])
        .pipe(plugins.minifyCss({compatibility: 'ie8'}))
        .pipe(gulp.dest("./dst/"));
    return stream;
});

gulp.task("js",["clean"],function(){
    var stream = gulp.src(["public/**/*.js","!public/**/*.min.js"])
        .pipe(plugins.uglify())
        .pipe(gulp.dest("./dst/"));
    return stream;
});

gulp.task("html",["clean"],function(){
    var stream = gulp.src("public/**/*.html")
        .pipe(plugins.minifyHtml())
        //.pipe(plugins.rename({suffix: ".gulp"}))
        .pipe(gulp.dest("./dst/"));
    return stream;
});

gulp.task("mv",["html","css","js"],function() {
    var stream = gulp.src("./dst/*")
        .pipe(gulp.dest("./public/"));
        /*.pipe(plugins.shell([
            "cp -r ./dst/* ./public/"
        ]));
        */
    return stream;
});

gulp.task("watch",function() {
    gulp.watch("public/*",["optimise"]);
});

gulp.task("default",["mv"],function(){
    console.log("gulp task ok!");
});

