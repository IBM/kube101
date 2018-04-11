#!/bin/bash

source ./common.sh

# `kubectl set image` to change the underlying image to our v2 version
comment "Update the deployment with the new image"
doit kubectl set image deployment ${DEPLOYMENT_NAME} guestbook=${IMAGE_NAME}:v2

doit kubectl describe deployment ${DEPLOYMENT_NAME}
line=$(grep Image out)
comment --nolf "Notice where is shows:"
comment "$line"

comment --pauseafter "*** End of "$(basename $0)
