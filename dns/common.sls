{% set ip_for = salt['mc_pillar.ip_for'] %}
{% macro slave_key(dn, dnsmaster=None, master=True) %}
{% if not master %}
# on slave side, declare the master as the tsig
# key consumer
makina-states.services.dns.bind.servers.{{ip_for(dnsmaster)}}:
  keys: [{{ip_for(dn)}}]
{% endif %}
{# on both, say to encode with the client tsig key when daemons
  are talking to each other #}
makina-states.services.dns.bind.keys.{{ip_for(dn)}}:
  secret: "{{salt['mc_bind.tsig_for'](ip_for(dn))}}"
{% endmacro %}
