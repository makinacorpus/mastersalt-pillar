{% set id = opts.id %}
makina-states.services.monitoring.pnp4nagios: {{ salt['mc_pillar.get_supervision_pnp_conf'](id) }}
