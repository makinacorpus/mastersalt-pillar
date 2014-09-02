{% set id = opts.id %}
makina-states.services.monitoring.icinga_web: {{ salt['mc_pillar.get_supervision_ui_conf'](id) }}
