
# Pod

In Kubernetes, a group of one or more containers is called a pod. Containers in a pod are deployed together, and are started, stopped, and replicated as a group. The simplest pod definition describes the deployment of a single container. For example, an nginx web server pod might be defined as such:
```
apiVersion: v1
kind: Pod
metadata:
  name: mynginx
  namespace: default
  labels:
    run: nginx
spec:
  containers:
  - name: mynginx
    image: nginx:latest
    ports:
    - containerPort: 80
```

# Labels

In Kubernetes, labels are a system to organize objects into groups. Labels are key-value pairs that are attached to each object. Label selectors can be passed along with a request to the apiserver to retrieve a list of objects which match that label selector.

To add a label to a pod, add a labels section under metadata in the pod definition:
```
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: nginx
...
```
To label a running pod
```
  kubectl label pod mynginx type=webserver
  pod "mynginx" labeled
```
To list pods based on labels
```
  kubectl get pods -l type=webserver
  NAME      READY     STATUS    RESTARTS   AGE
  mynginx   1/1       Running   0          21m

```


# Deployments

A Deployment provides declarative updates for pods and replicas. You only need to describe the desired state in a Deployment object, and it will change the actual state to the desired state. The Deployment object defines the following details:

The elements of a Replication Controller definition
The strategy for transitioning between deployments
To create a deployment for a nginx webserver, edit the nginx-deploy.yaml file as
```
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  generation: 1
  labels:
    run: nginx
  name: nginx
  namespace: default
spec:
  replicas: 3
  selector:
    matchLabels:
      run: nginx
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
    type: RollingUpdate
  template:
    metadata:
      labels:
        run: nginx
    spec:
      containers:
      - image: nginx:latest
        imagePullPolicy: Always
        name: nginx
        ports:
        - containerPort: 80
          protocol: TCP
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      securityContext: {}
      terminationGracePeriodSeconds: 30

```
and create the deployment
```
kubectl create -f nginx-deploy.yaml
deployment "nginx" created
```
The deployment creates the following objects
```
kubectl get all -l run=nginx

NAME           DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deploy/nginx   3         3         3            3           4m

NAME                 DESIRED   CURRENT   READY     AGE
rs/nginx-664452237   3         3         3         4m

NAME                       READY     STATUS    RESTARTS   AGE
po/nginx-664452237-h8dh0   1/1       Running   0          4m
po/nginx-664452237-ncsh1   1/1       Running   0          4m
po/nginx-664452237-vts63   1/1       Running   0          4m
```

# services

Services

Kubernetes pods, as containers, are ephemeral. Replication Controllers create and destroy pods dynamically, e.g. when scaling up or down or when doing rolling updates. While each pod gets its own IP address, even those IP addresses cannot be relied upon to be stable over time. This leads to a problem: if some set of pods provides functionality to other pods inside the Kubernetes cluster, how do those pods find out and keep track of which other?

A Kubernetes Service is an abstraction which defines a logical set of pods and a policy by which to access them. The set of pods targeted by a Service is usually determined by a label selector. Kubernetes offers a simple Endpoints API that is updated whenever the set of pods in a service changes.

To create a service for our nginx webserver, edit the nginx-service.yaml file
```
apiVersion: v1
kind: Service
metadata:
  name: nginx
  labels:
    run: nginx
spec:
  selector:
    run: nginx
  ports:
  - protocol: TCP
    port: 8000
    targetPort: 80
  type: ClusterIP
```
Create the service

`kubectl create -f nginx-service.yaml`
service "nginx" created
```
kubectl get service -l run=nginx
NAME      CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
nginx     10.254.60.24   <none>        8000/TCP    38s

```
Describe the service:
```
kubectl describe service nginx
Name:                   nginx
Namespace:              default
Labels:                 run=nginx
Selector:               run=nginx
Type:                   ClusterIP
IP:                     10.254.60.24
Port:                   <unset> 8000/TCP
Endpoints:              172.30.21.3:80,172.30.4.4:80,172.30.53.4:80
Session Affinity:       None
No events.
```
The above service is associated to our previous nginx pods. Pay attention to the service selector run=nginx field. It tells Kubernetes that all pods with the label run=nginx are associated to this service, and should have traffic distributed amongst them. In other words, the service provides an abstraction layer, and it is the input point to reach all of the associated pods.
