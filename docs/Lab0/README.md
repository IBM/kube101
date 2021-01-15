# Lab 0. Access a Kubernetes cluster

## Set up your kubernetes environment

For the hands-on labs in this tutorial repository, you will need a kubernetes cluster. One option for creating a cluster is to make use of the Kubernetes as-a-service from the IBM Cloud Kubernetes Service as outlined below.

### Use the IBM Cloud Kubernetes Service

You will need either a paid IBM Cloud account or an IBM Cloud account which is a Trial account (not a Lite account). If you have one of these accounts, use the [Getting Started Guide](https://cloud.ibm.com/docs/containers?topic=containers-getting-started) to create your cluster.

### Use a hosted trial environment

There are a few services that are accessible over the Internet for temporary use. As these are free services, they can sometimes experience periods of limited availablity/quality. On the other hand, they can be a quick way to get started!

* [Kubernetes playground on Katacoda](https://www.katacoda.com/courses/kubernetes/playground) This environment starts with a master and worker node pre-configured. You can run the steps from Labs 1 and onward from the master node.

* [Play with Kubernetes](https://labs.play-with-k8s.com/) After signing in with your github or docker hub id, click on **Start**, then **Add New Instance** and follow steps shown in terminal to spin up the cluster and add workers.

### Set up on your own workstation

If you would like to configure kubernetes to run on your local workstation for non-production, learning use, there are several options.

* [Minikube](https://kubernetes.io/docs/setup/learning-environment/minikube/) This solution requires the installation of a supported VM provider (KVM, VirtualBox, HyperKit, Hyper-V - depending on platform)

* [Kubernetes in Docker (kind)](https://kind.sigs.k8s.io/) Runs a kubernetes cluster on Docker containers

* [Docker Desktop (Mac)](https://docs.docker.com/docker-for-mac/kubernetes/) [Docker Desktop (Windows)](https://docs.docker.com/docker-for-windows/kubernetes/) Docker Desktop includes a kubernetes environment

* [Microk8s](https://microk8s.io/docs/) Installable kubernetes packaged as an Ubuntu `snap` image.

## Install the IBM Cloud command-line interface

1. As a prerequisite for the IBM Cloud Kubernetes Service plug-in, install the [IBM Cloud command-line interface](https://clis.ng.bluemix.net/ui/home.html). Once installed, you can access IBM Cloud from your command-line with the prefix `bx`.
2. Log in to the IBM Cloud CLI: `ibmcloud login`.
3. Enter your IBM Cloud credentials when prompted.

   **Note:** If you have a federated ID, use `ibmcloud login --sso` to log in to the IBM Cloud CLI. Enter your user name, and use the provided URL in your CLI output to retrieve your one-time passcode. You know you have a federated ID when the login fails without the `--sso` and succeeds with the `--sso` option.

## Install the IBM Cloud Kubernetes Service plug-in

1. To create Kubernetes clusters and manage worker nodes, install the IBM Cloud Kubernetes Service plug-in:

   ```bash
   ibmcloud plugin install container-service -r Bluemix
   ```

   **Note:** The prefix for running commands by using the IBM Cloud Kubernetes Service plug-in is `bx cs`.

2. To verify that the plug-in is installed properly, run the following command:

   ```bash
   ibmcloud plugin list
   ```

   The IBM Cloud Kubernetes Service plug-in is displayed in the results as `container-service`.

## Download the Kubernetes CLI

To view a local version of the Kubernetes dashboard and to deploy apps into your clusters, you will need to install the Kubernetes CLI that corresponds with your operating system:

* [OS X](https://storage.googleapis.com/kubernetes-release/release/v1.10.8/bin/darwin/amd64/kubectl)
* [Linux](https://storage.googleapis.com/kubernetes-release/release/v1.10.8/bin/linux/amd64/kubectl)
* [Windows](https://storage.googleapis.com/kubernetes-release/release/v1.10.8/bin/windows/amd64/kubectl.exe)

**For Windows users:** Install the Kubernetes CLI in the same directory as the IBM Cloud CLI. This setup saves you some filepath changes when you run commands later.

**For OS X and Linux users:**

1. Move the executable file to the `/usr/local/bin` directory using the command `mv /<path_to_file>/kubectl /usr/local/bin/kubectl` .

1. Make sure that `/usr/local/bin` is listed in your PATH system variable.

   ```shell
   $ echo $PATH
   /usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
   ```

1. Convert the binary file to an executable: `chmod +x /usr/local/bin/kubectl`

## Configure Kubectl to point to IBM Cloud Kubernetes Service

1. List the clusters in your account:

   ```shell
   ibmcloud ks clusters
   ```

1. Set an environment variable that will be used in subsequent commands in this lab.

   ```shell
   export CLUSTER_NAME=<your_cluster_name>
   ```

1. Configure `kubectl` to point to your cluster

   ```shell
   ibmcloud ks cluster config --cluster $CLUSTER_NAME
   ```

1. Validate proper configuration

   ```shell
   kubectl get namespace
   ```

1. You should see output similar to the following, if so, then your're ready to continue.

   ```shell
   NAME              STATUS   AGE
   default           Active   125m
   ibm-cert-store    Active   121m
   ibm-system        Active   124m
   kube-node-lease   Active   125m
   kube-public       Active   125m
   kube-system       Active   125m
   ```

## Download the Workshop Source Code

Repo `guestbook` has the application that we'll be deploying.
While we're not going to build it we will use the deployment configuration files from that repo.
Guestbook application has two versions v1 and v2 which we will use to demonstrate some rollout
functionality later. All the configuration files we use are under the directory guestbook/v1.

Repo `kube101` contains the step by step instructions to run the workshop.

```shell
git clone https://github.com/IBM/guestbook.git
git clone https://github.com/IBM/kube101.git
```
