### why is kubernetes so popular?
- Containerization benefits (isolation, reproducability, portability).
  Dev environment can be very similar to prod.
- k8s: needed to run containers over clusters of machines with production-grade
  functions. Also, fills a gap between raw IaaS (too technical) and PaaS
  (lock-in, less control) and runs on virtually any cloud/machine architecture.

- fault-tolerance: self-healing (pod/node failures)
- autoscaling
- rolling updates
- load-balancing
- isolation
- logging
- monitoring and health-checking
- service discovery

### components
- kubernetes control-plane ("master") components
  - *apiserver*: rest api
  - *etcd*: state store
  - *scheduler*: watches apiserver, assigns pods to nodes
  - *controller-manager*: runs control loops (see below)
- node components
  - docker/container runtime: pull images, start/stop, etc
  - kubelet: agent, listen for apiserver/sched instructions (10255), run pods
    uses Container Runtime Interface (CRI) to communicate with docker/rkt
  - kube-proxy: network proxy/lb that implements the service abstraction.
    programs iptables on nodes to redirect service ip requests to a
    registered backend pod. kube-proxy is no longer a suitable name,
    as it isn't on the data path. it just handles iptables rules:

        if dest.ip:port == svc1.ip:port {
            pick endpoint backend at random; rewrite dest.ip
        }

- cluster communication
  - cluster -> master: all communication via apiserver (https, cert-auth)
  - master -> cluster:
    - apiserver -> kubelet:
      - kubelet cert not verified by default (man-in-the-middle vulnerable)
        - should not run on untrusted/public networks
      - to secure: use apiserver flag: `--kubelet-certificate-authority`
    - apiserver -> node/pods/services
      - not safe, plain http. should not run over untrusted networks.

- kube-controller-manager controllers
  - node controller (takes action when nodes go up/down)
  - replication controller
  - route controller
  - volume controller


### concepts
- pod: atomic unit of scheduling (runs in its entirety on a single node)
  - sandbox for one or more containers
  - tightly coupled: share network address space, volumes, memory space
  - autohealing and scaling via higher-level constructs (replicaset, deployment)
  - ephemeral IP-addresses (addressed by services)
  - ephemeral storage

- replicaset/replication-controller: scaling and auto-healing of pods
- deployment: adds replicaset, versioning and rollback to pods
- service: static IP address and loadbalancing for a (labelled) pod set.
  provides a static IP and DNS domain for a dynamic set of pods.
  decouples different app layers (no location-awareness needed).
- persistent volumes: persistent storage, exceeding lifetime of a pod
  - can be statically (manually pre-created) or dynamically
    provisioned (via pvc and a StorageClass configured for cloud api)
  - a control loop in the master watches for new PVCs, finds a matching PV
    (if possible), and binds them together. If a PV was dynamically
    provisioned for a new PVC, the loop will always bind that PV to the PVC.
  - when a user is done with their volume, they can delete the PVC objects
    from the API which allows reclamation of the resource. The reclaim policy
    for a PersistentVolume tells the cluster what to do with the volume after
    it has been released of its claim. Currently, volumes can either be
    Retained, Recycled or Deleted.
  - To be able to re-attach an existing dynamically provisioned PV to a pod,
    make sure to keep the PVC around for a new pod to reference it.



- labels: used for identification and selection
- annotations: metadata required by the object itself

- pod spec:
  - environment variables:
    - valueFrom: configMapKeyRef|secret|fieldRef
    - envFrom: configMapRef
  - pod lifecycle hooks: postStart, preStop (blocking): either exec
    (e.g. shell script), or http (to some container endpoint).
    at-least-once semantics.
  - node assigmnent: nodeSelector, node/pod (anti-)affinity
  - tolerations: against node taints
  - init containers: runs (to completion), in sequence, before app containers
  - liveness probes: fail -> kubelet kills container and restart policy kicks in
  - readiness probes: fail -> endpoint object will remove pod from service
  - pod.spec.containers.terminationMessagePath: default: /dev/termination-log
    Kubernetes will try to read this value for exited pods. Can be read in pod
    container status.

- pod presets: loosely coupled way of injecting data (secrets, volumes, volume
  mounts, env vars) into pods (selected by labels) at creation time

- pod priorities: indicate importance to scheduler, allowing it to
  preempt/evict pods
  - use PriorityClass objects and reference from pod.spec.priorityClassName
  - high-prio pod can skip ahead when multiple pods are Pending
  - when a high-prio pod cannot fit, low-prio pod(s) are pre-empted (deleted
    from node) to make room for the high-prio pod. preempted pod gets its
    terminationGracePeriod before being killed.

- PodDisruptionBudget: describes availability guarantees to enforce during
  voluntary disruptions (deployment rollouts, node drains, scale-downs). It
  limits the number of pods that are allowed to be simultaneously down.

- Deployment: includes a ReplicaSet (with a pod template and labels) and
  supports versioning and rolling updates (with rollback).
  - every change to a deployment is tracked -> supports rollbacks
    - a pod template change results in a new revision
  - rolling update: pod template change -> new rs, old rs scaled down (but kept)
    - during rolling updates, two replica sets exist
  - spec.strategy.type: "Recreate" or "RollingUpdate" (default)
  - spec.strategy.rollingUpdate.maxUnavailable: max num pods that can be
    unavailable during update (num/percentage)
  - spec.strategy.rollingUpdate.maxSurge: max number of pods that can be
    scheduled above the desired number during a rolling update. (num/percentage)

- Service: a stable frontend address for a logical set of backend pods
  - static IP address and DNS name, dynamic set of backends (label selector)
  - Endpoint object: dynamic list of (ready) pods selected by a service
  - kube-proxy relays external traffic to the node to service backends
  - a service can expose multiple *named* ports
  - types
    - ClusterIP: a cluster-internal IP (default)
    - NodePort: reachable by opening a port (30000-32767) on every cluster node
      (request to node:NodePort is relayed to ClusterIP:NodePort by kube-proxy)
    - LoadBalancer: external cloud loadbalancer. NodePort and ClusterIP created
      under the hood. LoadBalancer -> NodePort -> ClusterIP -> Pod.
    - ExternalName: maps to a CNAME via kube-dns
  - service discovery via DNS or pod env variables
  - <service-name>.<namespace-name>.svc.cluster.local -> ClusterIP
  - DNS SRV records for named ports:
    port-name.port-protocol.my-svc.my-namespace.svc.cluster.local
  - headless service (clusterIP: None): a service without a ClusterIP.
    - if you do not need ClusterIP nor load-balancing for your service. If a
      pod selector is used, a DNS entry will be created for the service which
      will resolve to *all* IP addresses of backend pods.
  - can specify externalIPs on any type of service. if incoming traffic has
    this address as its destination and arrives on the service port, the
    request is routed to a service endpoint

- Volumes: can be mounted to pods via .pod.spec.volumes.
  - different kinds: secret, configmap, emptyDir, hostPath, local, nfs,
    glusterfs, cloud disks (gce, aws, azure), and persistentVolumeClaim
  - PersistentVolumeClaim: claims durable storage without being aware of
    the details of the cloud environment. Requests storage of a particular
    size and access mode (and labels). The claim is bound to a matching
    PersistentVolume. The PVC can then be mounted by a pod.
  - A PersistentVolume is a piece of storage provisioned by an admin. It
    outlives any pods using it.
    - Static: created manually by an admin (e.g., creating a cloud disk and
      referencing it from a PersistentVolume object)
    - Dynamic: created dynamically by k8s when a PVC cannot be satisfited by an
      existing PV -- given that the PVC references a StorageClass, and that
      a StorageClass has been set up to create PVs of a certain kind.
  - "PVs are resources, PVCs are requests for those resources"
  - persistentVolume.spec.accessModes: ReadWriteOnce|ReadOnlyMany|ReadWriteMany
  - persistentVolume.spec.mountOptions: specific for each type of volume
  - When a PVC is deleted its associated PV is reclaimed according to the PV's
    spec.persistentVolumeReclaimPolicy: Retain (default, manual reclamation),
    Delete (default for dynamically provisioned PVs -- specified in
    StorageClass), Recycle (scrubs disk).

- NetworkPolicy: use podSelectors to specify which pods are allowed to
  send traffic to each other. Need to set the network policy to use DefaultDeny
  for the namespace first. Then apply NetworkPolicies to add "open paths".

- StatefulSet: similar to a deployment but pods are unique (sticky
  identity) and ordered. identifier, network identity, and persistent volumes
  are maintained across rescheduling.
  - use it when ordered, graceful deployment and scaling is required
  - associated storage must be provided as PersistentVolume; deleting or
    scaling a StatefulSet will not delete the volumes.
  - requires a headless service

- Jobs: pods that run to completion. Commonly used for batch
  processing or CronJobs.
  - can be parallel/non-parallel. can specify completion count.

- DaemonSet: runs a pod on each node in the cluster. As nodes are added,
  pods are added.
  - examples: node agents (monitoring,logging), cluster storage daemons.
  - to allow the agent to run on any node, suitable tolerations may be needed
    in the pod spec: e.g., against node-role.kubernetes.io=master:NoSchedule


- Taints: set on nodes to only allow pods with matching tolerations to run
  - some taints are set by the node controller, e.g.,
    node.kubernetes.io/disk-pressure

- Horizontal Pod Autoscaler (hpa): handles scaling in rc, rs, and deployments
  - cpu or custom metrics
  - cooldown specified in kube-controller-manager (defaults: up: 3m, down: 5m)

- Ingress: a HTTP reverse proxy that can multplex incoming traffic to multiple
  backends defined via ingress rules.
  - requires an ingress-controller (can be cloud-native or set up as a
    deployment)
  - can provide load-balancing, SSL termination, and name-based virtual hosting
  - allows a single external LoadBalancer service to lead traffic to multiple
    backend services (the ingress-ctrler multiplexes traffic to its backends)

- Role-based Access Control (RBAC):
  - Subjects/identities: User (for humans/procs outside cluster, CN=username),
    Group (cert O=groupname), ServiceAccount (for intra-cluster procs in pods)
  - Roles (applies to specific namespace) vs ClusterRoles (across entire
    cluster)
    - a role contains rules representing a set of permissions (resources +
      verbs)
  - Bindings to associate identities with Roles (of any type!):
    - RoleBinding: when used with a ClusterRole, its scope is narrowed to the
      RoleBinding's namespace
    - ClusterRoleBinding


- Multi-zone clusters: the scheduler tries to schedule pods evenly across zones
  to reduce the impact of zone failure. When persistent volumes are used, a
  zone label is added and the scheduler ensures that pods claiming a given
  volume are only placed in the same zone as that volume.

- Clusters cannot span clouds or regions. For that, federation is needed.

- Cluster upgrades: typically control-plane first, kubelets second
  - kube-apiserver, kube-controller-manager, kube-scheduler, kube-dns
  - kube-proxy, kubelet
  - additional stuff as needed for new release (etcd, flags, kube-dns,
    api objects)
  - careful: e.g. avoid using packaged kubeadm (may update dependencies,
    including kubelet)



### kubectl
    # get bash tab-completion
    source <(kubectl completion bash)

    # use a particular kubeconfig
    export KUBECONFIG=/path/to/kubeconfig; kubectl ...
    kubectl ... --kubeconfig=/some/path


    # show kubelet version running on nodes
    kubectl get nodes
    # show apiserver version
    kubectl version --short

    # validate a resource
    kubectl create --validate --dry-run -f <file>

    # record the command in the resource annotation
    kubectl apply --record ...

    # show API object/field documentation
    kubectl explain <resource>
    kubectl explain deployment.spec.template.spec.containers
    kubectl explain pod.status.phase

    # block to see changes
    kubectl get ... --watch
    # show labels set on object
    kubectl get ... --show-labels
    # show columns with particular label values for every resource
    kubectl get ... -Lapp -Ltier -Lrole
    # show only resources with certain (comma-separated) field values
    kubectl get pods --field-selector status.phase=Pending
    # show only pods matching a given label selector
    kubectl get pods -l app=nginx,tier=frontend
    kubectl get pods -l 'app in (nginx),tier not in (backend)'

    # create deployment
    kubectl run nginx --image=nginx --env="A=B" --labels="app=nginx" --port=80
    # edit and re-apply deployment
    kubectl edit nginx
    # front deployment pods with a service
    kubectl expose deployment nginx --port=80 --target-port=80 --type=LoadBalancer

    # undo rollout (pod template change) on a deployment
    kubectl rollout undo deployment/<name> [--to-revision=2]
    # show revisions (with change command if deployment created with --record)
    kubectl rollout history deployment <name>
    # watch the status of latest rollout until done (--watch=true by default)
    # will report how many replicas have been updated
    kubectl rollout status deployment <name>

    # scaling
    kubectl scale deployment <name> --replicas=3
    kubectl autoscale deployment <name> --min=3 --max=10 --cpu-percent=50

    # troubleshooting; check logs for current container
    kubectl logs <pod> <container>
    # check logs for previous (crashed) container
    kubectl logs --previous <pod> <container>
    # only show recent logs
    kubectl logs --since=1h ...
    # only show recent logs
    kubectl logs --since-time=2018-09-18T12:00:00Z ...

    # set additional labels on existing resources
    kubectl label <resource> <name> app=nginx role=frontend
    kubectl label node worker-1 disk=ssd
    # set additional annotations on existing resources
    kubectl annotate <resource> <name> description='bla bla bla'

    # update API objects in-place
    kubectl patch ...

    # view node capacity and cpu/mem requests
    kubectl describe nodes

    # delete deployment but keep pods
    kubectl delete deployment <name> --cascade=false

    # delete multiple resources by label
    kubectl delete deployment,service -l app=nginx

    # create a horizontal pod autoscaler for a deployment
    kubectl autoscale deployment/my-nginx --min=1 --max=3

    # run scripted command
    /bin/sh -c '...'

    kubectl label nodes <node> disktype=ssd
    # set taint key 'node-type' and value 'master' with effect 'NoSchedule'
    kubectl taint nodes <node> node-type=master:NoSchedule
    # remove taint with key 'node-type' and effect 'NoSchedule'
    kubectl taint nodes <node> node-type:NoSchedule-
    # remove all taints with key 'node-type'
    kubectl taint nodes <node> node-type-

    kubectl get componentstatuses

        NAME                 STATUS    MESSAGE              ERROR
        controller-manager   Healthy   ok
        scheduler            Healthy   ok
        etcd-0               Healthy   {"health": "true"}

    # get events for objects in a given namespace
    kubectl get events -n <ns>
    kubectl get events --all-namespaces

    # create a kubeconfig file for a given cluster with auth credentials embedded
    kubectl config set-cluster <name> --certificate-authority=ca.pem \
            --embed-certs=true \
            --server=https://${apiserver_ip}:6443 \
            --kubeconfig=admin.kubeconfig
    kubectl config set-credentials admin \
            --client-certificate=admin.pem \
            --client-key=admin-key.pem \
            --embed-certs=true \
            --kubeconfig=admin.kubeconfig
    kubectl config set-context default \
            --cluster=<name> \
            --user=admin \
            --kubeconfig=admin.kubeconfig
    kubectl config use-context default --kubeconfig=admin.kubeconfig


    # configmaps imperatively
    kubectl create configmap my-cm --from-file=/some/dir
    kubectl create configmap my-cm --from-file=user=/user.txt --from-file=pass=/pass.txt
    kubectl create configmap my-cm --from-literal=user=foobar
    kubectl create configmap my-cm --from-env-file=/foo.env

    # create secrets imperatively
    kubectl create secret docker-registry ...
    kubectl create secret tls ...
    kubectl create secret generic my-secret --from-file=/some/dir
    kubectl create secret generic my-secret --from-file=user=/user.txt --from-file=pass=/pass.txt
    kubectl create secret generic my-secret --from-literal=user=foobar
    kubectl create secret generic my-secret --from-env-file=/foo.env

    # http proxy on localhost to apiserver, kubectl connects via https to apiserver
    kubectl proxy -p 8000

    # RBAC
    kubectl create serviceaccount -n <ns>
    kubectl create role ...
    kubectl create rolebinding ...


## Forward a local port to a port on a pod/service/deployment

To a pod:

    kubectl port-forward redis-master-765d459796-258hz 7000:6379
    kubectl port-forward pods/redis-master-765d459796-258hz 7000:6379

To a deployment:

    kubectl port-forward deployment/redis-master 7000:6379

To a service:

    kubectl port-forward svc/redis-master 7000:6379

## Run a stress pod
Try to hog 8 cpus:

    kubectl run stress -n local --image=progrium/stress -- --cpu 8

Run 4 workers each allocating 256MB memory

    kubectl run stress -n local --image=progrium/stress -- --vm 4 --vm-bytes 256M --vm-hang 0

One can pass `timeout=60s` to limit the duration.

To remove:

    kubectl delete deployments.apps -n local --now stress 
