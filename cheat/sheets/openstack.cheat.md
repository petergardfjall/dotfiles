## Installation
    pip install python-keystoneclient	auth service
    pip install python-novaclient		compute service
    pip install python-glanceclient		image service
    pip install python-neutronclient	network service


## Environment variables for Keystone v2 authentication
    export OS_REGION_NAME=RegionOne
    export OS_AUTH_URL=http://p11.ds.cs.umu.se:5000/v2.0
    export OS_USERNAME=...
    export OS_PASSWORD=...
    export OS_TENANT_NAME=...
    export OS_COMPUTE_API_VERSION=1.1


## Environment variables for Keystone v3 authentication
    export OS_REGION_NAME=Kna1
    export OS_AUTH_URL=https://identity1.citycloud.com:5000/v3/
    export OS_PROJECT_ID=...
    export OS_USER_ID=...
    export OS_PASSWORD=...
    export OS_COMPUTE_API_VERSION=2


## python-novaclient
    nova help <subcommand>
    nova list
    nova delete <id/name>
    nova boot --flavor <name/id> --image <name/id> --user-data <file> \
	      --security-groups <group1>,<group2> --key-name <keypairname> \
	      --meta <key>=<value> --poll
    nova floating-ip-create
    nova floating-ip-associate
    nova floating-ip-disassociate
    nova floating-ip-delete
    nova keypair-add
    nova keypair-list
    nova keypair-delete
    nova keypair-show
    nova image-list
    nova image-show <name>
    nova image-create
    nova image-delete <name>


## python-glanceclient
    glance image-create --file <path> --is-public False \
      --min-ram 1024 --min-disk 10 --name autoscaling-server \
      --disk-format qcow2 --container-format bare
    glance image-list


## python development
Sample code for first authenticating with keystone, and
then using the session with the neutronclient library:

    from keystoneclient.auth.identity import v3
    from keystoneclient import session
    from keystoneclient.v3 import client
    from neutronclient.neutron import client as neutronclient

        auth = v3.Password(auth_url=args.auth_url,
                           user_id=user_id,
                           password=password,
                           project_id=project_id)
        sess = session.Session(auth=auth)
        neutron = neutronclient.Client('2.0', session=sess,
	    region_name=args.region)
