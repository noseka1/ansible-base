# Node Maintenance Operator

The node maintenance operator achieves the same results as the oc adm cordon and oc adm drain commands but in a declarative fashion (NodeMaintenance CR).

For example, to put node master1.mycluster5.example.com into maintenance mode, apply the following resource:

```
apiVersion: nodemaintenance.medik8s.io/v1beta1
kind: NodeMaintenance
metadata:
  name: master1
spec:
  nodeName: master1.mycluster5.example.com
  reason: NIC replacement
```

## References

* [Node Maintenance Operator](https://docs.redhat.com/en/documentation/workload_availability_for_red_hat_openshift/25.8/html/remediation_fencing_and_maintenance/node-maintenance-operator)
