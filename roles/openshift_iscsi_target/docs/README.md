Example Persistent Volume Claim definition:

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: iscsi-target-example
spec:
  accessModes:
    - ReadWriteMany
  volumeMode: Block
  resources:
    requests:
      storage: 50Gi
  storageClassName: iscsi-target
```
