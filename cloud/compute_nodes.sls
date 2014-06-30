{% set vars = salt['mc_pillar.load_network_infrastructure']() %}
{% set cloud_cn_attrs = vars.cloud_cn_attrs %}

# detect computes nodes by searching for related vms configurations
{% set supported_vts = ['lxc'] %}
{% set done_hosts = [] %}


{% for vt, targets in vars.vms.items()  %}
{%  if vt in supported_vts %}
{%    for compute_node, vms in targets.items() %}
{%      if (compute_node not in done_hosts) and (compute_node not in vars.non_managed_hosts) %}
{%        do done_hosts.append(compute_node) %}
makina-states.cloud.saltify.targets.{{compute_node}}:
  password: {{salt['mc_pillar.get_passwords'](
                         compute_node)['clear']['root']}}
  ssh_username: root
{%       endif %}
{% set metadata = cloud_cn_attrs.get(compute_node, {}) %}
{% set haproxy_pre = metadata.get('haproxy', {}).get('raw_opts_pre', []) %}
{% set haproxy_post = metadata.get('haproxy', {}).get('raw_opts_post', []) %}
{% for suf, opts in [['pre,', haproxy_pre], ['post', haproxy_post]]%}
{% if opts %}
makina-states.cloud.compute_node.conf.{{compute_node}}.http_proxy.raw_opts_{{suf}}:
  {% for opt in opts %}- {{opt}}
  {% endfor %}
{% endif %}
{% endfor %}
{%    endfor%}
{%  endif%}
{% endfor%}

{% for vt, targets in vars.vms.items()  %}
{%  if vt in supported_vts %}
{%    for compute_node, vms in targets.items() %}
{%      if (compute_node not in done_hosts) and (compute_node not in vars.non_managed_hosts) %}
{%        do done_hosts.append(compute_node) %}
makina-states.cloud.saltify.targets.{{compute_node}}:
  password: {{salt['mc_pillar.get_passwords'](
                         compute_node)['clear']['root']}}
  ssh_username: root
{%       endif %}
{%    endfor%}
{%  endif%}
{% endfor%}


{% for host, data in vars.standalone_hosts.items() %}
{%   if not host in done_hosts %}
{%    do done_hosts.append(compute_node) %}
makina-states.cloud.saltify.targets.{{host}}:
  ssh_username: {{data.get('ssh_username', 'root')}}
  {%  for k, val in data.items() %}
  {%    if val and not val in ['ssh_username']%}
  {{k}}: {{val}}
  {%    endif%}
  {%  endfor%}
{%   endif %}
{% endfor %}
