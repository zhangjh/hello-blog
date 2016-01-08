<script>
	(function(){
		var width = document.body.clientWidth;
		var height = document.body.clientHeight;
		console.log(width,height);
		if(width > height){
			var content = '<iframe src="http://rcm-cn.amazon-adsystem.com/e/cm?t=dante-23&o=28&p=48&l=ur1&category=books&banner=0792752JZQ695PSS3KR2&f=ifr" width="728" height="90" scrolling="no" border="0" marginwidth="0" style="border:none;" frameborder="0"></iframe>';
			$("#bottom_ads").html(content);
		}else {
			var content = '<SCRIPT charset="utf-8" type="text/javascript" src="http://ws-cn.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&MarketPlace=CN&ID=V20070822%2FCN%2Fdante-23%2F8003%2Fbaab5c6e-ff4b-41af-b676-14ee87f8d5a3&Operation=GetScriptTemplate"> <\/SCRIPT>';
			var content2 = '<NOSCRIPT><A rel="nofollow" HREF="http://ws-cn.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&MarketPlace=CN&ID=V20070822%2FCN%2Fdante-23%2F8003%2Fbaab5c6e-ff4b-41af-b676-14ee87f8d5a3&Operation=NoScript">Amazon.cn Widgets<\/A><\/NOSCRIPT>';	
			document.write(content);
			document.write(content2);
		}	
	})();
</script>

