# Deploying OpenShift Data Foundation

This automation was tested on:
* Bare metal
* VMware vSphere
* Amazon AWS

## Prerequisites

* OpenShift cluster with a minimum of 3 ODF worker nodes.
* Each worker node needs to have a minimum of 16 CPUs and 64 GB memory available.
* Worker nodes must be labeled with a label `cluster.ocs.openshift.io/openshift-storage=`
  * To label a node, issue the command:
    ```
    $ oc label nodes <node> cluster.ocs.openshift.io/openshift-storage=
    ```
  * To verify labeling, you can list the ODF worker nodes with:
    ```
    $ oc get node --selector cluster.ocs.openshift.io/openshift-storage=
    ```
    You should see at least three nodes listed in the output.

* It is recommended that you apply a taint to the nodes to mark them for exclusive OpenShift Data Foundation use:
  ```
  $ oc adm taint nodes <node names> node.ocs.openshift.io/storage=true:NoSchedule
  ```
* The default storage class is set to the appropriate storage class for your infrastructure provider.
  * On AWS, the default storage class must be `gp3-csi`.
  * On VMware vSphere, the default storage class must be `thin`.

  For example, on AWS you can verify the default storage class setting with:
  ```
  $ oc get storageclass
  NAME                PROVISIONER       RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
  gp2-csi             ebs.csi.aws.com   Delete          WaitForFirstConsumer   true                   20h
  gp3-csi (default)   ebs.csi.aws.com   Delete          WaitForFirstConsumer   true                   20h
  ```

## Using rook-ceph-tools

The ODF operator deploys Ceph toolbox. Obtain the rook-ceph-tools pod:

```
$ TOOLS_POD=$(oc get pods --namespace openshift-storage --selector app=rook-ceph-tools --output name)
```

Run Ceph commands:

```
$ oc rsh --namespace openshift-storage $TOOLS_POD ceph status
$ oc rsh --namespace openshift-storage $TOOLS_POD ceph osd status
$ oc rsh --namespace openshift-storage $TOOLS_POD ceph osd tree
$ oc rsh --namespace openshift-storage $TOOLS_POD ceph df
$ oc rsh --namespace openshift-storage $TOOLS_POD rados df
```

## Exercising the ODF cluster

You can create test volumes by issuing the commands:

```
$ oc apply -f docs/samples/test-rwo-pvc.yaml
```

```
$ oc apply -f docs/samples/test-rwx-pvc.yaml
```

```
$ oc apply -f docs/samples/test-bucket-obc.yaml
```

To further exercise the ODF cluster, you can follow the [OCS-training](https://github.com/red-hat-storage/ocs-training) hands-on workshop.

## Troubleshooting

Collect debugging data about the currently running Openshift cluster:

```
$ oc adm must-gather
```

Collect debugging information specific to OpenShift Data Foundation:

```
$ oc adm must-gather --image registry.redhat.io/odf4/odf-must-gather-rhel9:v4.20
```
