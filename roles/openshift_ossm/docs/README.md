# Helm Charts for Deploying Red Hat OpenShift Service Mesh

Red Hat OpenShift Service Mesh product documentation can be found [here](https://docs.openshift.com/container-platform/4.13/service_mesh/v2x/ossm-about.html). These Helm charts are based on the examples included in the product documentation.

You can refer to the [Maistra Istio Operator](https://github.com/Maistra/istio-operator) project on GitHub for further documentation on the operator.

## Deploying required operators

```
$ helm template -n openshift-operators-redhat -f elasticsearch/operator/values.yaml elasticsearch/operator | oc apply -f -
```

```
$ helm template -n openshift-distributed-tracing -f jaeger/operator/values.yaml jaeger/operator | oc apply -f -
```

```
$ helm template -n openshift-operators -f kiali/operator/values.yaml kiali/operator | oc apply -f -
```

```
$ helm template -n openshift-operators -f service-mesh/operator/values.yaml service-mesh/operator | oc apply -f -
```

Make sure that the csvs deployed successfully:

```
$ oc get csv --namespace openshift-operators
NAME                                       DISPLAY                                          VERSION                   REPLACES                           PHASE
elasticsearch-operator.v5.7.2              OpenShift Elasticsearch Operator                 5.7.2                     elasticsearch-operator.v5.7.1      Succeeded
jaeger-operator.v1.42.0-5-0.1687199951.p   Red Hat OpenShift distributed tracing platform   1.42.0-5+0.1687199951.p   jaeger-operator.v1.34.1-5          Succeeded
kiali-operator.v1.65.6                     Kiali Operator                                   1.65.6                    kiali-operator.v1.57.7             Succeeded
servicemeshoperator.v2.4.0                 Red Hat OpenShift Service Mesh                   2.4.0-0                   servicemeshoperator.v2.3.3         Succeeded
```

You should now see the operators running:

```
$ oc get pod --namespace openshift-operators-redhat
NAME                                      READY   STATUS    RESTARTS   AGE
elasticsearch-operator-5d9bf6589d-26x4n   2/2     Running   0          5m38s
```

```
$ oc get pod --namespace openshift-distributed-tracing
NAME                               READY   STATUS    RESTARTS   AGE
jaeger-operator-58bdcb96cd-h2rb9   2/2     Running   0          4m53s
```

```
$ oc get pod --namespace openshift-operators
NAME                                                  READY   STATUS    RESTARTS   AGE
istio-operator-75b68dd8fc-568r7                       1/1     Running   0          24s
kiali-operator-588b5dd558-wc9gq                       1/1     Running   0          53s
...
```

## Deploying Service Mesh control plane

Install service mesh control plane:

```
$ helm template -n istio-system -f service-mesh/instance/values.yaml service-mesh/instance | oc apply -f -
```

Wait until the service mesh control plane deploys. Verify that the Kubernetes resources deployed successfully:

```
$ helm template -n istio-system -f service-mesh/instance/values.yaml service-mesh/instance | oc get -f -

NAME                     STATUS   AGE
namespace/istio-system   Active   40s

NAME                                               READY   STATUS            PROFILES      VERSION   AGE
servicemeshcontrolplane.maistra.io/control-plane   9/9     ComponentsReady   ["default"]   2.4.0     40s

NAME                                       READY   STATUS       AGE
servicemeshmemberroll.maistra.io/default   0/0     Configured   40s
```

## Discovering Service Mesh endpoints

Discover the hostnames of service mesh endpoints:

```
$ oc get route --namespace istio-system
```

## Deploying Bookinfo application

Follow the instructions in the chapter [Adding services to a service mesh](https://docs.openshift.com/container-platform/4.9/service_mesh/v2x/ossm-create-mesh.html) to deploy the example [Bookinfo application](https://istio.io/docs/examples/bookinfo/).

```
$ oc new-project bookinfo
```

```
$ (cat <<EOF
apiVersion: maistra.io/v1
kind: ServiceMeshMember
metadata:
  name: default
  namespace: bookinfo
spec:
  controlPlaneRef:
    name: control-plane
    namespace: istio-system
EOF
) | oc apply --filename -
```

```
$ oc apply \
    --namespace bookinfo \
    --filename https://raw.githubusercontent.com/Maistra/bookinfo/maistra-1.0/bookinfo.yaml
```

```
$ oc apply \
    --namespace bookinfo \
    --filename https://raw.githubusercontent.com/Maistra/bookinfo/maistra-1.0/bookinfo-gateway.yaml
```

```
$ oc apply --namespace bookinfo \
    --filename https://raw.githubusercontent.com/istio/istio/release-1.1/samples/bookinfo/networking/destination-rule-all-mtls.yaml
```

### Verifying the Bookinfo installation

Obtain a hostname of the Istio ingress route that was created automatically by [Istio OpenShift Routing](https://docs.openshift.com/container-platform/4.4/service_mesh/service_mesh_day_two/ossm-auto-route.html):

```
$ oc get route \
    --namespace istio-system \
    --selector maistra.io/gateway-name=bookinfo-gateway,maistra.io/gateway-namespace=bookinfo \
    --output jsonpath='{.items[*].spec.host}'
```

Then visit `http://<route_hostname>/productpage` with your browser.

Obtain the Kiali endpoint hostname:

```
$ oc get route --namespace istio-system kiali --output jsonpath='{.spec.host}'
```

Obtain the Grafana endpoint hostname:

```
$ oc get route --namespace istio-system grafana --output jsonpath='{.spec.host}'
```

Obtain the Jaeger endpoint hostname:

```
$ oc get route --namespace istio-system jaeger --output jsonpath='{.spec.host}'
```

### Creating a TLS route for the Bookinfo application

The following steps are based on [this article](https://access.redhat.com/solutions/4818911).

Create a secret `istio-ingressgateway-certs` that holds the certificate and private key for the TLS route. You can use a certificate specific for the route's hostname or reuse the wildcard certificate:

```
$ oc create secret tls \
    istio-ingressgateway-certs \
    --namespace istio-system \
    --cert wildcard.apps.mycluster.example.com.crt \
    --key wildcard.apps.mycluster.example.com.key
```

Remove the original plain-HTTP bookinfo gateway:

```
$ oc delete gateway bookinfo-gateway --namespace bookinfo
```

Create an HTTPS gateway instead:

```
$ (cat <<EOF
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: bookinfo-gateway
  namespace: bookinfo
spec:
  selector:
    istio: ingressgateway
  servers:
  - hosts:
    - '*'
    port:
      name: https
      number: 443
      protocol: HTTPS
    tls:
      mode: SIMPLE
      privateKey: /etc/istio/ingressgateway-certs/tls.key
      serverCertificate: /etc/istio/ingressgateway-certs/tls.crt
EOF
) | oc apply --filename -
```

Obtain a hostname of the Istio ingress route that was created automatically by Istio OpenShift Routing:

```
$ oc get route \
    --namespace istio-system \
    --selector maistra.io/gateway-name=bookinfo-gateway,maistra.io/gateway-namespace=bookinfo \
    --output jsonpath='{.items[*].spec.host}'
```

Then visit `https://<route_hostname>/productpage` with your browser.

#### Creating a custom TLS route

In the previous section, the TLS route was created automatically by the Istio OpenShift Routing. You can choose to create your custom passthrough route to better control its parameters. For example:

```
$ oc create route passthrough \
    bookinfo \
    --namespace istio-system \
    --service istio-ingressgateway \
    --port https
    --hostname bookinfo
```

Obtain a hostname of the custom route:

```
$ oc get route --namespace istio-system bookinfo --output jsonpath='{.spec.host}'
```

Then visit `https://<route_hostname>/productpage` with your browser.

## Troubleshooting

Collect debugging data about the currently running Openshift cluster:

```
$ oc adm must-gather
```

Collect debugging information specific to OpenShift Service Mesh:

```
$ oc adm must-gather --image registry.redhat.io/openshift-service-mesh/istio-must-gather-rhel7:latest
```
