# Virtual machine live-migration

The storageclasses used in the example manifest will likely not match the
storageclass available on your cluster. Use the grep command to find the
storageclass occurences and update them to match your cluster:

```
$ grep -r storageClassName *
```

Create source namespace:

```
$ oc apply -f virtualmachine/namespace.yaml
```

Create an example virtual machine that will be live-migrated:

```
$ oc apply -R -f virtualmachine
```

## Live-migration

Live-migrate the VM to a different cluster node:

```
$ oc apply -f live-migration/anynode-vmim.yaml
```

Example situation after running the command:

```
$ oc get po -n kubevirt-migrate-source -o wide
NAME                          READY   STATUS      RESTARTS   AGE   IP            NODE      NOMINATED NODE   READINESS GATES
virt-launcher-example-l7xcb   0/2     Completed   0          81m   10.130.0.26   worker2   <none>           1/1
virt-launcher-example-llc8g   2/2     Running     0          93s   10.129.0.6    worker1   <none>           1/1
```

The same migration can be accomplished using:

```
$ virtctl migrate example
```

Live-migrate the VM to a specific cluster node. Update the `nodeselector-vmim.yaml` by editing the node selector to choose the
target node:

```
$ vi live-migration/nodeselector-vmim.yaml
```

Live-migrate the VM to the specific node:

```
oc apply -f live-migration/nodeselector-vmim.yaml
```

Example situation after running the command:

```
$ oc get po -n kubevirt-migrate-source -o wide
NAME                          READY   STATUS      RESTARTS   AGE     IP            NODE      NOMINATED NODE   READINESS GATES
virt-launcher-example-hhbl7   2/2     Running     0          23s     10.128.0.26   master1   <none>           1/1
virt-launcher-example-llc8g   1/2     Completed   0          3m28s   10.129.0.6    worker1   <none>           1/1
```

The same migration can be accomplished using:

```
$ virtctl migrate --addedNodeSelector kubernetes.io/hostname=master1 example
```

## Volume migration (aka storageclass migration)

To convert volumes from one storageclass to another, issue:

```
$ oc apply -R -f volume-migration
```

Example situation after running the command:

```
$ oc get po -n kubevirt-migrate-source -o wide
NAME                          READY   STATUS      RESTARTS   AGE     IP            NODE      NOMINATED NODE   READINESS GATES
virt-launcher-example-hhbl7   0/2     Completed   0          38m     10.128.0.26   master1   <none>           1/1
virt-launcher-example-z9ft9   2/2     Running     0          6m54s   10.129.0.9    worker1   <none>           1/1
```

```
$ oc get pvc -n kubevirt-migrate-source
NAME                      STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS     VOLUMEATTRIBUTESCLASS   AGE
example-rootdisk          Bound    pvc-9f30e704-1a12-44d6-91e0-cc6269595f78   10Gi       RWX            nfs-csi          <unset>                 3h9m
example-rootdisk-target   Bound    pvc-c1bd7968-2dd0-4426-b0a8-a160d396c68b   10Gi       RWX            local-hostpath   <unset>                 11m
```

## Decentralized live migration

Decentralized live migration is a storage live migration that allows you to migrate virtual machines between namespaces or even between different OpenShift clusters.

Decentralized live migration is available in OpenShift *4.20 or later*.

To enable the decentralized live migration, you must set a feature gate in OpenShift Virtualization. If you are live-migrating between clusters, both clusters must have this feature gate enabled:

```
$ oc patch hyperconverged -n openshift-cnv kubevirt-hyperconverged --type json -p '[{"op":"replace", "path": "/spec/featureGates/decentralizedLiveMigration", "value": true}]'
```

Before initiating the live migration, configure the `virtualmachineinstancemigration.spec.sendTo.connectURL` to point to the target synchronization controller. You can follow the instructions in the `example-source-vmim.yaml` file:

```
$ vi decentralized-live-migration/example-source-vmim.yaml
```

Create target namespace:

```
$ oc apply -f decentralized-live-migration/namespace.yaml
```

Trigger the decentralized live migration to move a VM to a different namespace
within the same cluster:

```
$ oc apply -R -f decentralized-live-migration
```

Example situation after running the command:

```
$ oc get vm -A
NAMESPACE                 NAME      AGE     STATUS    READY
kubevirt-migrate-source   example   57m     Stopped   False
kubevirt-migrate-target   example   3m34s   Running   True
```

```
$ oc get vmim -A
NAMESPACE                 NAME             PHASE       VMI
kubevirt-migrate-target   example-target   Succeeded   example
```

If the decentralized live-migration doesn't commence, restart all OpenShift
Virtualization pods and try again:

```
$ oc delete pod -n openshift-cnv --all
```

### References

* [Live Migration](https://kubevirt.io/user-guide/compute/live_migration/)
* [Volume migration](https://kubevirt.io/user-guide/storage/volume_migration/)
* [Decentralized live migration](https://kubevirt.io/user-guide/compute/decentralized_live_migration/#decentralized-live-migration)
