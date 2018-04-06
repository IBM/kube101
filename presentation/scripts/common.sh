#!/bin/bash

source ./demoscript

# These need to be changed by the person running the demo, or set them
# in your environment prior to running the scripts
NAMESPACE=${NAMESPACE:-kube101}
CLUSTER_NAME=${CLUSTER_NAME:-osscluster}

# Should not need to touch these
DEPLOYMENT_NAME=guestbook
IMAGE_NAME=ibmcom/guestbook

