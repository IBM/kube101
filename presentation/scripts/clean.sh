#!/bin/bash

source ./demoscript

comment "Cleaning up..."

kubectl delete deploy/hello-world || true
kubectl delete svc/hello-world || true
