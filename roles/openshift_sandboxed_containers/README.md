# OpenShift Sandboxed Containers

This role installs the OpenShift sandboxed containers operator. The official documentation for the operator can be found [here](https://access.redhat.com/documentation/en-us/openshift_sandboxed_containers/1.4/html-single/openshift_sandboxed_containers_user_guide/index).

Note that the operator will install a MachineConfig resource to enable the sandboxed containers extension on the cluster node. This will cause the cluster nodes to restart.
