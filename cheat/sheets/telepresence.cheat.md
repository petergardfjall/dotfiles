# About

`telepresence` brings your laptop into the Kubernetes cluster (figuratively),
allowing you to (1) debug the cluster with local tools and commands and (2) code
and test microservices locally against a remote Kubernetes cluster

`telepresence` allows you to develop and debug services locally, replacing a
Kubernetes workload for a local binary transparently. This cuts down the rebuild
cycle by an order of magnitude (from rebuild docker image and apply an updated
deployment to recompile locally and run `telepresence` again).

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

- `telepresence` daemon: runs on the developer laptop. Forwards traffic to/from
  cluster through the traffic-manager.
- `traffic-manager`: runs as a deployment in the cluster. Proxies inbound and
  outbound traffic and tracks active intercepts.
- `traffic-agent`: a sidecar container that gets created for a service
  intercept. It routes incoming requests through the traffic-manager to the
  developer laptop.

## Telepresence v2: Run local commands "inside cluster"

With `telepresence connect` we can access cluster workloads as if the laptop was
another pod in the cluster. It installs a `traffic-manager` deployment in the
cluster (in the `ambassador` namespace) and sets up the local telepresence
daemon to allow DNS access to services with `<service>.<namespace>`.

    # First point kubectl to right cluster.

    # Install "traffic-manager" deployment in the "ambassador" namespace.
    telepresence helm install

    # Start local telepresence daemon and connect to cluster.
    telepresence connect

    # From now on we are "inside the cluster" and can access services
    # using local tools.
    nslookup kubernetes.default
    nslookup postgres
    nslookup postgres.local.svc.cluster.local
    psql --host postgres --user postgres

    # See connection details.
    telepresence status
    # List intercepts and interceptable service.
    telepresence list

    # Remove the `traffic-manager` deployment.
    telepresence helm uninstall

## Telepresence v2: Replace workload pods with a local binary

**NOTE**: for pod volume mounts to be available locally under
`$TELEPRESENCE_ROOT`, make sure `user_allow_other` is enabled in
`/etc/fuse.conf`.

To intercept a service `telepresence intercept` can be used. It will inject a
`traffic-agent` sidecar to created workload pods using a mutating webhook.

    # Create intercept and write pod environment variables to file.
    telepresence intercept <service> --env-file <service>.env

    # Build and run your local service binary with those environment variables:
    export $(cat <service>.env | xargs)
    make server
    ./build/service

There are some variations to the `intercept` command:

    # Intercept a specific port.
    telepresence intercept <service> --port <local:svc> --env-file <service>.env

    # Run a command locally with the pod's environment variables set.
    telepresence intercept <service> -- path/to/bin

To view which intercepts are in place run:

    telepresence list

To stop intercepting a service:

    telepresence leave <service>

To also remove the injected `traffic-manager` sidecar:

    telepresence uninstall --agent <service>

To remove all traces of telepresence:

    telepresence uninstall --all-agents  # remove traffic-agent sidecars
    telepresence helm uninstall          # remove traffic-manager
    telepresence quit -s                 # stop all local daemons

# Telepresence v1

Architecturally, Telepresence v1 differs a lot from v2. Telepresence v1 does not
inject a traffic-agent sidecar into the workload pods. Instead it uses a
"swap-deployment" approach where a pod running a service is swapped for one
running a telepresence proxy leading traffic between developer laptop and
cluster services.

The `telepresence --swap-deployment` command can be used as follows:

    # replace deployment <service> in the kubernetes cluster listening on
    # port 80 with a local binary listening on port 8080.
    telepresence --namespace dev --swap-deployment <service> --expose 8080:80   --run ./build/<service> --port 8080

The service is run with the environment variables specified by the deployment,
has access to the cluster services (via proxied) DNS, can access volumes and
secrets.

Alternatively start `telepresence` have it produce an environment file, and then
run the local binary with that environment file. This allows for an even quicker
rebuild/restart loop.

    # start telepresence proxy
    telepresence --namespace dev --swap-deployment <service> --expose 8080:80 --env-file telepresence.env

    # Build and run your local service binary with those environment variables:
    export $(cat <service>.env | xargs)
    make server
    ./build/service

## Telepresence v1: Run a service from a debugger

    telepresence --namespace dev --swap-deployment rest-backend --expose 8080:80 --run-shell
    # within the (by telepresence) opened shell
    $ dlv debug --listen=127.0.0.1:2345 --api-version=2 --log --headless=true ./build/rest-backend -- --port 8080

## Telepresence v1: Run local commands/tools within the cluster

As an example, to run some queries against an in-cluster postgres database.

By opening a shell:

    # open a local shell (with access to local tools) that will be proxied
    # to/from Kubernetes
    telepresence --namespace=local --run-shell
    @gke-dev|bash-5.0$ psql --user postgres --host postgres

By directly running the command:

    telepresence --namespace=local --run psql --user postgres --host postgres
