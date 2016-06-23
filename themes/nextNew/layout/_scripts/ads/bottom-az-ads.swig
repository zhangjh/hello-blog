<!--Amazon广告-->
  <script>
    var width = document.body.clientWidth;
    var height = document.body.clientHeight;
	//宽屏广告
	var widthAds = [
		"//rcm-cn.amazon-adsystem.com/e/cm?t=dante-23&o=28&p=48&l=ur1&category=books&banner=0792752JZQ695PSS3KR2&f=ifr",
		"//rcm-cn.amazon-adsystem.com/e/cm?t=dante-23&o=28&p=48&l=ur1&category=books&banner=0NR02GSKQEQ0SRZC6TR2&f=ifr",
		"//rcm-cn.amazon-adsystem.com/e/cm?t=dante-23&o=28&p=48&l=ur1&category=books&banner=0A227TKG9322B3XY3RG2&f=ifr",
		"//rcm-cn.amazon-adsystem.com/e/cm?t=dante-23&o=28&p=48&l=ur1&category=books&banner=0X0KYAECHNJESMDPPVG2&f=ifr",
		"//rcm-cn.amazon-adsystem.com/e/cm?t=dante-23&o=28&p=48&l=ur1&category=books&banner=1MDZGK9E9MAC48RFDBG2&f=ifr",
		"//rcm-cn.amazon-adsystem.com/e/cm?t=dante-23&o=28&p=48&l=ur1&category=books&banner=0ZE9A0W562GXCD46ZZ82&f=ifr",
		"//rcm-cn.amazon-adsystem.com/e/cm?t=dante-23&o=28&p=48&l=ur1&category=books&banner=1BQ7HHBP0VJ4EP6R2202&f=ifr",
		"//rcm-cn.amazon-adsystem.com/e/cm?t=dante-23&o=28&p=48&l=ur1&category=books&banner=1GWD9X0D8VBA5ZMCR182&f=ifr"
	];
	//窄屏广告
	var squareAds = [
		"//rcm-cn.amazon-adsystem.com/e/cm?t=dante-23&o=28&p=12&l=ur1&category=books&banner=17QS543P7Q3HA98XZV82&f=ifr",
		"//rcm-cn.amazon-adsystem.com/e/cm?t=dante-23&o=28&p=12&l=ur1&category=books&banner=0MYHTGGE85NRFT2HWD82&f=ifr",
		"//rcm-cn.amazon-adsystem.com/e/cm?t=dante-23&o=28&p=12&l=ur1&category=books&banner=037Q1SHMERMRJ82PA7R2&f=ifr",
		"//rcm-cn.amazon-adsystem.com/e/cm?t=dante-23&o=28&p=12&l=ur1&category=books&banner=13KHSWM8QK53P2BAMKG2&f=ifr",
		"//rcm-cn.amazon-adsystem.com/e/cm?t=dante-23&o=28&p=12&l=ur1&category=books&banner=1JBWHCFQYWBM1B3M9V02&f=ifr",
		"//rcm-cn.amazon-adsystem.com/e/cm?t=dante-23&o=28&p=12&l=ur1&category=books&banner=178RNKETN7QTJC5BPR82&f=ifr",
		"//rcm-cn.amazon-adsystem.com/e/cm?t=dante-23&o=28&p=12&l=ur1&category=books&banner=1N4AHFJRK48P743G2QR2&f=ifr",
		"//rcm-cn.amazon-adsystem.com/e/cm?t=dante-23&o=28&p=12&l=ur1&category=books&banner=1WBTNK2HJQF8QHK2R682&f=ifr"
	];
	if(width > height){
		//宽屏
		var ad_pc = '<iframe id="amazon_ads" src="" width="728" height="90" scrolling="no" border="0" marginwidth="0" style="border:none;max-width:800px;max-height:600px;" frameborder="0"></iframe>';
		$("#bottom_ads").html(ad_pc);
		var rand = Math.floor(Math.random() * widthAds.length);
		$("#amazon_ads").attr("src",widthAds[rand]);
	}else {
		var ad_mobile = '<iframe id="amazon_ads" src="" width="300" height="250" scrolling="no" border="0" marginwidth="0" style="border:none;max-width:800px;max-height:600px;" frameborder="0"></iframe>';
		$("#bottom_ads").html(ad_mobile);
		var rand = Math.floor(Math.random() * squareAds.length);
		$("#amazon_ads").attr("src",squareAds[rand]);
	}
  </script>

