#!/bin/bash

source ./common.sh

comment --nolf "Our app is running in our kubernetes cluster, but it is not reachable"
comment "We need to EXPOSE it before it is useful."

doit kubectl expose deployment ${DEPLOYMENT_NAME} --type="NodePort" --port=3000

comment --nolf "Now that it is exposed, curl it like we did before with docker"
comment "But first, get address of worker node"
doit bx cs workers ${CLUSTER_NAME} --json

WORKER_IP=$(cat out | grep publicIP | sed "s/.*\"\([0-9].*\)\".*/\1/g" )

# In that output, we can see the public IP
# Next we need the node port assignment of the applicationon the cluster.
# It was automatically assigned by the kubernetes runtime"

comment --pauseafter "Notice the 'publicIP' field"

comment "Get the nodePort of the service"
doit kubectl get svc guestbook -ojson

SERVICE_PORT=$(cat out | grep nodePort | sed "s/.*: *\([0-9]*\).*/\1/g")

comment --pauseafter "Notice the 'nodePort' field"

comment "Curl it..."
doit curl -s ${WORKER_IP}:${SERVICE_PORT}/hello

comment --pauseafter "*** End of "$(basename $0)
