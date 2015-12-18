<!doctype html>
<html class="theme-next {% if theme.use_motion %}  use-motion {% endif %}">
<head>
  {% include '_partials/head.swig' %}
  <title>{% block title %}{% endblock %}--一个理想主义文青的IT自留地</title>
</head>

<body>

  {% include '_partials/old-browsers.swig' %}

  <div class="container one-column {% block page_class %}{% endblock %}">
    <div class="headband"></div>

    <header id="header" class="header">
      <div class="header-inner"> {%- include '_partials/header.swig' %} </div>
    </header>

    <main id="main" class="main">
      <div class="main-inner">
        <div id="content" class="content">
          {% block content %}{% endblock %}
        </div>

        {% include '_partials/duoshuo-hot-articles.swig' %}
        {% include '_partials/comments.swig' %}
      </div>

      {% if theme.sidebar !== 'remove' %}
        {% block sidebar %}{% endblock %}
      {% endif %}
    </main>

    <footer id="footer" class="footer">
      <div class="footer-inner">
        {% include '_partials/footer.swig' %}
      </div>
    </footer>

    <div class="back-to-top"></div>
  </div>

  <script type="text/javascript" src="{{ url_for(theme.vendors) }}/jquery/index.js?v=2.1.3"></script>

  {# This block is used to set options before any other scripts run #}
  {% block script_extra_before %}{% endblock %}

  {% include '_scripts/fancy-box.swig' %}
  {% include '_scripts/helpers.swig' %}
  {% include '_scripts/motion.swig' %}

  <script type="text/javascript" src="{{ url_for(theme.vendors) }}/fastclick/lib/fastclick.min.js?v=1.0.6"></script>
  <script type="text/javascript" src="{{ url_for(theme.vendors) }}/jquery_lazyload/jquery.lazyload.js?v=1.9.7"></script>

  {% block script_extra %}{% endblock %}

  <script type="text/javascript" src="{{ url_for(theme.js) }}/bootstrap.js"></script>

  {% include '_scripts/tinysou.swig' %}
  {% include '_scripts/mathjax.swig' %}
  {% block comment_system %}{% endblock %}
  {% include '_scripts/baidushare.swig' %}
  
  <!--多说评论-->
  {% block comment_system %}
    {% include '_scripts/comments/duoshuo.swig' %}
    {% include '_scripts/comments/disqus.swig' %}
  {% endblock %}


  <!--访问统计-->
  {% include '_scripts/analytics.swig' %}
</body>
</html>
