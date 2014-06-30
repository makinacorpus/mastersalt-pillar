{# all the linked users in sudoer_map the database
   will be sudoers #}
{% macro set_sudoers(dn=None) %}
makina-states.localsettings.admin.sudoers: {{salt['mc_pillar.get_sudoers'](dn)|yaml}}
{% endmacro %}
{{set_sudoers(opts.id)}}
