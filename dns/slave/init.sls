{% import "makina-states/dns/common.sls" as common with context %}
makina-states.services.dns.bind: true
# slave zone declaration
{% set dnsmasters = {} %}
{% set domains = salt['mc_pillar.get_slaves_zones_for'](opts['id']) %}
{% for domain, masterdn in domains.items() %}
{%  set master = common.ip_for(masterdn) %}
{%  if not masterdn in dnsmasters %}
{%    do dnsmasters.update({masterdn: master}) %}
{%  endif %}
makina-states.services.dns.bind.zones.{{domain}}:
  server_type: slave
  masters: [{{master}}]
{% endfor %}

{% for dnsmaster, masterip in dnsmasters.items() %}
{{  common.slave_key(opts['id'], dnsmaster, master=False)}}
{% endfor %}
