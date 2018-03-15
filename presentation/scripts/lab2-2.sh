#!/bin/bash

source ./lab.sh

read -p "now we'll build a version 2 of our image and push it"
# build a new image
docker build --tag ${IMAGE_NAME}:v2 .

read -p "push it"
# push it
docker push ${IMAGE_NAME}:v2

read -p " now we'll ask kube to change to the new image"
set +x
# `kubectl set image` to change the underlying image
kubectl set image deployment ${DEPLOYMENT_NAME} hello-world=${IMAGE_NAME}:v2



