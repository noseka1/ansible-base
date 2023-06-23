# LVM Storage on OpenShift

This role deploys LVM Storage to OpenShift. It works for OpenShift clusters with one or more nodes. Note that only single-node clusters are supported by Red Hat at this time.

LVM Storage deployment documentation can be found here: [Persistent storage using logical volume manager storage](https://docs.openshift.com/container-platform/4.13/storage/persistent_storage/persistent_storage_local/persistent-storage-using-lvms.html)

This Ansible role:

* Creates a block device on each of the cluster nodes. Each block device is backed by a sparse file so the storage space is only allocated when actually needed. LVM Storage will discover these block devices and add them to the LVM volume group.
* Deploys LVM Storage operator
* Creates an LVM Storage cluster
* Sets LVM Storage as a default storageclass unless there is a default storageclass already defined on the cluster
* Enables CSI snapshotting
* Enables creating of CSI volume snapshots using Velero
