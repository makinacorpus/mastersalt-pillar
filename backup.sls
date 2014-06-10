{% set conf = salt['mc_pillar.get_configuration'](opts['id']) %}
{% set mode = conf.backup_mode %}
{% if mode == 'rdiff' %}
makina-states.services.backup.rdiff-backup: true
{% elif 'burp' in mode  %}
makina-states.services.backup.burp.client: true
{% endif %}
