var gulp = require('gulp');
var babel = require('gulp-babel');
var plugins = require('gulp-load-plugins')();

gulp.task("clean",function() {
    return gulp.src("./public/*")
    .pipe(plugins.clean());
});

gulp.task("css",function(){
    var stream = gulp.src(["public/**/*.css","!public/**/*.min.css"])
        .pipe(plugins.minifyCss({compatibility: 'ie8'}))
        .pipe(gulp.dest("./public/"));
    return stream;
});

gulp.task("js",function(){
    var stream = gulp.src(["public/**/*.js","!public/**/*.min.js"])
		.pipe(babel({presets: ['env']}))
        .pipe(plugins.uglify())
        .pipe(gulp.dest("./public/"));
    return stream;
});

gulp.task("html",function(){
    var stream = gulp.src("public/**/*.html")
        .pipe(plugins.minifyHtml())
        //.pipe(plugins.rename({suffix: ".gulp"}))
        .pipe(gulp.dest("./public/"));
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

gulp.task("default",["html","css","js"],function(){
    console.log("gulp task ok!");
});

