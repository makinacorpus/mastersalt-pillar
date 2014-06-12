{% if salt['mc_pillar.is_burp_server'](opts.id)%}
{% set conf = salt['mc_pillar.backup_server_settings_for'](opts.id) %}
makina-states.services.backup.burp.server: true
{% for host, conf in conf.confs.items() %}
{% if conf.type in ['burp'] %}
makina-states.services.backup.burp.clients.{{host}}: {{ conf.conf | yaml}}
{% endif %}
{% endfor %}
{% endif %}
