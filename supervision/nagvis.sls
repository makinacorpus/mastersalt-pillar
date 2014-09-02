{% set id = opts.id %}
makina-states.services.monitoring.nagvis: {{ salt['mc_pillar.get_supervision_nagvis_conf'](id) }}
