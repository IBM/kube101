# Kubernetes 101 Lab

<img src="https://kubernetes.io/images/favicon.png" width="200">

## Objectives

This lab is an introduction to using Docker containers on Kubernetes in the IBM Cloud Kubernetes Service. By the end of the course, you'll achieve these objectives:
* Understand core concepts of Kubernetes.
* Build a Docker image and deploy an application on Kubernetes in the IBM Cloud Kubernetes Service. 
* Control application deployments, while minimizing your time with infrastructure management.
* Add AI services to extend your app.
* Secure and monitor your cluster and app.

## Prerequisites 
* An [IBM Cloud account](https://console.bluemix.net/registration/).
* A basic understanding of Linux.

## A brief history of containers

### Virtual machines

Prior to containers, most infrastructures ran not on bare metal, but atop hypervisors managing multiple virtualized operating systems (OSes). This arrangement allowed isolation of applications from one another on a higher level than that provided by the OS. These virtualized operating systems see what looks like their own exclusive hardware. However, this also means that each of these virtual operating systems are replicating an entire OS, taking up disk space.

### Containers

Containers allow you to run securely isolated applications with quotas on system resources. Containers started out as an individual feature that was delivered with the Linux kernel. Docker launched with making containers easy to use and developers quickly latched onto that idea. Containers also sparked an interest in microservice architecture, a design pattern for developing applications in which complex applications are down into smaller, composable pieces which work together.
(This [video](https://www.youtube.com/watch?v=wlBhtc31I8c) explains the production uses of containers.)

Containers provide isolation similar to VMs, except they're provided by the OS and at the process level. Each container is a process or group of processes that run in isolation. Typical containers explicitly run only a single process, as they have no need for the standard system services. What they usually need to do can be provided by system calls to the base OS kernel.

The isolation on Linux is provided by a feature called `namespaces`. Each different kind of isolation (IE user, cgroups) is provided by a different namespace.

This is a list of some of the namespaces that are commonly used and visible to the user:

* PID - process IDs
* USER - user and group IDs
* UTS - hostname and domain name
* NS - mount points
* NET - network devices, stacks, and ports
* CGROUPS - control limits and monitoring of resources

If you're looking for a containers 101 course, make sure to check out our [Docker Essentials](https://developer.ibm.com/courses/all/docker-essentials-extend-your-apps-with-containers/).

## VM vs container

Traditional applications are run on native hardware. A single application does not typically use the full resources of a single machine. We try to run multiple applications on a single machine to avoid wasting resources. We could run multiple copies of the same application, but to provide isolation we use VMs to run multiple application instances on the same hardware. These VMs have full operating system stacks which make them relatively large and inefficient due to duplication both at runtime and on disk.

![Containers versus VMs](images/VMvsContainer.png)

Containers, on the other hand, allow you to share the host OS. This reduces duplication while still providing the isolation. Containers also allow you to drop unneeded files such as system libraries and binaries to save space and reduce your attack surface. If SSHD or LIBC are not installed, they cannot be exploited.


## Kubernetes and how it relates to containers

Let's talk about Kubernetes orchestration for containers before we build an application on it. We need to understand the following facts about it:

* What is Kubernetes, exactly?
* How was Kubernetes created?
* The Kubernetes architecture
* The Kubernetes resource model
* The Kubernetes application deployment workflow

### What is Kubernetes?

Now that we know what containers are, let's define what Kubernetes actually is. Kubernetes is a container orchestrator to provision, manage, and scale applications. In other words, Kubernetes allows you to manage the lifecycle of containerized applications within a cluster of nodes (which are a collection of worker machines, for example, VMs, physical machines etc.).

Your applications may need many other resources to run such as Volumes, Networks, and Secrets that will help you to do things such as connect to databases, talk to firewalled backends, and secure keys. Kubernetes helps you add these resources into your application. Infrastructure resources needed by applications are managed declaratively.

**Fast fact:** Other orchestration technologies are Mesos and Swarm.  

The key paradigm of Kubernetes is its Declarative model. The user provides the "desired state" and Kubernetes will do its best make it happen. If you need five instances, you do not start five separate instances on your own but rather tell Kubernetes the number of instances and Kubernetes will reconcile the state automatically. Simply put, you declare the state you want and Kubernetes makes it happen. If something goes wrong with one of your instances and it crashes, Kubernetes still knows the desired state and creates new instances on an available node.

**Fun fact:** Kubernetes goes by many names. Sometimes it is shortened to _k8s_ (losing the internal 8 letters), or _kube_. The word is rooted in ancient Greek and means "Helmsman." A helmsman is the person who steers a ship. We hope you can seen the analogy between directing a ship and the decisions made to orchestrate containers on a cluster.

### How was Kubernetes created?

Google wanted to open source their knowledge of creating and running the internal tools Borg & Omega. It adopted Open Governance for Kubernetes by starting the Cloud Native Computing Foundation (CNCF) and giving Kubernetes to that foundation, therefore making it less influenced by Google directly. Many companies such as RedHat, Microsoft, IBM and Amazon quickly joined the foundation.

The main entry point for the Kubernetes project is at [http://kubernetes.io](http://kubernetes.io) and the source code can be found at [https://github.com/kubernetes](https://github.com/kubernetes).

### The Kubernetes architecture

At its core, Kubernetes is a data store (etcd). The declarative model is stored in the data store as objects, which means when you say "I want five instances of a container," then that request is stored into the data store. This information change is watched and delegated to Controllers to take action. Controllers then react to the model and attempt to take action to achieve the desired state. The power of Kubernetes is in its simplistic model.

As shown in the below diagram, an API server is a simple HTTP server handling create/read/update/delete(CRUD) operations on the data store. Then the Controller picks up the change that you indicated and makes that happen. Controllers are responsible for instantiating the actual resource represented by any Kubernetes resource. These actual resources are what your application needs to allow it to run successfully.

![architecture diagram](images/kubernetes_arch.png)

### The Kubernetes resource model

Kubernetes Infrastructure defines a resource for every purpose. Each resource is monitored and processed by a controller. When you define your application, it contains a collection of these resources. This collection will then be read by Controllers to build your application's actual backing instances. Some resources that you may work with are listed below for your reference, for a full list you should go to [https://kubernetes.io/docs/concepts/](https://kubernetes.io/docs/concepts/). In this course, we will only use a few of them, like pod, deployment, etc. 

Here are some commonly used resources to know:

* **Config Maps** holds configuration data for pods to consume.
* **Daemon Sets** ensure that each node in the cluster runs this pod.
* **Deployments** are a desired state of a deployment object.
* **Events** provide lifecycle events on Pods and other deployment objects.
* **Endpoints** allow inbound connections to reach the cluster services.
* **Ingress** is a collection of rules that allow inbound connections to reach the cluster services.
* **Jobs** create one or more pods and as they complete successfully the job is marked as completed.
* **Node** is a worker machine in Kubernetes.
* **Namespaces** are multiple virtual clusters that are backed by the same physical cluster.
* **Pods** are the smallest deployable units of computing that can be created and managed in Kubernetes. 
* **Persistent Volumes** provide an API for users and administrators that abstracts details of how storage is provided from how it is consumed.
* **Replica Sets** ensure that a specified number of pod replicas are running at any given time.
* **Secrets** are intended to hold sensitive information, such as passwords, OAuth tokens, and ssh keys.
* **Service Accounts** provide an identity for processes that run in a pod.
* **Services** is an abstraction that defines a logical set of pods and a policy by which to access them - sometimes called a **microservice**.
* **Stateful Sets** is the workload API object used to manage stateful applications.   

![Relationship of pods, nodes, and containers](images/container-pod-node-master-relationship.jpg)

*Note: Kubernetes does not have the concept of an application, it only has simple building blocks that you are required to compose. Kubernetes is a cloud native platform where the internal resource model is the same as the end user resource model.*

#### Some things to note

* As noted above, a pod is the smallest deployable units of computing. A pod typically represents a process in your cluster and contains at least one container that runs the job and additionally may have other containers in it called **sidecars** for monitoring, logging, etc. You can add labels to a pod to identify a subset to run operations on and when you're ready to scale your application, you can use the label to tell Kubernetes which pod you need to scale. 

* When we talk about an **application** throughout the labs, we are referring to a group of pods. Although an entire application can be run in a single pod, we usually build multiple pods that talk to each other to make a useful application. We will see why separating the application logic and backend database into separate pods will scale better when we build an application shortly.

* **Services** define how to expose your app as a DNS entry to have a stable reference. We use a query-based selector to choose which pods are supplying that service.

* The user directly manipulates resources via yaml:
  ```$ kubectl (create|get|apply|delete) -f myResource.yaml
  ```

* Kubernetes provides us with a client interface through `kubectl`. Kubectl commands allow you to manage your applications, 
  cluster, and cluster resources by modifying the model in the data store.

#### Kubernetes application deployment workflow

![deployment workflow](images/app_deploy_workflow.png)

1. Via `kubectl`, the user deploys a new application. Kubectl sends the request to the API server.
2. API server receives the request and stores it in the data store (etcd). Once the request is written to the data store, the API server is done with the request.
3. Watchers detect the resource changes and send a notification to controller to act upon it.
4. Controller detects the new app and creates new pods to match the desired number of instances. Any changes to the stored model will be picked up to create or delete pods.
5. Scheduler assigns new pods to a Node based on its criteria and makes decisions to run pods on specific Nodes in the cluster. Scheduler also modifies the model with the Node information.
6. Kubelet on a Node detects a pod with an assignment to itself, and deploys the requested containers via the container runtime (e.g., Docker). Each Node watches the storage to see what pods it is assigned to run. It takes necessary actions on resources assigned to it like creating or deleting pods.
7. Kubeproxy manages network traffic for the pods, including service discovery and load balancing. Kubeproxy is responsible for communication between pods that want to interact.


#### Kubernetes at IBM

IBM Cloud provides you with the capability to run applications in containers on Kubernetes. The IBM Cloud Kubernetes Service runs Kubernetes clusters to deliver the following:

* Powerful tools
* Intuitive user experience
* Built-in security and isolation to enable rapid delivery of secure applications
* Cloud services, including AI capabilities from Watson
* The capability to manage dedicated cluster resources for both stateless applications and stateful workloads


## Lab overview

[Lab 0](Lab0) (Optional): Provides a walkthrough for installing IBM Cloud command-line tools and the Kubernetes CLI. You can skip this lab if you have the IBM Cloud CLI, the container service plugin, the containers registry plugin, and the kubectl CLI already installed on your machine.

[Lab 1](Lab1): Walks through creating and deploying a simple "guestbook" app written in Go as a net/http Server and accessing it.

[Lab 2](Lab2): Builds on Lab 1 to expand to a more resilient setup, which can survive having containers fail and recover. Lab 2 will also walk through basic services that you need to get started with Kubernetes and the IBM Cloud Kubernetes Service.

[Lab 3](Lab3): Builds on Lab 2 by increasing the capabilities of the deployed guestbook application. This lab covers basic distributed application design and how Kubernetes helps you use standard design practices.

[Lab 4](Lab4): Teaches you how define liveness probes so that Kubernetes can automatically monitor and recover your applications with no user intervention.

[Lab D](LabD): Debugging tips and tricks to help you along your Kubernetes journey. This lab is a useful reference that does not follow in a specific sequence of the other labs.
