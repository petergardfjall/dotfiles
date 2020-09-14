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


### SSH tunnel (local port forward)
Used to forward connections via an SSH server ("jump node") to a destination
server.

Set up an SSH tunnel, allowing connections to a port `p` on the local machine to
be forwarded by machine `Mx` to port `Py` on machine `My`. Now `localhost:p` is
a proxy for accessing `My:Py` from machine `Mx`.

    ssh -C -L p:My:Py <user>@Mx -N

- `-L`: the given port on the local (client) host is to be forwarded to the
  given host and port on the remote side.

- `-N`: don't execute a remote command.

Connect with ssh to `connectToHost`, and forward all connection attempts to the
local `sourcePort` to port `onPort` on the machine called `forwardToHost`, which
can be reached from the `connectToHost` machine. See
https://unix.stackexchange.com/a/118650.

    ssh -L sourcePort:forwardToHost:onPort connectToHost


### Reverse ssh tunnel (remote port forward)
Used to forward connections *from* an SSH server via the *ssh client* to a
destination server.

Allow `foo.com` to access ssh (port 22) on the client computer via local port
2222.

    ssh -R 2222:localhost:22 foo.com

`-R` Specifies that the given port on the remote (server) host is to be
forwarded to the given host and port on the local side.


### tinyproxy
`tinyproxy` is a lightweight http/https proxy daemon. It can be started (in
foreground, `-d`) like so:

    tinyproxy -d -c proxy.conf

with a simple `proxy.conf` being:

    User nobody
    Group nogroup
    # will bind to 0.0.0.0:8888
    Port 8888
    Listen 0.0.0.0
    Timeout 600
    MaxClients 100
    LogLevel Info
    Logfile "./tinyproxy.log"
    PidFile "./tinyproxy.pid"

    # Allowed destination ports (if none is specified, anyone is OK)
    # ConnectPort 80
    # ConnectPort 443

    # Restrict allowed clients
    # Allow 127.0.0.1
    # Allow 192.168.0.1

To configure an application to use it:

    export https_proxy=http://localhost:8888
    export http_proxy=http://localhost:8888
    # these should now go through proxy
    curl http://www.google.se
    curl https://www.google.se
