{% set id = opts.id %}
makina-states.services.monitoring.icinga2: {{ salt['mc_pillar.get_supervision_master_conf'](id) }}
makina-states.services.monitoring.icinga2.modules.cgi.enabled: false
