# OpenShift External DNS

This role deploys External DNS to OpenShift.

## Example routes

Following are example routes.  After these routes are created on OpenShift, the External DNS will create the respective DNS records in Route 53:

```
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  annotations:
    external-dns.alpha.kubernetes.io/hostname: myapp.myzonedomain.example.com
    external-dns.alpha.kubernetes.io/target: router-default.apps.myclusterdomain.example.com
    external-dns.alpha.kubernetes.io/ttl: 300s
  labels:
    external-dns.mydomain.org/publish: "yes"
  name: myapp
spec:
  port:
    targetPort: http
  to:
    kind: Service
    name: myapp
```

```
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  annotations:
    external-dns.alpha.kubernetes.io/target: router-default.apps.myclusterdomain.example.com
    external-dns.alpha.kubernetes.io/ttl: 300s
  labels:
    external-dns.mydomain.org/publish: "yes"
  name: myapp-2
spec:
  host: myapp-2.myzonedomain.example.com
  port:
    targetPort: http
  to:
    kind: Service
    name: myapp
```

## References

* [External DNS Operator in OpenShift Container Platform](https://docs.openshift.com/container-platform/4.10/networking/external_dns_operator/understanding-external-dns-operator.html)
* [Configuring ExternalDNS to use the OpenShift Route Source](https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/openshift.md)
