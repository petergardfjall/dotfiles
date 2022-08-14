# About

`telepresence` brings your laptop into the Kubernetes cluster (figuratively),
allowing you to (1) debug the cluster with local tools and commands and (2) code
and test microservices locally against a remote Kubernetes cluster

`telepresence` allows you to develop and debug services locally, swapping out a
Kubernetes deployment for a local binary transparently. This cuts down the
rebuild cycle by an order of magnitude (from rebuild docker image and apply an
updated deployment to recompile locally and run `telepresence` again).

     # replace deployment `rest-backend` in the kubernetes cluster listening on
     # port 80 with a local binary listening on port 8080.
     telepresence --namespace dev --swap-deployment rest-backend --expose 8080:80   --run ./build/rest-backend --port 8080

The service is run with the environment variables specified by the deployment,
has access to the cluster services (via proxied) DNS, can access volumes and
secrets.

Alternatively start `telepresence` have it produce an environment file, and then
run the local binary with that environment file. This allows for an even quicker
rebuild/restart loop.

     # start telepresence proxy
     telepresence --namespace dev --swap-deployment rest-backend --expose 8080:80 --env-file telepresence.env

     # in another shell:
     source telepresence.env
     # .. then repeat these two steps during development/debuggin
     make server
     ./build/rest-backend

## Run a service from a debugger

    telepresence --namespace dev --swap-deployment rest-backend --expose 8080:80 --run-shell
    # within the (by telepresence) opened shell
    $ dlv debug --listen=127.0.0.1:2345 --api-version=2 --log --headless=true ./build/rest-backend -- --port 8080

## Run local commands/tools within the cluster

As an example, to run some queries against an in-cluster postgres database.

By opening a shell:

    # open a local shell (with access to local tools) that will be proxied
    # to/from Kubernetes
    telepresence --namespace=local --run-shell
    @gke-dev|bash-5.0$ psql --user postgres --host postgres

By directly running the command:

    telepresence --namespace=local --run psql --user postgres --host postgres

# Telepresence v2

NOTE: Telepresence v2 doesn't swap out the pods of the deployment but keeps the
existing pod running alongside the traffic agent. It just sends incoming traffic
to the laptop service. However, for a service with job queue semantics there are
no guarantees that a request will be handled by the laptop service. It might as
well be handled by the still-running pod inside the cluster, which we are trying
to replace. See https://github.com/telepresenceio/telepresence/issues/1646

Telepresence v1 used a "swap-deployment" approach where a pod running a service
was swapped for one running a telepresence proxy which ensured bidirectional
traffic between the developer host and cluster services. Telepresence v2 instead
makes use of a sidecar proxy ("traffic agent") that intercepts traffic into the
pod and routes it to the developer host. The main components are:

- telepresence daemon: runs on the developer laptop. Forwards traffic to/from
  cluster through the traffic-manager.
- traffic manager: runs as a deployment in the cluster. Proxies inbound and
  outbound traffic and tracks active intercepts.
- traffic agent: a sidecar container that gets created for a service intercept.
  It routes incoming requests through the traffic-manager to the developer
  laptop.

Telepresence v2 can translate v1 commands so these should be usable as-is.

## Run local commands "inside cluster"

With `telepresence connect` we can access cluster workloads as if the laptop was
another pod in the cluster. It installs a `traffic-manager` deployment in the
cluster (in the `ambassador` namespace) and sets up the local telepresence
daemon to allow DNS access to services with `<service>.<namespace>`.

    # first point kubectl to right cluster

    # Connect telepresence to cluster.
    # This installs a `traffic-manager` deployment in the `ambassador` namespace.
    telepresence connect

    # from now on we are "inside the cluster" and can access services ...

    nslookup kubernetes.default
    nslookup postgres.local
    nslookup postgres.local.svc.cluster.local

    # TODO why doesn't
    psql --host postgres.local --user postgres

    telepresence status
    telepresence list

    # remove the `traffic-manager` deployment
    telepresence uninstall --everything

## Replace a deployment with a local binary

    telepresence intercept -n local <deployment> --port <local:svc> --env-file <deployment>.env

    telepresence intercept -n local web-app --port 1234:grpc --env-file web-app.env

    telepresence intercept -n local web-app --port 1234:grpc -- path/to/bin


    telepresence list -n local
    telepresence leave <intercept-name>

NOTE: for volume mounts to work, make sure `user_allow_other` is enabled in
`/etc/fuse.conf`.
