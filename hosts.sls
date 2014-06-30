{% macro set_hosts(fqdn=None) %}
{% if not fqdn %}
{%  set fqdn = opts['id'] %}
{% endif %}
{% set net = salt['mc_pillar.load_network_infrastructure']() %}
{% set hosts = salt['mc_pillar.query']('hosts').get(opts['id'], []) %}
{% if hosts%}
makina-bosts:
{%- for entry in hosts %}{% set ip = entry.get('ip', salt['mc_pillar.ip_for'](fqdn)) %}
  - ip: {{ip}}
    hosts: "{{entry.hosts}}"
{% endfor %}
{% endif %}
{% endmacro %}
{{set_hosts(opts.id)}}
