<!doctype html>
<html class="theme-next {% if theme.use_motion %}  use-motion {% endif %}">
<head>
  {% include '_partials/head.swig' %}
  <title>{% block title %}{% endblock %}--一个理想主义文青的IT自留地</title>
  <style>
    #msg-tip {
      background-color: orangered;
      color: white;
      position: fixed;
      top: 50px;
      right: 10px;
      z-index: 2;
      display: none;
      cursor: pointer;
    }
    #msg-modal {
      position: fixed;
      top: 20%;
      left: 50%;
      width: 400px;
      margin-left: -200px;
      z-index: 2;
      -webkit-box-shadow: 0 5px 15px rgba(0, 0, 0, .5);
      -moz-box-shadow: 0 5px 15px rgba(0, 0, 0, .5);
      box-shadow: 0 5px 15px rgba(0, 0, 0, .5);
      padding: 5px 20px;
      background: white;
      display: none;
    }
    #msg-modal h5 {
      float: left;
    }
    #msg-modal .close {
      float: right;
    }
    #modal-body {
      clear: both;
    }
    #modal-body .item a {
      color: #219bde;
    }
  </style>
</head>

<body>
  <div id="msg-tip">
    ❗️你有<span>0</span>条未读消息
  </div>

  <div id="msg-modal">
    <div id="modal-header">
      <h5>消息列表</h5>
      <span class="close">X</span>
    </div>
    <div id="modal-body">

    </div>
  </div>

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
	<!--多说评论-->
	{% block comment_system %}
      {% include '_scripts/comments/duoshuo.swig' %}
	  {% include '_scripts/comments/disqus.swig' %}
	  {% include '_scripts/comments/changyan.swig' %}
	  {% include '_scripts/comments/comment.swig' %}
	{% endblock %}

    <footer id="footer" class="footer">
      <div class="footer-inner">
        {% include '_partials/footer.swig' %}
		<!--访问统计-->
		<br>
		{% include '_scripts/analytics.swig' %}
      </div>
    </footer>

    <div class="back-to-top"></div>
  </div>


  {# This block is used to set options before any other scripts run #}
  {% block script_extra_before %}{% endblock %}

  <script type="text/javascript" src="{{ url_for(theme.vendors) }}/fastclick/lib/fastclick.min.js?v=1.0.6"></script>
  <script type="text/javascript" src="{{ url_for(theme.vendors) }}/jquery_lazyload/jquery.lazyload.js?v=1.9.7"></script>

  {% include '_scripts/fancy-box.swig' %}
  {% include '_scripts/helpers.swig' %}
  {% include '_scripts/motion.swig' %}

  {% block script_extra %}{% endblock %}

  <script type="text/javascript" src="{{ url_for(theme.js) }}/bootstrap.js"></script>

  {% include '_scripts/tinysou.swig' %}
  {% include '_scripts/mathjax.swig' %}
  {% block comment_system %}{% endblock %}
  {% include '_scripts/baidushare.swig' %}

  <script src="/js/mouseEffect.js"></script>
  <script src="/js/custom.js"></script>
</body>
</html>
