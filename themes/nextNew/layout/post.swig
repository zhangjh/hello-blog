{% extends '_layout.swig' %}
{% import '_macro/post.swig' as post_template %}
{% import '_macro/sidebar.swig' as sidebar_template %}


{% block title %} {{ page.title }} | {{ config.title }} {% endblock %}

{% block page_class %}page-post-detail{% endblock %}


{% block content %}

  <div id="posts" class="posts-expand">
    {{ post_template.render(page) }}

	<!--底部广告内容-->
	<hr />
	推荐书目：
	<div id="recommendBooks">
		<a rel="nofollow" href="http://www.amazon.cn/gp/product/B00S4OK1ZS/ref=as_li_tf_tl?ie=UTF8&camp=536&creative=3200&creativeASIN=B00S4OK1ZS&linkCode=as2&tag=dante-23">三体全集</a>

		<a rel="nofollow" href="http://www.amazon.cn/gp/product/B00ZWTY2JO/ref=as_li_tf_tl?ie=UTF8&camp=536&creative=3200&creativeASIN=B00ZWTY2JO&linkCode=as2&tag=dante-23">无声告白 </a>
		<a rel="nofollow" href="http://www.amazon.cn/gp/product/B00NOQNHP2/ref=as_li_tf_tl?ie=UTF8&camp=536&creative=3200&creativeASIN=B00NOQNHP2&linkCode=as2&tag=dante-23">解忧杂货店</a>

		<a rel="nofollow" href="http://www.amazon.cn/gp/product/B007ED88CI/ref=as_li_tf_tl?ie=UTF8&camp=536&creative=3200&creativeASIN=B007ED88CI&linkCode=as2&tag=dante-23">奇思妙想:15位计算机天才及其重大发现</a>
		
		<a rel="nofollow" href="http://www.amazon.cn/gp/product/B0097CON2S/ref=as_li_tf_tl?ie=UTF8&camp=536&creative=3200&creativeASIN=B0097CON2S&linkCode=as2&tag=dante-23">JavaScript语言精粹(修订版)</a>

		<a rel="nofollow" href="http://www.amazon.cn/gp/product/B00NN8GJGA/ref=as_li_tf_tl?ie=UTF8&camp=536&creative=3200&creativeASIN=B00NN8GJGA&linkCode=as2&tag=dante-23">单页Web应用:JavaScript从前端到后端</a>
	</div>

<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- 底部自适应 -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-1455071851805801"
     data-ad-slot="5865926631"
     data-ad-format="auto"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>

	<hr>
	<div id="bottom_ads">
	</div>

    <script>
		var width = document.body.clientWidth;
		var height = document.body.clientHeight;
		if(width > height){
			var ad_pc = '<iframe src="http://rcm-cn.amazon-adsystem.com/e/cm?t=dante-23&o=28&p=48&l=ur1&category=books&banner=0792752JZQ695PSS3KR2&f=ifr" width="728" height="90" scrolling="no" border="0" marginwidth="0" style="border:none;" frameborder="0"></iframe>';
			$("#bottom_ads").html(ad_pc);
		}else {
			/*var content = '<SCRIPT charset="utf-8" type="text/javascript" src="http://ws-cn.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&MarketPlace=CN&ID=V20070822%2FCN%2Fdante-23%2F8003%2Fbaab5c6e-ff4b-41af-b676-14ee87f8d5a3&Operation=GetScriptTemplate"> <\/SCRIPT>';
			var content2 = '<NOSCRIPT><A rel="nofollow" HREF="http://ws-cn.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&MarketPlace=CN&ID=V20070822%2FCN%2Fdante-23%2F8003%2Fbaab5c6e-ff4b-41af-b676-14ee87f8d5a3&Operation=NoScript">Amazon.cn Widgets<\/A><\/NOSCRIPT>';	
			document.write(content);
			document.write(content2);*/

			var ad_mobile = '<iframe src="http://rcm-cn.amazon-adsystem.com/e/cm?t=dante-23&o=28&p=12&l=ur1&category=books&banner=037Q1SHMERMRJ82PA7R2&f=ifr" width="300" height="250" scrolling="no" border="0" marginwidth="0" style="border:none;" frameborder="0"></iframe>';
			$("#bottom_ads").html(ad_mobile);
		}
    </script>

    <div class="post-spread">
      {% if theme.jiathis %}
        {% include '_partials/share/jiathis.swig' %}
      {% elseif theme.duoshuo_shortname and theme.duoshuo_share %}
        {% include '_partials/share/duoshuo_share.swig' %}
      {% endif %}
    </div>
  </div>

{% endblock %}

{% block sidebar %}
  {{ sidebar_template.render(true) }}
{% endblock %}


{% block script_extra %}
  {% include '_scripts/pages/post-details.swig' %}
{% endblock %}
