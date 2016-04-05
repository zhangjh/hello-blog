<!--google广告-->
  <script>
    var width = document.body.clientWidth;
    var height = document.body.clientHeight;
	if(width > height){
		var ad_pc = '<iframe src="//rcm-cn.amazon-adsystem.com/e/cm?t=dante-23&o=28&p=48&l=ur1&category=books&banner=0792752JZQ695PSS3KR2&f=ifr" width="728" height="90" scrolling="no" border="0" marginwidth="0" style="border:none;" frameborder="0"></iframe>';
		$("#bottom_ads").html(ad_pc);
	}else {
		var ad_mobile = '<iframe src="//rcm-cn.amazon-adsystem.com/e/cm?t=dante-23&o=28&p=12&l=ur1&category=books&banner=037Q1SHMERMRJ82PA7R2&f=ifr" width="300" height="250" scrolling="no" border="0" marginwidth="0" style="border:none;" frameborder="0"></iframe>';
		$("#bottom_ads").html(ad_mobile);
	}
  </script>

