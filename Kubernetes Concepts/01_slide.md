!SLIDE[bg=_images/backgrounds/white_bg.png]

# Kubernetes

* k8s for short
* Founded by Google
* CNCF: Cloud Native Computing Foundation
* Container Management


!SLIDE[bg=_images/backgrounds/white_bg.png]

# What is a container

* Usually, just a Bocker container
* Strictly, the Open Container Initiative manages this definition
* Process on Linux\*, subject to some sandboxing and restrictions

!SLIDE[bg=_images/backgrounds/white_bg.png]

# Container Management

* Start some containers!
* Which containers are running?
* Did it crash? Restart it!
* Make more of them, but keep them on different physical hosts



!SLIDE[bg=_images/backgrounds/white_bg.png]


.huge Kubernetes manages containers. <span class="teal">Users of kubernetes</span> Manage higher level abstracted <span class="teal">resources.</span>


!SLIDE[bg=_images/backgrounds/black_bg.png]

.blockwhite Three 'killer' features:

.blockteal * Automatic Restarts

.blockteal * Horizontal Scaling

.blockteal * Service Discovery


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Working with Kubernetes

    $ kubectl get deploy
    NAME           DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE

    $

!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Working with Kubernetes

    $ cat guestbook-deployment.yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: guestbook
    spec:
      replicas: 3
      selector:
        matchLabels:
          app: guestbook
    ...
    $ kubectl create -f guestbook-deployment.yaml
    deployment.apps "guestbook" created


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental


# Working with Kubernetes

    $ kubectl get deploy
    NAME           DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    redis-master   1         1



!SLIDE[bg=_images/backgrounds/black_bg.png]

.blockwhite Quick Pause

.blockteal Any Account or Cluster issues?



!SLIDE[bg=_images/backgrounds/white_bg.png] incremental


# Kubernetes Resources

* Pod
* Deployment
* Service


!SLIDE[bg=_images/backgrounds/white_bg.png] incremental

# Pod

* Smallest unit of deployment
* Consists usually of one container
* Has an image, version, exposed port, etc


!SLIDE[bg=_images/backgrounds/white_bg.png] incremental

# Deployment

* Deployments manage *replication controllers*
* Replication controllers manage pods
* Entrypoint for more advanced rollout strategies


!SLIDE[bg=_images/backgrounds/white_bg.png] incremental

# Service

* Exposes a single ip to the rest of the cluster
* Almost like a load balancer
* Maps to one or more pods
* There are a couple different kinds


!SLIDE[bg=_images/backgrounds/white_bg.png]

# Community Resources

* https://kubernetes.io/docs/imported/community/devel/
* Slack: kubernetes.slack.com
