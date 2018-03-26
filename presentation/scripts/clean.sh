#!/bin/bash

kubectl delete deploy/hello-world || true
kubectl delete svc/hello-world || true
