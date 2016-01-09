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
<!-- dante notes II -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-1455071851805801"
     data-ad-slot="3790640639"
     data-ad-format="auto"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>

	<hr>
	<div id="bottom_ads">
	</div>

    
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
