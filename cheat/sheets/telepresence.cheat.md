# About

`telepresence` allows you to develop and debug services locally, swapping out a
Kubernetes deployment for a local binary transparently, thus cutting down the
rebuild cycle by an order of magnitude (from rebuild docker image and apply an
updated deployment to recompile locally and run `telepresence` again).


     # replace deployment `rest-backend` in the kubernetes cluster listening on
     # port 80 with a local binary listening on port 8080.
     telepresence --namespace dev --swap-deployment rest-backend --expose 8080:80   --run ./build/rest-backend --port 8080
