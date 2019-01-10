### Set up an ssh tunnel to access a server reachable from remote

Set up an SSH tunnel, allowing connections to a port `p` on the local machine to
be forwarded by machine `Mx` to port `Py` on machine `My`. Now `localhost:p` is
a proxy for accessing `My:Py` from machine `Mx`.
				 
    ssh -C -L p:My:Py <user>@Mx -N   

`-L` specifies that the given port on the local (client) host is to be forwarded
to the given host and port on the remote side.

Connect with ssh to `connectToHost`, and forward all connection attempts to the
local `sourcePort` to port `onPort` on the machine called `forwardToHost`, which
can be reached from the `connectToHost` machine. See
https://unix.stackexchange.com/a/118650.

    ssh -L sourcePort:forwardToHost:onPort connectToHost 

### Set up a reverse ssh tunnel to allow remote to access a locally reachable server

Allow `foo.com` to access ssh (port 22) on the client computer via port 2222.

    ssh -R 2222:localhost:22 foo.com

`-R` Specifies that the given port on the remote (server) host is to be
forwarded to the given host and port on the local side.

Connect with ssh to `connectToHost`, and forward all connection attempts to the
remote `sourcePort` to port `onPort` on the machine called `forwardToHost`,
which can be reached from your local machine. See
https://unix.stackexchange.com/a/118650

ssh -R sourcePort:forwardToHost:onPort connectToHost 