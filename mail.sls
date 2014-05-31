{% set mail_conf= salt['mc_pillar.get_mail_configuration'](opts.id) %}
{% set id = opts['id'] %}
{% set smtp_relay_auth=True %}
{% set dest=mail_conf.default_dest.format(id=id) %}
makina-states.services.mail.postfix: true
makina-states.services.mail.postfix.mode: {{mail_conf.mode}}

{% if mail_conf.get('transports') %}
makina-states.services.mail.postfix.transport:
{%    for entry, host in mail_conf['transports'].items() %}
{%      if entry != '*' %}
  - transport: {{entry}}
    nexthop: relay:[{{host}}]
{%      endif %}
{%    endfor %}
{%    if '*' in mail_conf['transports'] %}
  - nexthop: relay:[{{mail_conf['transports']['*']}}]
{%    endif %}
{% endif %}


{% if mail_conf.auth %}
makina-states.services.mail.postfix.auth: true
makina-states.services.mail.postfix.sasl_passwd:
{%  for entry, host in mail_conf.smtp_auth.items() %}
  - entry: '{{'[{0}]'.format(entry)}}'
    user: {{host.user}}
    password: {{host.password}}
{%  endfor%}
{%endif%}

{% if mail_conf.get('virtual_map') %}
makina-states.services.mail.postfix.virtual_map:
{%- for record in mail_conf['virtual_map'] %}
{%- for item, val in record.items() %}
  "{{ item.format(id=id, dest=dest) }}": "{{val.format(id=id, dest=dest)}}"
{%  endfor %}
{%  endfor %}
{%- endif %}
