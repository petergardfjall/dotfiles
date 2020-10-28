# About

`telepresence` allows you to develop and debug services locally, swapping out a
Kubernetes deployment for a local binary transparently, thus cutting down the
rebuild cycle by an order of magnitude (from rebuild docker image and apply an
updated deployment to recompile locally and run `telepresence` again).


     # replace deployment `rest-backend` in the kubernetes cluster listening on
     # port 80 with a local binary listening on port 8080.
     telepresence --namespace dev --swap-deployment rest-backend --expose 8080:80   --run ./build/rest-backend --port 8080

The service is run with the environment variables specified by the deployment,
has access to the cluster services (via proxied) DNS, can access volumes and
secrets.


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
