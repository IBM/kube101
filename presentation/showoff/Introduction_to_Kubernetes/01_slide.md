!SLIDE[bg=_images/backgrounds/white_bg.png]
# What is Kubernetes

* Container Orchestrator
 * Provision, manage, scale applications

* Manage infrastructure resources needed by applications
 * Volumes
 * Networks
 * Secrets
 * And many many many more...


!SLIDE[bg=_images/backgrounds/white_bg.png]
# What is Kubernetes


* Declarative model
 * Provide the "desired state" and Kubernetes will make it happen

* What's in a name?
 * Kubernetes (K8s/Kube): "Helmsman" in ancient Greek


!SLIDE[bg=_images/backgrounds/white_bg.png]
# Kubernetes Architecture

At its core, Kubernetes is a database (etcd).
With "watchers" & "controllers" that react to changes in the DB.
The controllers are what make it Kubernetes.
This pluggability and extensibility is part of its "secret sauce".

DB represents the user's desired state
Watchers attempt to make reality match the desired state


!SLIDE[bg=_images/kube_architecture.png] background-fit


!SLIDE[bg=_images/backgrounds/white_bg.png]
# Kubernetes Resource Model


    @@@ Console
        Resource types:

        Config Maps,          Daemon Sets.
        Deployments,          Events.
        Endpoints,            Ingress,
        Jobs,                 Nodes,
        Namespaces,           Pods,
        Persistent Volumes,   Replica Sets,
        Secrets,              Service Accounts,
        Services,             Stateful Sets
        ....


!SLIDE[bg=_images/backgrounds/white_bg.png]
# Kubernetes Resource Model

* Kubernetes aims to have the building blocks on which you build a cloud native platform.

* Therefore, the internal resource model is the same as the end user resource model.


!SLIDE[bg=_images/backgrounds/black_bg.png]

.blockwhite Key Resources: Pod

.blockwhite Set of co-located containers

.blockwhite Smallest unit of deployment

.blockwhite Several types of resources to help manage them


!SLIDE[bg=_images/backgrounds/black_bg.png]

.blockwhite Key Resources: Services

.blockwhite Define how to expose your app as a DNS entry

.blockwhite Query based selector to choose which pods apply

!SLIDE[bg=_images/backgrounds/black_bg.png]

.blockwhite Key Resources: Services

.blockwhite Define how to expose your app as a DNS entry

.blockwhite Query based selector to choose which pods apply



!SLIDE[bg=_images/backgrounds/white_bg.png]
# Kubernetes Client: kubectl


CLI tool to interact with Kubernetes cluster

Platform specific binary available to download
https://kubernetes.io/docs/tasks/tools/install-kubectl

The user directly manipulates resources via json/yaml

    $ kubectl (create|get|apply|delete) -f myResource.yaml



!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental
# kubectl examples

    $ kubectl help
    kubectl controls the Kubernetes cluster manager. 

    Find more information at: https://kubernetes.io/docs/reference/kubectl/overview/

    Basic Commands (Beginner):
      create         Create a resource from a file or from stdin.
      expose         Take a replication controller, service, deployment or pod and
    expose it as a new Kubernetes Service
      run            Run a particular image on the cluster


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental
# kubectl examples

    $ kubectl explain service
    KIND:     Service
    VERSION:  v1

    DESCRIPTION:
         Service is a named abstraction of software service (for example, mysql)
         consisting of local port (for example 3306) that the proxy listens on, and
         the selector that determines which pods will answer requests sent through
         the proxy.


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental
# kubectl examples

    $ kubectl create -f guestbook-deployment.yaml
    deployment.apps "guestbook" created


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental
# kubectl examples

    $ kubectl get deploy
    NAME           DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    guestbook      3         3         3            3           38s
    redis-master   1         1         1            1           27m
    redis-slave    2         2         2            2           4m



!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental
# kubectl examples

1. User via "kubectl" deploys a new application
1. API server receives the request and stores it in the DB (etcd)
1. Watchers/controllers detect the resource changes and act upon it
1. ReplicaSet watcher/controller detects the new app and creates new pods to match the desired # of instances
1. Scheduler assigns new pods to a kubelet
1. Kubelet detects pods and deploys them
via the container runtime (e.g. Docker)
1. Kubeproxy manages network traffic for the pods – including service discovery and load-balancing


!SLIDE[bg=_images/backgrounds/white_bg.png]
# kubectl examples

!SLIDE[bg=_images/kube_sequence.png] background-fit

