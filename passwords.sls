{# set the root & sysdmadmin user passwords
   by default same password is used for root & sysadmin
#}
{% macro set_passwords(dn=None) %}
{% set passwords = salt['mc_pillar.get_passwords'](dn) %}
makina-states.localsettings.admin.root_password: {{passwords.crypted.root}}
makina-states.localsettings.admin.sysadmin_password: {{passwords.crypted.sysadmin}}
{% for user, password in passwords.crypted.items() %}
{% if user not in ['root', 'sysadmin']%}
makina-states.localsettings.users.{{user}}.password: {{password}}
{% endif %}
{% endfor %}
{% endmacro %}
{{ set_passwords(opts.id) }}
