<meta charset="UTF-8"/>
<meta http-equiv="Content-Language" Content="zh-CN" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"/>

<meta name="referrer" content="no-referrer">


{# #238, Disable Baidu tranformation #}
<meta http-equiv="Cache-Control" content="no-transform" />
<meta http-equiv="Cache-Control" content="no-siteapp" />

{# 设置缓存时间 10天（864000）#}
<meta http-equiv="Cache-Control" content="max-age=864000" />

{% if theme.google_site_verification %}
  <meta name="google-site-verification" content="{{ theme.google_site_verification }}" />
{% endif %}


{% if theme.baidu_site_verification %}
  <meta name="baidu-site-verification" content="{{ theme.baidu_site_verification }}" />
{% endif %}

{% if theme.baidu_union_verification %}
	<meta name="baidu_union_verify" content="{{ theme.baidu_union_verification }}">
{% endif %}


{% if theme.qihu_site_verification %}
  <meta name="360-site-verification" content="{{ theme.qihu_site_verification }}" />
{% endif %}


{% if theme.fancybox %}
  <link href="{{ url_for(theme.vendors) }}/fancybox/source/jquery.fancybox.css?v=2.1.5" rel="stylesheet" type="text/css"/>
{% endif %}


{% if theme.use_font_lato %}
  <link href="//fonts.useso.com/css?family=Lato:300,400,700,400italic&subset=latin,latin-ext" rel="stylesheet" type="text/css">
{% endif %}


<link href="{{ url_for(theme.vendors) }}/font-awesome/css/font-awesome.min.css?v=4.4.0" rel="stylesheet" type="text/css" />

<link href="{{ url_for(theme.css) }}/main.css?v={{ theme.version }}" rel="stylesheet" type="text/css" />

<link rel="canonical" href="https://zhangjh.me" />

{% if page.keywords %}
  <meta name="keywords" content="{{ page.keywords }}" />
{% elif page.tags and page.tags.length %}
  <meta name="keywords" content="{% for tag in page.tags %}{{ tag.name }},{% endfor %}" />
{% elif theme.keywords %}
  <meta name="keywords" content="{{ theme.keywords }}" />
{% endif %}


{% if theme.rss === '' and config.feed and config.feed.path %}
  {% set theme.rss = config.root + config.feed.path %}
{% endif %}
{% if theme.rss %}
  <link rel="alternate" href="{{ url_for(theme.rss) }}" title="{{ config.title }}" type="application/atom+xml" />
{% endif %}


{% if theme.favicon %}
  <link rel="shortcut icon" type="image/x-icon" href="{{ url_for(theme.favicon) }}?v={{ theme.version }}" />
{% endif %}


{% if theme.facebook_sdk.enable and theme.facebook_sdk.webmaster %}
  <meta property="fb:admins" content="{{ theme.facebook_sdk.fb_admin }}" />
  <meta property="fb:app_id" content="{{ theme.facebook_sdk.app_id }}" />
{% endif %}


{{
  open_graph({
    twitter_id: theme.twitter,
    google_plus: theme.google_plus,
    fb_admins: theme.fb_admins,
    fb_app_id: theme.fb_app_id
  })
}}


{# Export some HEXO Configurations to Front-End #}
<script type="text/javascript" id="hexo.configuration">
  var CONFIG = {
    scheme: '{{ theme.scheme }}',
    sidebar: '{{ theme.sidebar }}',
    motion: {{ theme.use_motion }}
  };
</script>

<!--jquery提前加载-->
<!--script type="text/javascript" src="{{ url_for(theme.vendors) }}/jquery/index.js?v=2.1.3"></script-->
<script src="https://dante.oss-cn-hangzhou.aliyuncs.com/index.js?v=2.1.3"></script>
