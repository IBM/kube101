!SLIDE[bg=_images/backgrounds/white_bg.png]

# Outline

* Configure ``kubectl``
* Clone source code
* Deploy redis "database"
* Deploy sample app
* Poke app /w stick
* Delete app

!SLIDE[bg=_images/backgrounds/white_bg.png]

# What's not covered

* Docker build step
* Making a change to the app
* Deploying new version


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Account setup

    $ bx login
    $ bx api https://api.ng.bluemix.net

!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Account setup

    $ bx cs clusters
    Name                         ID                                 State       Created          Workers   Location   Version   
    k8s.nibz.science             c78ab82852aa47c793aa993178f1c560   normal      2 months ago     4         dal10      1.8.11_1509   
    $ bx cs cluster-config k8s.nibz.science
    OK
    The configuration for k8s.nibz.science was downloaded successfully. Export environment variables to start using Kubernetes.
    export KUBECONFIG=/home/nibz/.bluemix/plugins/container-service/clusters/k8s.nibz.science/kube-config-dal10-k8s.nibz.science.yml

    $ export KUBECONFIG=/home/nibz/.bluemix/plugins/container-service/clusters/k8s.nibz.science/kube-config-dal10-k8s.nibz.science.yml



!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Clone the code

    $ git clone https://github.com/IBM/guestbook
    Cloning into 'guestbook'...
    remote: Counting objects: 166, done.
    remote: Total 166 (delta 0), reused 0 (delta 0), pack-reused 165
    Receiving objects: 100% (166/166), 88.84 KiB | 0 bytes/s, done.
    Resolving deltas: 100% (92/92), done.
    Checking connectivity... done.
    $ cd guestbook


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Validate the cluster is empty

    $ kubectl get deploy
    NAME           DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE

    $ kubectl get pod
    NAME                                 READY     STATUS    RESTARTS   AGE

    $

!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

#  Deploy the redis master

    $ kubectl create -f redis-master-deployment.yaml
    deployment "redis-master" created


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental


#  Evaluate what has been created


    $ kubectl get deploy
    NAME           DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE 
    redis-master   1         1         1            1           10m

    $ kubectl get replicaset
    NAME                      DESIRED   CURRENT   READY     AGE 
    redis-master-6767cf65c7   1      

!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental


#  Evaluate what has been created

    $ kubectl get pods
    NAME                        READY     STATUS    RESTARTS   AGE 
    redis-master-xx4uv          1/1       Running   0          1m


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

#  Evaluate what has been created


    $: kubectl describe deploy/redis-master
    Name:                   redis-master
    Namespace:              default
    CreationTimestamp:      Fri, 27 Apr 2018 13:46:56 -0500
    ...


    $ kubectl describe pod/redis-master-6767cf65c7-7kgcw
    Name:           redis-master-6767cf65c7-7kgcw
    Namespace:      default
    Node:           10.186.59.66/10.186.59.66

!SLIDE[bg=_images/backgrounds/black_bg.png]

.blockwhite Pause and Inquire!

.blockteal What version of redis has been deployed?

.blockteal How many replicas have been deployed?

.blockteal What is the most recent event in the event log for the pod?

``Hint! Use kubectl describe``


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental


# Deploy a service for the redis master

    $ kubectl create -f redis-master-service.yaml
    services/redis-master


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Verify service


    $ kubectl get services
    NAME              CLUSTER_IP       EXTERNAL_IP       PORT(S)       SELECTOR               AGE
    redis-master      10.0.136.3       <none>            6379/TCP      app=redis,role=master  1h
    ...



!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Deploy redis downstream servers


    $ kubectl create -f redis-slave-deployment.yaml
    deployment.apps "redis-slave" created



!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Deploy redis downstream servers

    $ kubectl get deploy
    NAME           DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    redis-master   1         1         1            1           23m
    redis-slave    2         2         2            0           15s

    $ kubectl get rs
    NAME                      DESIRED   CURRENT   READY     AGE
    redis-master-6767cf65c7   1         1         1         23m
    redis-slave-564b7bd5d9    2         2         2         30s


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Validate everything


    $ kubectl get pods
    NAME                          READY     STATUS    RESTARTS   AGE
    redis-master-xx4uv            1/1       Running   0          25m
    redis-slave-b6wj4             1/1       Running   0          1m
    redis-slave-iai40             1/1       Running   0          1m

!SLIDE[bg=_images/backgrounds/white_bg.png] incremental

# A note on Redis


* The Redis slaves get started by the deployment/replicaset with the following command:

    ``redis-server --slaveof redis-master 6379``

* Why does this work?

* Service Discovery!


!SLIDE[bg=_images/backgrounds/white_bg.png] incremental

# Service Discovery

* Every k8s ``service`` creates a ``cluster-ip``
* Every container running in k8s can see all these ips
* The name of the service is injected into DNS and environment variables
* How can we explore/verify this?


!SLIDE[bg=_images/backgrounds/white_bg.png] incremental

# Get a shell inside the cluster


    @@@ Console
    kubectl run -i --tty --rm debug \
    --image=busybox --restart=Never -- sh




!SLIDE[bg=_images/backgrounds/black_bg.png]

.blockwhite Pause and Inquire!

.blockteal Use the shell example to get a working debug pod

.blockteal Extra: Run ``kubectl get pod`` in another terminal to see your debug pod

``Hint!  kubectl run -i --tty --rm debug --image=busybox --restart=Never -- sh``


!SLIDE[bg=_images/backgrounds/black_bg.png]

.blockwhite Pause and Inquire!

.blockteal Use ``env`` and ``ping`` to verify that service discovery works

.blockteal Extra: If you ``kubectl delete`` the redis-server pod, what happens?

``Hint!  kubectl run -i --tty --rm debug --image=busybox --restart=Never -- sh``


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Deploy the 'guestbook' application

    $ kubectl get deploy
    NAME           DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    redis-master   1         1         1            1           23m
    redis-slave    2         2         2            0           15s

    $ kubectl get rs
    NAME                      DESIRED   CURRENT   READY     AGE
    redis-master-6767cf65c7   1         1         1         23m
    redis-slave-564b7bd5d9    2         2         2         30s


