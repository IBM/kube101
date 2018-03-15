#!/bin/bash
echo "Testing YAML files for <namespace>"
ls */*.yml
imageLines=`grep image: */*.yml`
namespaceLines=`grep \<namespace\> */*.yml`
if [ "$imageLines" = "$namespaceLines" ]; then
    echo "<namespace> found as expected in YAML files"
else
    echo "<namespace> NOT FOUND as expected in YAML files"
    exit 1
fi

