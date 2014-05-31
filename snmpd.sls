{% set data = salt['mc_pillar.get_snmpd_settings'](opts.id) %}
{% set service = 'makina-states.services.monitoring.snmpd' %}
{{service}}: true
{{service}}.default_user: "{{data.user}}"
{{service}}.default_password: "{{data.password}}"
{{service}}.default_key: "{{data.key}}"
{% set service = 'makina-states.services.monitoring.client' %}
{{service}}: true
