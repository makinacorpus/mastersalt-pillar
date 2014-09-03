{% set vars = salt['mc_pillar.get_makina_states_variables'](opts.id) %}
{% set gconf = salt['mc_pillar.get_configuration'](opts.id) %}
{% set id = opts.id %}

include:
  {% if gconf.mastersalt_master %}
  - mastersalt
  {% else %}
  - mastersalt_minion
  {% endif %}
  {# if a sls is present in minions/<id>.sls, load it #}
  {% if salt['mc_utils.sls_available'](vars.msls, pillar=True) %}
  - {{vars.msls}}
  {% endif %}
  {% if vars.is_bm%}
  {%  for vt in vars.bms[vars.id] %}
  {%    if vt in vars.bm_vts_sls %}
  - {{vars.bm_vts_sls[vt]}}
  {%    endif %}
  {%  endfor %}
  {% endif %}
  {% if vars.is_vm and vars.vms[opts.id]['vt'] in vars.vts_sls %}
  - {{vars.vts_sls[vars.vms[opts.id]['vt']]}}
  {% endif %}
