{# take a and list of groups as input
   This setup the groups allowed to login via ssh #}
{% macro set_ssh_groups(dn=None) %}
makina-states.services.base.ssh.server.allowgroups: {{salt['mc_pillar.get_ssh_groups'](dn)|yaml}}
{% endmacro %}
{{set_ssh_groups(opts.id)}}
