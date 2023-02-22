This demo assumes that the ServiceMeshControlPlane resource called *control-plane* and it was deployed to *istio-system* namespace.

Create a Prometheus service that bypasses the authentication proxy:

```
$ oc apply -f prometheus/prometheus-noauth-svc.yaml
```
