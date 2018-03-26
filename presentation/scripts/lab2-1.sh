#!/bin/bash

source ./common.sh

SERVICE_PORT=$(kubectl get svc hello-world -ojson | grep nodePort | sed "s/.*: *\([0-9]*\).*/\1/g")
WORKER_IP=$(bx cs workers ${CLUSTER_NAME} --json  | grep publicIP | sed "s/.*\"\([0-9].*\)\".*/\1/g" )

HELLO_CURL=${WORKER_IP}:${SERVICE_PORT}

# make sure the service works
comment "We're starting with the same output as the previous lab"
doit curl -s ${HELLO_CURL}

comment we have the pods
doit kubectl get pods -l run=hello-world

# these pods come from the deployment
# kubectl get deployment ${DEPLOYMENT_NAME}

comment --nolf "You should start this watch in a separate terminal"
comment "    watch -d -n 0.2 curl -s ${HELLO_CURL}"
comment --pause "Press ENTER when ready"

replicas=$(( ( RANDOM % 5 )  + 2 ))
comment --nocr --pause "How many replicas? "
comment --nocomment $replicas

# use `kubectl scale`
doit kubectl scale deployment ${DEPLOYMENT_NAME} --replicas ${replicas}

# show the pods
doit kubectl get pods -l run=hello-world
