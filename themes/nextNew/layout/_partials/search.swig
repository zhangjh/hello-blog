{% if theme.swiftype_search %}
  {% include 'search/swiftype.swig' %}
{% elseif theme.baidu_search %}
  {% include 'search/baidu.swig' %}
{% elseif theme.tinysou_Key %}
  {% include 'search/tinysou.swig' %}
{% endif %}
