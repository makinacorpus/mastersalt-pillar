{# configure shorewall for a particular host #}
{% macro shorewall(dn=None) %}
{% for param, value in salt['mc_pillar.get_shorewall_settings'](opts.id).items()  %}
{{param}}: {{value}}
{% endfor %}
{% endmacro %}
{{ shorewall(opts['id']) }}
