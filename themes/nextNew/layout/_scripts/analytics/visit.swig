<script>
	//将反斜杠替换成下划线,并将中文decode
    var curUrl = decodeURI(window.location.pathname.replace(new RegExp('\\/|\\.', 'g'),"_"));
   
	var statUrl = "//favlink.cn/visit";

	// 总数
	$.ajax({
		url: statUrl,
		data: {
			url: "sum"
		}
	}).done(function(ret){
		if(ret.cnt > 1){
			if($("#totalCnt").length){
					$("#totalCnt").remove();
			}
			$("span.author").append(" | <span id='totalCnt'>自2016.4.12起总访问量：" + ret.cnt + "次");
		}
	});

	// 明细
	if(curUrl !== "_") {
		$.ajax({
			url: statUrl,
			data: {
				url: curUrl
			}
		}).done(function(ret){
			if(ret.cnt >1){
				$("#detail_cnt").text(ret.cnt);
			}	
		});
	}
</script>
