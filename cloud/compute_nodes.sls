{% set vars = salt['mc_pillar.load_network_infrastructure']() %}

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
