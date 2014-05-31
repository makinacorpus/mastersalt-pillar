{% set cloud_vm_attrs = salt['mc_pillar.query']('cloud_vm_attrs') %}
{% set vars = salt['mc_pillar.load_network_infrastructure']() %}
{% set supported_vts = ['lxc'] %}
{% for vt, targets in vars.vms.items()  %}
{%  if vt in supported_vts %}
{%    for compute_node, vms in targets.items() %}
{%      if compute_node not in vars.non_managed_hosts %}
makina-states.cloud.lxc.vms.{{compute_node}}:
{%      for vm in vms %}
{%        if vm not in vars.non_managed_hosts %}
  '{{vm}}':
    {% set metadata = cloud_vm_attrs.get(vm, {}) %}
    {% do metadata.setdefault('profile_type', 'dir') %}
    {% if not 'password' in metadata %}
    {%  do metadata.update(
      {'password': salt['mc_pillar.get_passwords'](
                                 vm)['clear']['root']}) %}
    {% endif %}
    {% for var, val in metadata.items() %}
    {{var}}: {{val}}
    {% endfor %}
{%        endif%}
{%      endfor%}
{%      endif%}
{%    endfor%}
{%  endif%}
{% endfor%}
