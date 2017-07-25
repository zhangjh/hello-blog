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
  <!-- {{ __('footer.powered', '<a class="theme-link" href="//hexo.io">Hexo</a>') }} -->
  {% include '../_scripts/analytics/zhanzhang-analytics.swig' %}
</div>
<div class="powered-by">
  {{ __('footer.theme') }} -
  <a class="theme-link" href="javascript:;">
	NexT{% if theme.scheme %}.{{ theme.scheme }}{% endif %}
  </a>
</div>
<div class="powered-by-noline">
  <a href="/issue">网站大事记</a>
</div>

<div class="ba-wrapper">
	<div class="ba-info">
		<a target="_blank" href="http://www.miitbeian.gov.cn/">浙ICP备16000871-1号</a>
	</div>
	<div class="ba-info">
		<a target="_blank" href="http://www.beian.gov.cn/portal/registerSystemInfo?recordcode=33010802005049">
			<img src="/images/beian.png" />
			浙公网安备 33010802005049号
		</a>
	</div>
</div>

{% block footer %}
    {% if theme.firebase %}
        {% include '../_scripts/analytics/visit.swig' %}
    {% endif %}
{% endblock %}
