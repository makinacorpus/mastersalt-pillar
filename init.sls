{% set vars = salt['mc_pillar.get_makina_states_variables'](opts.id) %}
{% set gconf = salt['mc_pillar.get_configuration'](opts.id) %}
{% set id = opts.id %}

include:
  {% if gconf.mastersalt_master %}
  - mastersalt
  {% else %}
  - mastersalt_minion
  {% endif %}
  - makina-states.env
  {# if a sls is present in minions/<id>.sls, load it #}
  {% if salt['mc_utils.sls_available'](vars.msls, pillar=True) %}
  - {{vars.msls}}
  {% endif %}
  {% if gconf.manage_network %}
  {%  if vars.is_bm %}
  - makina-states.autoupgrade
  - makina-states.network
  {%  endif %}
  {% endif %}
{#
#}
  {% if salt['mc_pillar.is_burp_server'](id)%}
  - makina-states.burp
  {% endif %}
  {% if (salt['mc_pillar.is_ldap_master'](id)
         or salt['mc_pillar.is_ldap_slave'](id)) %}
  - makina-states.slapd
  {% endif %}
  {% if salt['mc_pillar.is_dns_master'](id) %}
  - makina-states.dns.master
  {% endif %}
  {% if salt['mc_pillar.is_dns_slave'](id) %}
  - makina-states.dns.slave
  {% endif %}
  {% if gconf.cloud_master %}
  - makina-states.cloud
  {% endif %}
  {% if gconf.manage_backups %}
  - makina-states.backup
  {% endif %}
  {% if gconf.manage_packages %}
  - makina-states.packages
  {% endif %}
  {#
   Idea is to have
   - simple users gaining sudoer access
   - powerusers known as sysadmin have:
    - access to sysadmin user via ssh key
    - access to root user via ssh key
    - They are also sudoers with their username (trigramme)
   - ssh accesses are limited though access groups, so we also map here the groups
     which have access to specific machines
  #}
  {% if gconf.manage_passwords %}
  - makina-states.passwords
  {% endif %}
  {% if gconf.manage_sudoers %}
  - makina-states.sudoers
  {% endif %}
  {% if gconf.manage_ssh_keys %}
  - makina-states.ssh_keys
  {% endif %}
  {% if gconf.manage_ssh_groups %}
  - makina-states.ssh_groups
  {% endif %}
  {% if gconf.manage_ntp_server %}
  - makina-states.ntp_server
  {% endif %}
  {% if gconf.manage_hosts %}
  - makina-states.hosts
  {% endif %}
  {% if gconf.manage_shorewall %}
  - makina-states.shorewall
  {% endif %}
  {% if gconf.ldap_client %}
  - makina-states.ldap
  {% endif %}
  {% if gconf.manage_fail2ban %}
  - makina-states.fail2ban
  {% endif %}
  {% if gconf.manage_snmpd %}
  - makina-states.snmpd
  {% endif %}
  {% if gconf.manage_mails%}
  - makina-states.mail
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
