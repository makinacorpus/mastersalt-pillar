{# take a dn and list of trigrammes as input
 This setup the ~/.ssh/authorized_keys file with the relevant keys #}
makina-states.services.base.ssh.chroot_sftp: true
{% macro set_sysadmins_keys(dn=None) %}
makina-states.localsettings.admin.sysadmins_keys: {{salt['mc_pillar.get_sysadmins_keys'](dn)|yaml}}
{% endmacro %}
{{set_sysadmins_keys(opts.id)}}
