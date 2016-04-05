<div class="copyright" >
  {% set current = date(Date.now(), "YYYY") %}
  &copy; {% if theme.since and theme.since != current %} {{ theme.since }} - {% endif %}
  <span itemprop="copyrightYear">{{ current }}</span>
  <span class="with-love">
    <i class="icon-next-heart fa fa-heart"></i>
  </span>
  <span class="author" itemprop="copyrightHolder">{{ config.author }}</span>
</div>

<div class="powered-by">
  {{ __('footer.powered', '<a class="theme-link" href="//hexo.io">Hexo</a>') }}
</div>

<div class="powered-by">
  <a href="http://www.miitbeian.gov.cn/">浙ICP备16000871号</a>
</div>

<div class="theme-info">
  {{ __('footer.theme') }} -
  <a class="theme-link" href="javascript:;">
    NexT{% if theme.scheme %}.{{ theme.scheme }}{% endif %}
  </a>
</div>

{% block footer %}{% endblock %}
