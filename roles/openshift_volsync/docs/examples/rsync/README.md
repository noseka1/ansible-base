# Replicating volumes between two OpenShift clusters

## Destination cluster

Create namespace:

```
$ oc apply -f volsync-rsync-test-ns.yaml
```

Create replication pre-shared key. Update the file with your own secret key prior to applying:

```
$ oc apply -f psk-secret.yaml
```

Create a replication destination. Update the file with your storage class and volume snapshot class prior to applying:

```
$ oc apply -f dest-replicationdestination.yaml
```

Expose the rsync server using an OpenShift route:

```
$ oc apply -f dest-route.yaml
```

Obtain the route hostname. We will use it for configuring the replication source. To get the route hostname, type:

```
$ oc get -f dest-route.yaml --output jsonpath='{.spec.host}'
```

Example output:

```
dest-volsync-rsync-test.apps.mycluster4.example.com
```

Check that the rsync server endpoint reachable from outside of the cluster (the handshake failure is an expected result):

```
$ curl https://dest-volsync-rsync-test.apps.mycluster4.example.com
```

Example output:

```
curl: (35) OpenSSL/3.0.9: error:0A000410:SSL routines::sslv3 alert handshake failure
```

## Source cluster

Create namespace:

```
$ oc apply -f volsync-rsync-test-ns.yaml
```

Create replication pre-shared key:

```
$ oc apply -f psk-secret.yaml
```

Create destination source. Replace PVC name with the PVC that you want to replicate. Replace the destination address with your rsync server hostname. In our example it is *dest-volsync-rsync-test.apps.mycluster4.example.com*:

```
$ oc apply -f src-replicationsource.yaml
```

Verify on the source cluster that data replication works:

```
$ oc get -f src-replicationsource.yaml -o yaml
```

Example output:

```
apiVersion: volsync.backube/v1alpha1
kind: ReplicationSource
metadata:
  annotations:
  name: src
  namespace: volsync-rsync-test
  ...
spec:
  rsyncTLS:
    address: dest-volsync-rsync-test.apps.mycluster4.example.com
    copyMethod: Clone
    keySecret: psk
    port: 443
  sourcePVC: toolbox-container-home
  trigger:
    schedule: '*/1 * * * *'
status:
  conditions:
  - lastTransitionTime: "2023-07-02T21:09:12Z"
    message: Waiting for next scheduled synchronization
    reason: WaitingForSchedule
    status: "False"
    type: Synchronizing
  lastSyncDuration: 12.244434778s
  lastSyncTime: "2023-07-02T21:09:12Z"
  latestMoverStatus:
    logs: |-
      sent 61.03K bytes  received 615 bytes  123.29K bytes/sec
      total size is 4.11M  speedup is 66.67
      sent 58,511 bytes  received 598 bytes  118,218.00 bytes/sec
      total size is 4,109,984  speedup is 69.53
      rsync completed in 0s
    result: Successful
  nextSyncTime: "2023-07-02T21:10:00Z"
  rsyncTLS: {}
```
