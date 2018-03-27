#!/bin/bash

source ./common.sh

comment "Deploy our app on kubernetes, using the image in our registry"
doit kubectl run ${DEPLOYMENT_NAME} --image=${IMAGE_NAME}:v1 

comment "The result of our run command is a deployment."
doit kubectl get deployment ${DEPLOYMENT_NAME}

comment --nolf "Notice the desired & current states."
comment --nolf "Kubernetes is reconciling to achieve our objective"
comment  "The actual unit of work is running in a pod"
doit kubectl get pods -l run=guestbook

comment "We can see that it is ready and running"

comment --pauseafter "*** End of "$(basename $0)
