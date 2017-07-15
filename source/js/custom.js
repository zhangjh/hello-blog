/*
 * Des：用户自定义js脚本
 * Author：njhxzhangjihong@126.com
 * Date：6/17 2016
*/
//打赏
(function(){
	$("#rewardTip").click(function(){
		$("#dsWrapper").toggle("slow");
	});
})();

// 域名切换
(function(){
    var html = '<div style="width:600px;text-align:center;position:absolute;top:50%;left:50%;margin-left:-300px;margin-top:-300px;border:1px solid darkblue;border-radius:6px;padding:20px"><div>本站域名后续将切换为<a href="http://zhangjh.me"><span style="color:red;font-weight:bold;font-size:1.2em;font-style:oblique;">zhangjh.me(备案中暂时不能访问)</span></a></div>' + 
               '<div><span id="timer">3</span>秒后自动跳转</div></div>';

    var location = window.location.host;
    var pathname = window.location.pathname;
	if(location.indexOf("5941740") !== -1){
        $("body").html(html);
        var cnt = 2;
        var timer = setInterval(function(){
           $("#timer").text(cnt--);
		   if(cnt === 0){
              clearInterval(timer);
              window.location.href = "http://5941740.cn" + pathname;
           }
        },1000);
    }
    if(location.indexOf("zhangjh") !== -1){
      window.location.href = "http://5941740.cn" + pathname;
    }
})();
