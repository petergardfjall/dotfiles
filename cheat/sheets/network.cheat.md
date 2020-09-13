### Identify interfaces/devices

Show all interfaces currently available, even if down.

     ifconfig -a

Show short list.

    if config -s [device]

List network hardware. Can help identify which network interface is attached to
a given network device.

    sudo lshw -class network

### Desktop Ubuntu: change IP address

Modifies settings under `/etc/NetworkManager/system-connections`:

    Open Settings > "Network Connections"

Note: there are really two services, NetworkManager (GUI management of network
interfaces) and networking (`/etc/network/interfaces`).

### Ubuntu server: change IP address

Modify `/etc/network/interfaces` to hold something similar to:

    auto eth0
    iface eth0 inet static
        address 192.0.2.7
        netmask 255.255.255.0
        gateway 192.0.2.254
        dns-nameservers 12.34.56.78 12.34.56.79

Or (for DHCP):

    auto eth0
    iface eth0 inet dhcp

Then enable the interface:

    sudo ifup eth0

To disable the interface:

    sudo ifdown eth0


### Ubuntu server: temporarily change IP address (lost on reboot)

Temporarily set IP and subnet mask.

    sudo ifconfig eth0 10.0.0.100 netmask 255.255.255.0
    # verify
    ifconfig eth0

Modify default gateway.

    sudo route add default gw 10.0.0.1 eth0
    # verify
    route -n

Add DNS nameserver.  Not recommended, but temporary setting that is overwritten
on reboot.

    echo "nameserver 8.8.8.8" >> /etc/resolv.conf


### SOCKS proxy
Sometimes it's not possible to reach certain servers from your machine (for
example, due to firewall settings). In such cases, it can be possible to set up
a SOCKS proxy on a remote host (reachable via `ssh`) and then configure your app
(e.g. web browser) to use that proxy (a SOCKS server proxies TCP connections to
an arbitrary IP address) over an `ssh` tunnel.

    # -D 1234: local listen port that will forward connections to the remote
    #          ssh server and act as SOCKS proxy server
    # -C: compress data to save bandwidth
    # -q: quiet. no local output.
    # -N: do not execute remote commands
    # user@edge-server: edge proxy server that will forward tunneled requests
    ssh -D 1234 -C -q -N user@edge-server

One can also pass `-f` to fork ssh into the background.

Remember to configure the application (such as Chrome or Firefox) to go through
the SOCKS proxy.

    curl --socks5 localhost:1234 https://api.ipify.org?format=json
    # note: should show the IP-address of *proxy-server*, not *your* IP
    # => {"ip":"<ip of proxy-server"}

By default, the local listen port only binds to `127.0.0.1`. To make the proxy
available to other hosts use:

    ssh -d 0.0.0.0:1234 -CqN user@edge-server


