<!-- jd 底部宽幅广告 -->
<div id="jd_channel">
	<script>
		var w = document.body.clientWidth,
			h = document.body.clientHeight;
		var jd_union_euid="";
		var w_jd_union_pid = [418069133,418076177,418077094],
			h_jd_union_pid = [418082137,418074315,418080094];
		if(w > h){
			//宽屏广告
			var rand = Math.floor(Math.random() * w_jd_union_pid.length);
			var jd_union_pid = w_jd_union_pid[rand];
		}else {
			//窄屏广告
			var rand = Math.floor(Math.random() * h_jd_union_pid.length);
			var jd_union_pid = h_jd_union_pid[rand];
		}
	</script>
	<script src="//ads.union.jd.com/static/js/union.js"></script>
</div>
