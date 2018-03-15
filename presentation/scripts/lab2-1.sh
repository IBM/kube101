#!/bin/bash

source ./lab.sh

# make sure the service works
echo "We're starting with the same output as the previous lab"
curl ${HELLO_CURL}
echo we have the pods
get_pods

# these pods come from the deployment
# kubectl get deployment ${DEPLOYMENT_NAME}

echo you should start this watch in a separate terminal 
echo "   " watch -d -n 0.2 curl -ss ${HELLO_CURL}
read -p 'ready to go? press enter to continues'

read -p 'How many replicas? ' replicas

# use `kubectl scale`
kubectl scale deployment ${DEPLOYMENT_NAME} --replicas ${replicas}
# show the pods
get_pods





