#!/bin/bash

source ./lab.sh

read -p "deploy our app on kubernetes, using the image in our registry"

set -v
kubectl run ${DEPLOYMENT_NAME} --image=${IMAGE_NAME}:v1 

read -p "the result of our run command is a deployment."

kubectl get deployment ${DEPLOYMENT_NAME}

read -p " we can see the desired and current states. Kubernetes is reconciling to achieve our objective"

read -p "the actual unit of work is running in a pod"

get_pods

read -p "we can see that it is ready and running"


