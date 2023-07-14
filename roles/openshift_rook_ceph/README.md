# Deploying Rook Ceph cluster to OpenShift

This role deploys Rook Ceph cluster to OpenShift. Clusters with any number of nodes are supported including single-node clusters.

Prior to redeploying the Rook Ceph cluster, remember to delete the */var/lib/rook* directory on all OpenShift nodes:

```
$ sudo rm -rf /var/lib/rook
```

and wipe out the block device:

```
$ sudo dd if=/dev/zero of=/dev/loop2
```
