#!/bin/bash
echo "Install IBM Cloud CLI"
. ./install_bx.sh
if [ $? -ne 0 ]; then
  echo "Failed to install IBM Cloud Container Service CLI prerequisites"
  exit 1
fi

echo "Login to IBM Cloud"
. ./bx_login.sh
if [ $? -ne 0 ]; then
  echo "Failed to authenticate to IBM Cloud Container Service"
  exit 1
fi

echo "Testing yml files for generalized namespace"
. ./test_yml.sh
if [ $? -ne 0 ]; then
  echo "Failed to find <namespace> in deployment YAML files"
  exit 1
fi

echo "Deploy pods for Stage 3..."
. ./deploy.sh
if [ $? -ne 0 ]; then
  echo "Failed to Deploy pods for stage 3 to IBM Cloud Container Service"
  exit 1
fi
