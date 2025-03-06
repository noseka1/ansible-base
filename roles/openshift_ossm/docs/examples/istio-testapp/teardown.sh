#!/bin/bash

set -euo pipefail

cd ./istio-testapp

kustomize build . | oc delete --filename -

cd ../istio-system

kustomize build . | oc delete --filename -

