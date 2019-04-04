### Modify rules

Dump rules. Edit rules in iptables.dump.

    sudo iptables --list-rules > iptables.dump

Apply new rules.

    sudo iptables-restore < iptables.dump


### Persisting iptables rules (to survive reboots)
The iptables rules are lost on restart of the iptables service.  To persist them
(to `/etc/iptables/rules.v4`), make sure `iptables-persistent` is installed and
run (on ubuntu 16.04):

    sudo netfilter-persistent save
    sudo netfilter-persistent reload
