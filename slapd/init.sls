{% set id = opts.id %}
{% set data = salt['mc_pillar.get_slapd_conf'](id) %}
makina-states.services.dns.slapd: true
{% for k in ['tls_cacert', 'tls_cert', 'tls_key'] %}
{% set val = data.get(k, None) %}
{% if val %}
{# handle multiline strings #}
makina-states.services.dns.slapd.{{k}}: |
                                        {{val.replace('\n',
'\n                                        ')}}
{% endif %}
{% endfor %}
{% for k in ['mode', 'config_pw', 'root_dn', 'dn', 'root_pw'] %}
{% set val = data.get(k, None) %}
{% if val %}
makina-states.services.dns.slapd.{{k}}: {{val}}
{% endif %}
{% endfor %}
