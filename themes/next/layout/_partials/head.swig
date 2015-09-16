{% if theme.rss === '' and config.feed and config.feed.path %}
    {% set theme.rss = config.root + config.feed.path %}
{% endif %}
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta property="og:type" content="Website">
<meta property="og:description" content="www.5941740.cn Dante notes.">
<meta property="og:url" content="http://www.5941740.cn">
<meta property="og:image" content="http://www.5941740.cn/favicon.ico ">
<meta property="og:image:type" content="image/ico">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"/>
{% if theme.google_site_verification %}
  <meta name="google-site-verification" content="{{ theme.google_site_verification }}" />
{% endif %}
{% if config.qihu_site_verification %}
  <meta name="360-site-verification" content="{{ config.qihu_site_verification }}" />
{% endif %}
{% if theme.fancybox %}
  <link rel="stylesheet" type="text/css" href="{{ url_for(theme.vendors) }}/fancybox/source/jquery.fancybox.css?v=2.1.5"/>
{% endif %}
{% if config.language !== 'zh-Hans' and theme.use_font_lato %}
  <link href='http://fonts.googleapis.com/css?family=Lato:300,400,700,400italic&subset=latin,latin-ext' rel='stylesheet' type='text/css'>
{% endif %}
<link rel="stylesheet" type="text/css" href="{{ url_for(theme.css) }}/main.css?v={{ theme.version }}"/>
{% if config.description %}
    <meta name="description" content="{{ config.description }}" />
{% endif %}
{% if page.tags and page.tags.length %}
  <meta name="keywords" content="{% for tag in page.tags %}{{ tag.name }},{% endfor %}" />
{% elif theme.keywords %}
  <meta name="keywords" content="{{ theme.keywords }}" />
{% endif %}
{% if theme.rss %}
  <link rel="alternate" href="{{ url_for(theme.rss) }}" title="{{ config.title }}" type="application/atom+xml" />
{% endif %}
{% if theme.favicon %}
  <link rel="shortcut icon" type="image/x-icon" href="{{ url_for(theme.favicon) }}?v={{ theme.version }}" />
{% endif %}
{# HEXO CONFIGURATIONS #}
<script type="text/javascript" id="hexo.configuration">
  var CONFIG = {
    scheme: '{{ theme.scheme }}',
    analytics: {
      google: '{{ theme.google_analytics }}'
    },
    sidebar: '{{ theme.sidebar }}'
  };
</script>
