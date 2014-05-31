{% set conf = salt['mc_pillar.get_configuration'](opts['id'])%}
default_env: {{conf['default_env']}}
