# Exposing Service Mesh ingress gateway using MetalLB

In this article, we will create a custom Service Mesh ingress gateway as decribed in the [Deploying automatic gateway injection](https://docs.openshift.com/container-platform/4.12/service_mesh/v2x/ossm-traffic-manage.html#ossm-deploying-automatic-gateway-injection_traffic-management) section of OpenShift documentation.

We will use a LoadBalancer service to expose the Service Mesh gateway to the outside of the OpenShift cluster. We assume that MetalLB has already been deployed and configured to provide the external IP for the LoadBalancer service.

After deploying the custom Service Mesh ingress gateway, we will deploy a sample application that will be reachable through the gateway.

Start by creating a new namespace:

```
$ oc apply -k istio-ingress-namespace
```

Wait until the namespace has joined the service mesh:

```
$ oc get -n istio-ingress smm default
NAME      CONTROL PLANE                READY   AGE
default   istio-system/control-plane   True    4d
```

Edit the IP address that will be assigned to the Service Mesh ingress gateway by MetalLB. Set the *spec.loadBalancerIP* field to an IP address from the IP address range that you configured in MetalLB:

```
$ vi istio-ingress-gateway/istio-ingressgateway-svc.yaml
```

Generate a server certificate that will be used for the TLS endpoint by typing:

```
$ ./setup.sh
```

Deploy the custom Service Mesh ingress gateway:

```
$ oc apply -k istio-ingress-gateway
```

Verify that the custom Service Mesh was assigned an external IP from MetalLB:

```
$ oc get svc -n istio-ingress istio-ingressgateway
NAME                   TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                      AGE
istio-ingressgateway   LoadBalancer   172.30.250.157   192.168.20.16   80:32623/TCP,443:31153/TCP   2d14h
```

Verify that the custom Service Mesh ingress gateway is up and running:

```
$ oc get po -n istio-ingress
NAME                                   READY   STATUS    RESTARTS   AGE
istio-ingressgateway-8cd566d7f-bdj59   1/1     Running   4          2d12h
istio-ingressgateway-8cd566d7f-bfctz   1/1     Running   4          2d12h
```

Create a namespace for the sample application:

```
$ oc apply -k istio-ingress-testapp-namespace
```

Verify that the namespace has joined the service mesh:

```
$ oc get smm -n istio-ingress-testapp default
NAME      CONTROL PLANE                READY   AGE
default   istio-system/control-plane   True    58m
```

Deploy the sample application:

```
$ oc apply -k istio-ingress-testapp
```

Verify that the sample application is running:

```
$ oc get po -n istio-ingress-testapp
NAME                       READY   STATUS    RESTARTS   AGE
testapp-5475b846cd-p8jbv   2/2     Running   8          2d12h
```

You can reach the application at the HTTP endpoint (replace the IP address with your IP address):

```
$ curl -H 'Host: testapp-http.example.com' 192.168.20.16:80

<!DOCTYPE html>
<html>
<head>
  <meta http-equiv='content-type' value='text/html;charset=utf8'>
    <meta name='generator' value='Ronn/v0.7.3 (http://github.com/rtomayko/ronn/tree/0.7.3)'>
      <title>httpbin(1): HTTP Client Testing Service</title>
...
```

Note that the above command-line output was shortened.

You can reach the application at the HTTPS endpoint (replace the IP address with your IP address):

```
$ curl -kv --resolve testapp-https.example.com:443:192.168.20.16 https://testapp-https.example.com
```

Note that the above commands sets the SNI (Server Name Indication) field correctly. Envoy proxy requires the SNI field to be set or it will close the connection abruptly:

```
$ curl -kv -H 'Host: testapp-https.example.com' https://192.168.20.16:443
*   Trying 192.168.20.16:443...
* Connected to 192.168.20.16 (192.168.20.16) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*  CAfile: /etc/ssl/certs/ca-certificates.crt
*  CApath: /etc/ssl/certs
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* OpenSSL SSL_connect: Connection reset by peer in connection to 192.168.20.16:443
* Closing connection 0
curl: (35) OpenSSL SSL_connect: Connection reset by peer in connection to 192.168.20.16:443
```
