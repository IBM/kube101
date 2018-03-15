#!/bin/bash

source ./lab.sh

read -p "Our application is running inside of our kubernetes cluster, but it is not reachable."

read -p "We need to EXPOSE it before it is useful."

set -v
kubectl expose deployment ${DEPLOYMENT_NAME} --type="NodePort" --port=8080
set +v

read -p "now that it is exposed, we can can curl it like we did before with docker"

read -p "first we need to get the address of a worker node in our cluster"

set -v
bx cs workers ${CLUSTER_NAME}
set +v

read -p "in that output, we can see the public IP"

read -p "next we need the node port assignment of the applicationon the cluster. It was automatically assigned by the kubernetes runtime"

kubectl get svc hello-world
read -p "we can see the port assigned in the output, so like before, we can reach the application"

SERVICE_PORT=$(kubectl get svc hello-world -ojson | jq '.spec.ports[0].nodePort')
HELLO_CURL=${WORKER_IP}:${SERVICE_PORT}

set -x
curl -v ${HELLO_CURL}
