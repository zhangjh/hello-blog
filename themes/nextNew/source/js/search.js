/*
	Des:网盘搜索工具的js文件
	Date：3.25 2016
*/
var closeE = $("#close");
var tipsE = $(".tips");
var desBtn = $("#desBtn");

function showTips (argument) {
	var cookie = document.cookie.split(";");
	var i=0,len=cookie.length;
	for(;i<len;i++){
		if(cookie[i].indexOf("hide") !== -1){
			break;
		}
	}
	if(i === len){
		tipsE.show();
	} 
}

/*window.onload = function  (argument) {
	console.log($(".gsc-search-button gsc-search-button-v2").html());
	$(".gsc-search-button gsc-search-button-v2").attr("src","http://www.easyicon.net/api/resizeApi.php?id=1100921&size=48");
}*/

closeE.on("click",function  () {
	 $(".tips").hide();
	 document.cookie  = "hide=true"; 
});

desBtn.on("click",function  (argument) {
	 $("#content").toggle("quick");
});

var height = document.body.clientHeight;
var width = document.body.clientWidth;
$(".container").css({"margin-top": height/2,"margin-bottom": height/2});
	
showTips();

var t = setInterval(function(){
	if($(".gsc-search-button").length){
		//$(".gsc-control-cse").css({"width":"350px !important"});
        //隐藏warning
        $("#warning").hide();
        $(".gsc-search-button").attr("src","http://www.easyicon.net/api/resizeApi.php?id=1100921&size=48");
		clearInterval(t);
	}
},50);
				

//适配手机
if(screen.availHeight > screen.availWidth){
	$("#title h1").css({"font-size":"20px"});
}
