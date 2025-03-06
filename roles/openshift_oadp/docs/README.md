# OpenShift API for Data Protection operator

See also oadp operator [documentation](https://github.com/openshift/oadp-operator/tree/master/docs).

## Velero Client

Configure Velero client to use non-default namespace `openshift-adp`:

```
$ velero client config set namespace=openshift-adp
```

Velero client configuration file can be found at `~/.config/velero/config.json`

## Backup and Restore of CSI Volumes

The respective volumesnapshotclass must have the `velero.io/csi-volumesnapshot-class=true` label:

```
$ oc label \
    volumesnapshotclass \
    ocs-storagecluster-rbdplugin-snapclass velero.io/csi-volumesnapshot-class=true
```

Create a test project:

```
$ oc new-project volume-test
```

Create a PVC to back up:

```
$ oc create --filename - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: myvolume
spec:
  storageClassName: ocs-storagecluster-ceph-rbd
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Mi
EOF
```

Create a backup:

```
$ velero backup create mybackup --include-namespaces volume-test
```

Check the backup status:

```
$ oc get backup -n openshift-adp mybackup -o yaml
```

Create a test restore project:

```
$ oc new-project volume-test-restore
```

Restore the backup:

```
$ velero restore create \
    myrestore \
    --from-backup mybackup \
    --namespace-mappings volume-test:volume-test-restore
```

Check the restore status:

```
$ oc get restore -n openshift-adp myrestore -o yaml
```

Delete the backup from the S3 storage. After that, delete the backup in OpenShift:

```
$ oc delete backup -n openshift-adp mybackup
```

## Backup and Restore of vSphere Volumes

Create a test project:

```
$ oc new-project volume-test
```

Create a PVC to back up:

```
$ oc create --filename - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: myvolume
spec:
  storageClassName: thin-csi
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Mi
EOF
```

Create a backup:

```
$ velero backup create \
    mybackup \
    --include-namespaces volume-test \
    --snapshot-volumes \
    --volume-snapshot-locations vsphere
```

Check the backup status:

```
$ oc get backup -n openshift-adp mybackup -o yaml
```

Check that the backup was correctly uploaded into the S3 storage:

```
$ oc get upload -n openshift-adp -o yaml upload-77b1db62-ad5d-41bb-a867-72392fac816e
```

Create a test restore project:

```
$ oc new-project volume-test-restore
```

Restore the backup:

```
$ velero restore create \
    myrestore \
    --from-backup mybackup \
    --namespace-mappings volume-test:volume-test-restore
```

Check the restore status:

```
$ oc get restore -n openshift-adp myrestore -o yaml
```

Check the backup download status:

```
$ oc get download -n openshift-adp -o yaml download-916f7fba-39d4-4a96-bc64-770d931b6c2a-3205911d-6026-4d09-a8da-ab3c4dba4992
```

Delete the backup from the S3 storage. After that, delete the backup in OpenShift:

```
$ oc delete backup -n openshift-adp mybackup
```

## Troubleshooting

Scale the oadp operator down to zero replicas:

```
$ oc edit csv -n openshift-adp oadp-operator.v1.2.0
```

Add `--log-level=debug` to the server command-line:

```
$ oc edit -n openshift-adp deploy velero
```

## References

* [OpenShift APIs for Data Protection (OADP) FAQ](https://access.redhat.com/articles/5456281)
* [Using Data Mover for CSI snapshots](https://docs.openshift.com/container-platform/4.13/backup_and_restore/application_backup_and_restore/backing_up_and_restoring/backing-up-applications.html#oadp-using-data-mover-for-csi-snapshots_backing-up-applications)
* [Stateful Application Backup/Restore - MySQL](https://github.com/openshift/oadp-operator/blob/master/docs/examples/CSI/csi_example.md)
* [Stateful Application Backup/Restore - VolumeSnapshotMover](https://github.com/openshift/oadp-operator/blob/master/docs/examples/data_mover.md)
* [Data Mover CRD design](https://github.com/openshift/oadp-operator/blob/master/docs/design/datamover.md)
