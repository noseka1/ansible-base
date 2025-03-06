#!/bin/bash

set -euo pipefail

ROUTER_DOMAIN=$(oc get ingresscontroller -n openshift-ingress-operator default -o jsonpath='{.status.domain}')
echo ROUTER_DOMAIN=$ROUTER_DOMAIN

cd ./istio-system

if [ ! -f testapp-tls.key ]; then
  openssl req -newkey rsa:2048 -nodes -keyout testapp-tls.key -x509 -out testapp-tls.crt -subj "/CN=*.$ROUTER_DOMAIN"
fi
kustomize build . | oc apply --filename -

cd ../istio-testapp

sed \
  --in-place \
  --expression "s/@@ROUTER_DOMAIN@@/$ROUTER_DOMAIN/g" \
  *.yaml

kustomize build . | oc apply --filename -

cd ..

# Due to a race condition in adding namespace to istio while already creating the deployment,
# istio side-car may not be injected to testapp container properly. Bounce the deployment to fix it:
oc scale deploy -n istio-testapp testapp --replicas 0 --timeout 10s
oc scale deploy -n istio-testapp testapp --replicas 1 --timeout 10s

CURL="curl --fail --retry 10 --retry-delay 5"
TEST_URL=testapp-http.$ROUTER_DOMAIN/status/200
echo Testing $TEST_URL ...
$CURL $TEST_URL
echo OK

TEST_URL=https://testapp-tls-edge.$ROUTER_DOMAIN/status/200
echo Testing $TEST_URL ...
$CURL -k $TEST_URL
echo OK

TEST_URL=https://testapp-tls-mutual.$ROUTER_DOMAIN/status/200
echo Testing $TEST_URL ...
$CURL -k --cert ./istio-system/testapp-tls.crt --key ./istio-system/testapp-tls.key $TEST_URL
echo OK

TEST_URL=https://testapp-tls-passthrough.$ROUTER_DOMAIN/status/200
echo Testing $TEST_URL ...
$CURL -k $TEST_URL
echo OK

TEST_URL=http://testapp-route-header.$ROUTER_DOMAIN
echo Testing $TEST_URL ...
RESULT=$($CURL $TEST_URL)
if [ "$RESULT" != testapp-route-v1 ]; then
  echo Check failed
fi
RESULT=$($CURL -H 'x-version: v2' $TEST_URL)
if [ "$RESULT" != testapp-route-v2 ]; then
  echo Check failed
fi
