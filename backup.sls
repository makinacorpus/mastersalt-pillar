{% set conf = salt['mc_pillar.get_configuration'](opts['id']) %}
{% set mode = conf.backup_mode %}
{% if mode == 'rdiff' %}
makina-states.services.backup.rdiff-backup: true
{% elif mode == 'burp-server' %}
makina-states.services.backup.burp.server: true
{%    for host, conf in salt['mc_pillar.query'](
    'burp_configurations', q=opts['id']).items() %}
makina-states.services.backup.burp.clients.{{host}}: {{ conf | yaml}}
{%    endfor %}
{% elif mode == 'burp' %}
makina-states.services.backup.burp.client: true
{% endif %}
