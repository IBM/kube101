# Lab 0: Get the IBM Cloud Container Service


Before you begin learning, you need to install the required CLIs to create and manage your Kubernetes clusters in IBM Cloud Container Service and to deploy containerized apps to your cluster.

Thankfully the new IBM Developer Tools install comes with the following required CLIs:

* IBM Cloud CLI
* IBM Cloud Container Service plug-in
* Kubernetes CLI
* GIT CLI

If you already have the CLIs and plug-ins, you can skip this lab and proceed to the next one.

# Install the IBM Cloud command-line interface

1. Install the [IBM Cloud command-line interface from this link](https://console.bluemix.net/docs/cli/index.html).  
**Note:** In step 3 - Configure your environment use eu-gb as IBM Cloud location, i.e. `https://api.eu-gb.bluemix.net`  
Once installed, you can access IBM Cloud from your command-line with the prefix `bx`.
2. Log in to the IBM Cloud CLI: `bx login`.
3. Enter your IBM Cloud credentials when prompted.

   **Note:** If you have a federated ID, use `bx login --sso` to log in to the IBM Cloud CLI. Enter your user name, and use the provided URL in your CLI output to retrieve your one-time passcode. You know you have a federated ID when the login fails without the `--sso` and succeeds with the `--sso` option.

Once you are all set up you can move straight on to [Lab 1](../Lab1/README.md)

