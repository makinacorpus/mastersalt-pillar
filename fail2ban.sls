makina-states.services.firewall.fail2ban: true
makina-states.services.firewall.fail2ban.ignoreip: {{salt['mc_pillar.whitelisted'](opts['id'])|yaml}}
