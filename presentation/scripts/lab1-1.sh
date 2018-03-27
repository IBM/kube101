#!/bin/bash

source ./common.sh

comment "Build the first version of our docker image"
DIR=$(pwd)
cd ../../workshop/Lab1
doit docker build --tag ${IMAGE_NAME}:v1 .
cd $DIR

# We're going to test the image locally with Docker before we run it on Kube.
# This is to allow us ot see what the output looks like in advance.
# Notice we're mapping port 8080 in the container to 32768 on the host.
comment "First run/test locally"
doit docker run -itd -p 32768:8080 ${IMAGE_NAME}:v1
CID=$(cat out)  # Save the container ID

# Now that our image is running, we will use curl to access the content
comment "Test it"
doit curl -s localhost:32768

comment "Clean up container"
doit docker rm -f ${CID}

# Push the image to the registry so Kubernetes wil find it
comment "Push the image to the IBM Cloud registry"
doit docker push ${IMAGE_NAME}:v1

comment "Verify it's there"
doit bx cr images

comment --pauseafter "*** End of "$(basename $0)
