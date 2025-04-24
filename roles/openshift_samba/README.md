# Samba on OpenShift

## Example PVC

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: example
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 50Gi
  storageClassName: smb-myshare
```

## References

* [Samba Operator](https://github.com/samba-in-kubernetes/samba-operator)
* [CIFS/SMB CSI Driver Operator](https://docs.redhat.com/en/documentation/openshift_container_platform/4.16/html/storage/using-container-storage-interface-csi#persistent-storage-csi-smb-cifs)
