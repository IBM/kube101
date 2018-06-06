# Lab 0: Prequisites

## What you'll need before starting Lab 1:
1. An IBM Cloud account. [Get your free account here](https://console.bluemix.net/dashboard/apps/).
2. A basic understanding of Linux.

## Get the IBM Cloud Kubernetes Service
Before you begin the Kube101 labs, you will need to install the required CLIs to create and manage your Kubernetes clusters in the IBM Cloud Kubernetes Service and to deploy containerized apps to your cluster.

Lab 0 includes the information for installing the following CLIs and plug-ins:

* IBM Cloud CLI, Version 0.5.0 or later
* IBM Cloud Kubernetes Service plug-in
* Kubernetes CLI, Version 1.7.4 or later

If you already have the CLIs and plug-ins, you can skip this lab and proceed to the next one.

## Install the IBM Cloud command-line interface

1. As a prerequisite for the IBM Cloud Container Service plug-in, install the [IBM Cloud command-line interface](https://clis.ng.bluemix.net/ui/home.html). Once installed, you can access IBM Cloud from your command-line with the prefix `bx`.
2. Log in to the IBM Cloud CLI: `bx login`. 
3. Enter your IBM Cloud credentials when prompted.

   **Note:** If you have a federated ID, use `bx login --sso` to log in to the IBM Cloud CLI. Enter your user name, and use the provided URL in your CLI output to retrieve your one-time passcode. You know you have a federated ID when the login fails without the `--sso` and succeeds with the `--sso` option.

## Install the IBM Cloud Kubernetes Service plug-in
1. To create Kubernetes clusters and manage worker nodes, install the IBM Cloud Kubernetes Service plug-in:
   ```bx plugin install container-service -r Bluemix```
   
   **Note:** The prefix for running commands by using the IBM Cloud Kubernetes Service plug-in is `bx cs`.

2. To verify that the plug-in is installed properly, run the following command:
```bx plugin list```

   The IBM Cloud Kubernetes Service plug-in is displayed in the results as `container-service`.

## Download the Kubernetes CLI

To view a local version of the Kubernetes dashboard and to deploy apps into your clusters, you will need to install the Kubernetes CLI that corresponds with your operating system:

* [OS X](https://storage.googleapis.com/kubernetes-release/release/v1.7.4/bin/darwin/amd64/kubectl)
* [Linux](https://storage.googleapis.com/kubernetes-release/release/v1.7.4/bin/linux/amd64/kubectl)
* [Windows](https://storage.googleapis.com/kubernetes-release/release/v1.7.4/bin/windows/amd64/kubectl.exe)

**For Windows users:** Install the Kubernetes CLI in the same directory as the IBM Cloud CLI. This setup saves you some filepath changes when you run commands later.

**For OS X and Linux users:** You will need to do the following:

1. Move the executable file to the `/usr/local/bin` directory using the command `mv /<path_to_file>/kubectl /usr/local/bin/kubectl` .

2. Make sure that `/usr/local/bin` is listed in your PATH system variable.
```
$echo $PATH
/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
```

3. Convert the binary file to an executable: `chmod +x /usr/local/bin/kubectl`

## Download the workshop source code

The [`guestbook`](https://github.com/IBM/guestbook) repo contains the application that we'll be deploying. 
While we're not going to build it as part of these labs, we will use the deployment configuration files from that repo. 
The guestbook application has two versions, v1 and v2, which we will use to demonstrate some rollout 
functionality later. All the configuration files we use are under the directory guestbook/v1.

The [`kube101`](https://github.com/IBM/kube101/) contains the step-by-step instructions to run the workshop.

```console
$ git clone https://github.com/IBM/guestbook.git
$ git clone https://github.com/IBM/kube101.git
```
