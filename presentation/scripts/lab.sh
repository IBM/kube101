#!/bin/bash

#set -xv

function get_pods {
    kubectl get pods -l run=hello-world
}


CLUSTER_NAME=osscluster
#CLUSTER_NAME=mhb-pvc-test
DEPLOYMENT_NAME=hello-world
IMAGE_NAME=registry.ng.bluemix.net/ossdemo/hello-world
# get worker ip
WORKER_IP=$(bx cs workers ${CLUSTER_NAME} --json  | jq -r '.[0].publicIP')

# check if hello-world is deployed

# check for service

SERVICE_PORT=$(kubectl get svc hello-world -ojson | jq '.spec.ports[0].nodePort')

HELLO_CURL=${WORKER_IP}:${SERVICE_PORT}

