{% set configuration = salt['mc_pillar.get_configuration'](opts.id) %}
{% if configuration.get('cloud_images') %}
{% for img, data in configuration['cloud_images'].items() %}
{{img}}:
  {% for k, v in data.items() %}
    "{{k}}": {{v}}
  {% endfor %}
{% endfor %}
{% endif %}
