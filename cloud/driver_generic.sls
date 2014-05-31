{% set configuration = salt['mc_pillar.get_configuration'](opts.id) %}
makina-states.cloud.generic: true
makina-states.cloud.master: {{configuration.mastersaltdn}}
makina-states.cloud.master_port: {{configuration.mastersalt_port}}
