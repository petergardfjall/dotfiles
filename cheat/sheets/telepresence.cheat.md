# About

`telepresence` brings your laptop into the Kubernetes cluster (figuratively),
 allowing you to (1) debug the cluster with local tools and commands and (2)
 code and test microservices locally against a remote Kubernetes cluster

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
