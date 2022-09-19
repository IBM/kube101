#!/bin/bash

echo "Create Demo Application"

IP_ADDR=$(bx cs workers $CLUSTER_NAME | grep normal | awk '{ print $2 }')
if [ -z $IP_ADDR ]; then
  echo "$CLUSTER_NAME not created or workers not ready"
  exit 1
fi

echo -e "Configuring vars"
exp=$(bx cs cluster-config $CLUSTER_NAME | grep export)
if [ $? -ne 0 ]; then
  echo "Cluster $CLUSTER_NAME not created or not ready."
  exit 1
fi
eval "$exp"

echo -e "Setting up Stage 3 Watson Deployment yml"
cd Stage3/
# curl --silent "https://raw.githubusercontent.com/IBM/container-service-getting-started-wt/master/Stage3/watson-deployment.yml" > watson-deployment.yml
#
## WILL NEED FOR LOADBALANCER ###
# #Find the line that has the comment about the load balancer and add the nodeport def after this
# let NU=$(awk '/^  # type: LoadBalancer/{ print NR; exit }' guestbook.yml)+3
# NU=$NU\i
# sed -i "$NU\ \ type: NodePort" guestbook.yml #For OSX: brew install gnu-sed; replace sed references with gsed

echo -e "Deleting previous version of Watson Deployment if it exists"
kubectl delete --ignore-not-found=true -f watson-deployment.yml

echo -e "Unbinding previous version of Watson Tone Analyzer if it exists"
bx service list | grep tone
if [ $? -eq 0 ]; then
  bx cs cluster-service-unbind $CLUSTER_NAME default tone
fi

echo -e "Deleting previous Watson Tone Analyzer instance if it exists"
bx service delete tone -f

echo -e "Creating new instance of Watson Tone Analyzer named tone..."
bx service create tone_analyzer standard tone

echo -e "Binding Watson Tone Service to Cluster and Pod"
bx cs cluster-service-bind $CLUSTER_NAME default tone

echo -e "Building Watson and Watson-talk images..."
cd watson/
docker build -t registry.ng.bluemix.net/contbot/watson . &> buildout.txt
if [ $? -ne 0 ]; then
  echo "Could not create the watson image for the build"
  cat buildout.txt
  exit 1
fi
docker push registry.ng.bluemix.net/contbot/watson
if [ $? -ne 0 ]; then
  echo "Could not push the watson image for the build"
  exit 1
fi
cd ..
cd watson-talk/
docker build -t registry.ng.bluemix.net/contbot/watson-talk . &> buildout.txt
if [ $? -ne 0 ]; then
  echo "Could not create the watson-talk image for the build"
  cat buildout.txt
  exit 1
fi
docker push registry.ng.bluemix.net/contbot/watson-talk
if [ $? -ne 0 ] ; then
  echo "Could not push the watson image for the build"
  exit 1
fi

echo -e "Injecting image namespace into deployment yamls"
cd ..
sed -i "s/<namespace>/${BLUEMIX_NAMESPACE}/" watson-deployment.yml
if [ $? -ne 0 ] ; then
  echo "Could not inject image namespace into deployment yaml"
  exit 1
fi

echo -e "Creating pods"
kubectl create -f watson-deployment.yml

PORT=$(kubectl get services | grep watson-service | sed 's/.*:\([0-9]*\).*/\1/g')

echo ""
echo "View the watson talk service at http://$IP_ADDR:$PORT"
