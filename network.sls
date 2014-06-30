{# setup the network adapters configuration
    by default we setup the network card and an additionnal failover ip on it
    this will look  the ip inside the ips, ipsfo and ipsfo_map dictionnaries #}
{% macro manage_network_common(fqdn) %}
makina-states.localsettings.network.managed: true
makina-states.localsettings.hostname: {{fqdn.split('.')[0]}}
{% endmacro %}

{% set net = salt['mc_pillar.load_network_infrastructure']() %}
{% set ips = net.ips %}
{% set ipsfo = net.ipsfo %}
{% set ipsfo_map = net.ipsfo_map %}

{% macro manage_baremetal_network(fqdn, thisip=None, thisipfos=None, ifc='eth0') %}
{%  if not thisip %}
{%    set thisip=ips[fqdn][0] %}
{%  endif %}
{%  if not thisipfos %}
{%    set thisipfos =  [] %}
{%    set thisipifosdn = ipsfo_map.get(fqdn, []) %}
{%    for dns in thisipifosdn %}
{%      do thisipfos.append(ipsfo[dns]) %}
{%    endfor %}
{%  endif %}
{{manage_network_common(fqdn)}}
makina-states.localsettings.network.ointerfaces:
  - {{ifc}}:
      address: {{thisip}}
      broadcast: {{salt['mc_network.get_broadcast'](fqdn, thisip) }}
      netmask: {{salt['mc_network.get_netmask'](fqdn, thisip) }}
      gateway: {{salt['mc_network.get_gateway'](fqdn, thisip) }}
      dnsservers: {{salt['mc_network.get_dnss'](fqdn, thisip) }}
{% if thisipfos %}
{% for thisipfo in thisipfos %}
  - {{ifc}}_{{loop.index0}}:
      ifname: "{{ifc}}:{{loop.index0}}"
      address: {{thisipfo}}
      netmask: {{salt['mc_network.get_fo_netmask'](fqdn, thisipfo) }}
      broadcast: {{salt['mc_network.get_fo_broadcast'](fqdn, thisipfo) }}
{% endfor %}
{% endif %}
{% endmacro %}

{# setup the network adapters configuration for a kvm vm on an ip  failover setup #}
{% macro manage_bridged_fo_kvm_network(fqdn, host, thisip=None, ifc='eth0') %}
{% if not thisip %}
{%  set thisip=ipsfo[ipsfo_map[fqdn][0]] %}
{% endif %}
{% set gw = salt['mc_network.get_gateway'](host, ips[host][0]) %}
{{manage_network_common(fqdn)}}
makina-states.localsettings.network.ointerfaces:
  - {{ifc}}:
      address: {{thisip}}
      netmask: {{salt['mc_network.get_fo_netmask'](fqdn, thisip) }}
      broadcast: {{salt['mc_network.get_fo_broadcast'](fqdn, thisip) }}
      dnsservers: {{salt['mc_network.get_dnss'](fqdn, thisip) }}
      post-up:
        - route add {{gw}} dev {{ifc}}
        - route add default gw {{gw}}
{% endmacro %}

{% if opts['id'] not in net.non_managed_hosts %}
{%  if opts['id'] in net.baremetal_hosts %}
{{    manage_baremetal_network(opts['id']) }}
{%  else %}
{%    for vt, targets in net.vms.items() %}
{%      if vt == 'kvm' %}
{%        for target, vms in targets.items() %}
{%          if opts['id'] in vms %}
{{            manage_bridged_fo_kvm_network(opts['id'], target) }}
{%          endif %}
{%        endfor %}
{%      endif %}
{%    endfor %}
{%  endif %}
{% endif %}
