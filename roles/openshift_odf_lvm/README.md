# ODF LVM on OpenShift

This role deploys ODF LVM to OpenShift. It works for OpenShift clusters with one or more nodes. Note that only single-node clusters are supported by Red Hat at this time.

ODF LVM deployment documentation can be found here: [Deploying and managing OpenShift Data Foundation on single node OpenShift clusters](https://access.redhat.com/documentation/en-us/red_hat_openshift_data_foundation/4.11/html/deploying_and_managing_openshift_data_foundation_on_single_node_openshift_clusters/index)

This Ansible role:

* Creates a block device on each of the cluster nodes. Each block device is backed by a sparse file so the storage space is only allocated when actually needed. ODF LVM will discover these block devices and add them to the LVM volume group.
* Deploys ODF LVM operator
* Creates an ODF LVM cluster
* Sets ODF LVM as a default storageclass unless there is a default storageclass already defined on the cluster
* Enables CSI snapshotting
* Enables creating of CSI volume snapshots using Velero