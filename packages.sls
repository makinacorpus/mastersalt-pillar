{%- set id = opts['id'] %}
{% if 'ovh-' in id %}
 # what to cleanup
#makina-states.localsettings.pkgs.apt.debian.mirror: http://ftp.de.debian.org/debian
#makina-states.localsettings.pkgs.apt.ubuntu.mirror: http://ftp.free.fr/mirrors/ftp.ubuntu.com/ubuntu
#makina-states.localsettings.pkgs.apt.ubuntu.mirror: http://mirror.ovh.net/ubuntu/
makina-states.localsettings.pkgs.apt.ubuntu.mirror: http://mirror.ovh.net/ftp.ubuntu.com/
makina-states.localsettings.pkgs.apt.debian.mirror: http://mirror.ovh.net/ftp.debian.org/debian/
{% endif %}

{% if 'online-' in id %}
makina-states.localsettings.pkgs.apt.ubuntu.mirror: http://mirror.ovh.net/ftp.ubuntu.com/
makina-states.localsettings.pkgs.apt.debian.mirror: http://mirror.ovh.net/ftp.debian.org/debian/
#makina-states.localsettings.pkgs.apt.debian.mirror: http://mirror.ovh.net/debian/
#makina-states.localsettings.pkgs.apt.ubuntu.mirror: http://mirror.ovh.net/ubuntu/
{% endif %}
