# Istio TestApp

A minimalistic application that can be deployed on Istio service mesh. The application consists of one service that is exposed via Istio gateway.

Application works on a Service Mesh that has mTLS enabled by default.

You can deploy the application with:
```
$ oc apply --filename istio-testapp-ns.yaml
$ oc apply --filename default-servicemeshmember.yaml
$ oc apply --filename testapp-deployment.yaml
$ oc apply --filename testapp-svc.yaml
$ oc apply --filename testapp-vs.yaml
$ oc apply --filename testapp-gw.yaml
```

If the Istio OpenShift Routing (IOR) is enabled, you can obtain the hostname of the ingress route:

```
$ oc get route \
    --namespace istio-system \
    --selector maistra.io/gateway-name=testapp,maistra.io/gateway-namespace=istio-testapp \
    --output jsonpath='{.items[*].spec.host}'
```

You can access the application using curl:

```
$ curl <route_hostname>
```
