### ufw - uncomplicated firewall

- `ufw enable`                    Enable firewall.
- `ufw disable`                   Disable firewall.
- `ufw reset`                     Reset firewall settings and revert to defaults.
- `ufv status verbose`            Show status (active?) and rules (if active).
- `ufw status numbered`           Show rules numbered.

- `ufw default deny incoming`     Set default (can be overridden per port).
- `ufw default allow outgoing`    Set default.

- `ufw allow 22`                  Allow all traffic on port 22 (any protocol).
- `ufw allow 53/udp`              Allow all UDP traffic on port 53.
- `ufw allow 6000:6007/tcp`       Allow port range.


Allow traffic from IP/CIDR block to port:

    ufw allow from <source> to any port <port>


- `ufw allow from 15.15.15.51`    Allow all traffic from IP
- `ufw allow from 15.15.15.0/24`  Allow all traffic from IP range


- `ufw deny 22`                   Deny access on port
- `ufw deny from 15.15.15.51`     Deny access by source

- `ufw delete 2`                  Delete second rule.
- `ufw delete allow 22`           Delete rule 'allow 22' "by name".

### Outgoing connections
`ufw default deny outgoing`     Deny all outgoing traffic by default.
`ufw allow out to <dest/cidr>`  Open up for a particular (range) of host(s).