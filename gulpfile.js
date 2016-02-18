var gulp = require('gulp');
var plugins = require('gulp-load-plugins')();

gulp.task("css",function(){
    return gulp.src("public/**/*.css")
    .pipe(plugins.minifyCss({compatibility: 'ie8'}))
    .pipe(gulp.dest("./dst/"));
});

gulp.task("js",function(){
    return gulp.src("public/**/*.js")
    .pipe(plugins.uglify())
    .pipe(gulp.dest("./dst/"));
});

gulp.task("html",function(){
    return gulp.src("public/**/*.html")
    .pipe(plugins.minifyHtml())
    //.pipe(plugins.rename({suffix: ".gulp"}))
    .pipe(gulp.dest("./dst/"));
});

gulp.task("default",["css","js","html"],function(){
    console.log("gulp task ok!");
});

