# Sysdig OSS kernel module

This Helm chart compiles and inserts the sysdig OSS kernel module on each of the cluster nodes. After the kernel module is inserted, the user can run sysdig or csysdig command on the node to gain deep system visibility.

See also sysdig repo on [GitHub](https://github.com/draios/sysdig) for further details.

## Usage

Before installing this Helm chart to the cluster, make sure that the cluster nodes are provided with the RHEL entitlements.
You can follow the instructions in this article to entitle your OpenShift nodes to download RHEL content: [How to use entitled image builds on Red Hat OpenShift Container Platform 4.x cluster ?](https://access.redhat.com/solutions/4908771)

Deploy the daemonset, which will compile and insert the sysdig kernel module on start:

```
$ helm template --namespace sysdig-oss instance | oc apply -f -
```
