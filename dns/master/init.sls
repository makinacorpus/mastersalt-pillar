{% import "makina-states/dns/common.sls" as common with context %}
makina-states.services.dns.bind: true
# for each dns zones declared in the database, make the appropriate
# pillar entry for it
{% macro rrs(domain) %}
{%- set infos  = salt['mc_pillar.get_nss_for_zone'](domain) %}
{%- set master  = infos['master'] %}
{%- set slaves  = infos['slaves'] %}
{%- set slavesips = [] %}
{%- for s in slaves %}
{%-   do slavesips.append('key "{0}"'.format(salt['mc_pillar.ip_for'](s))) %}
{%- endfor %}
{% if slaves %}
  allow_transfer: {{slavesips}}
  {% set soans = slaves.keys()[0] %}
{% else %}
  {% set soans = master %}
{% endif %}
  serial: {{salt['mc_pillar.serial_for'](domain) }}
  soa_ns: {{soans}}.
  soa_contact: postmaster.{{domain}}.
  rrs: |
{{salt['mc_pillar.rrs_for'](domain)}}
{% endmacro %}

{%set altdomains = [] %}
{% for domains in salt['mc_pillar.query'](
                'managed_alias_zones').values() %}
{%  do altdomains.extend(domains) %}
{% endfor %}

{% for domain in salt['mc_pillar.query']('managed_dns_zones') %}
{%  if domain not in altdomains %}
makina-states.services.dns.bind.zones.{{domain}}:
{{- rrs(domain)}}
{%  endif %}
{%  for altdomain in salt['mc_pillar.query'](
                'managed_alias_zones').get(domain, []) %}
makina-states.services.dns.bind.zones.{{altdomain}}:
{{-   rrs(domain).replace(domain, altdomain)}}
{%  endfor %}
{% endfor %}

{% set dnsslaves = salt['mc_pillar.get_slaves_for'](
                              opts['id'])['all']  %}
{% if dnsslaves %}
# slave tsig declaration
makina-states.services.dns.bind.slaves:
  {%for slv in dnsslaves%}
  - {{salt['mc_pillar.ip_for'](slv)}}
  {%endfor%}

{% for dn in dnsslaves %}
{{common.slave_key(dn)}}
makina-states.services.dns.bind.servers.{{salt['mc_pillar.ip_for'](dn)}}:
  keys: [{{salt['mc_pillar.ip_for'](dn)}}]
{% endfor %}
{% endif %}
