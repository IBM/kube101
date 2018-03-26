#!/bin/bash

source ./common.sh

comment "Build a v2 of our image"
DIR=$(pwd)
cd ../../workshop/Lab1
doit docker build --tag ${IMAGE_NAME}:v2 .
cd $DIR


comment "Push it to the IBM Cloud registry"
doit docker push ${IMAGE_NAME}:v2

# `kubectl set image` to change the underlying image
comment "Update the deployment with the new image"
doit kubectl set image deployment ${DEPLOYMENT_NAME} hello-world=${IMAGE_NAME}:v2

doit kubectl describe deployment ${DEPLOYMENT_NAME}
line=$(grep Image out)
comment --nolf "Notice where is shows:"
comment "$line"
