#!/bin/bash

source ./demoscript

comment "Cleaning up..."

kubectl delete deploy/guestbook || true
kubectl delete svc/guestbook || true
