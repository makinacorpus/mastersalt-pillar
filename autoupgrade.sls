{% set vars = salt['mc_pillar.get_makina_states_variables'](opts.id) %}
{% set gconf = salt['mc_pillar.get_configuration']() %}
{% set id = opts.id %}
makina-states.localsettings.autoupgrade: {{gconf.manage_autoupgrades}}

