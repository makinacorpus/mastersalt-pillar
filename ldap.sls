{% set conf = salt['mc_pillar.get_ldap_configuration'](opts.id) %}
makina-states.localsettings.ldap:
  ldap_uri: {{conf.ldap_uri}}
  ldap_base: {{conf.ldap_base}}
  ldap_passwd: {{conf.ldap_passwd}}
  ldap_shadow: {{conf.ldap_shadow}}
  ldap_group: {{conf.ldap_group}}
  ldap_cacert: {{conf.ldap_cacert}}
  enabled: {{conf.enabled}}
  nslcd:
    ssl: {{conf.nslcd.ssl}}

