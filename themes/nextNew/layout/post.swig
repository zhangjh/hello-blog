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
	<!--
	推荐书目：
	<div id="recommendBooks">
		{% include '_scripts/ads/jd_recommend_books.swig' %}
	</div>
	
	{% include '_scripts/ads/googleads.swig' %}

	<hr />
	-->
	<div id="bottom_ads">
		{% include '_scripts/ads/bottom-jd-ads.swig' %}
	</div>


    <div class="post-spread">
      {% if theme.jiathis %}
        {% include '_partials/share/jiathis.swig' %}
      {% elseif theme.duoshuo_shortname and theme.duoshuo_share %}
        {% include '_partials/share/duoshuo_share.swig' %}
      {% elseif theme.baidu_share %}
        {% include '_partials/share/baidu_share.swig' %}
      {% elseif theme.share_js %}
        {% include '_partials/share/share_js.swig' %}
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
