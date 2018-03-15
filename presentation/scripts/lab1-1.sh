#!/bin/bash

source ./lab.sh

read -p "build the first version of our docker image"

# build image
set -v
docker build --tag ${IMAGE_NAME}:v1 .

read -p "Let us test the image locally with Docker before we run it on kube. This allows us to see what output we expect when running on the cluster."

CID=$(docker run -itd -p 32768:8080 ${IMAGE_NAME}:v1)

read -p "now that our image is running, we will use curl to access the content"

curl localhost:32768

read -p ""

docker rm -f ${CID}

read -p "after building, we push to the container registry, 
        so that our kubernetes cluster can pull it down to run it"

# push it
docker push ${IMAGE_NAME}:v1

read -p "let's look at our images on the remote registry"

bx cr images

