# Lab 1. Set up and deploy your first application

Learn how to deploy an application to a Kubernetes cluster hosted within
the IBM Container Service.

# 0. Install Prerequisite CLIs and Provision a Kubernetes Cluster

If you haven't already:
1. Install the IBM Cloud CLIs and login, as described in [Lab 0](../Lab0/README.md).
2. Provision a cluster:

   ```$ bx cs cluster-create --name <name-of-cluster>```

Once the cluster is provisioned, the kubernetes client CLI `kubectl` needs to be
configured to talk to the provisioned cluster.

1. Run `$ bx cs cluster-config <name-of-cluster>`, and set the `KUBECONFIG`
   environment variable based on the output of the command. This will
   make your `kubectl` client point to your new Kubernetes cluster.
   
   (If you're running in a Windows PowerShell environment, the *SET* and/or *EXPORT* equivalent is
   `$env:KUBECONFIG="<value of KUBECONFIG filename>"`; after setting, confirm the value is in the shell environment with `ls env:KUBECONFIG`)

Once your client is configured, you are ready to deploy your first application, `guestbook`.

# 1. Deploy your application

In this part of the lab we will deploy an application called `guestbook`
that has already been built and uploaded to DockerHub under the name
`ibmcom/guestbook:v1`.

1. Start by running `guestbook`:

   ```$ kubectl run guestbook --image=ibmcom/guestbook:v1```

   This action will take a bit of time. To check the status of the running application,
   you can use `$ kubectl get pods`.

   You should see output similar to the following:

   ```console
   $ kubectl get pods
   NAME                          READY     STATUS              RESTARTS   AGE
   guestbook-59bd679fdc-bxdg7    0/1       ContainerCreating   0          1m
   ```
   Eventually, the status should show up as `Running`.

   ```console
   $ kubectl get pods
   NAME                          READY     STATUS              RESTARTS   AGE
   guestbook-59bd679fdc-bxdg7    1/1       Running             0          1m
   ```

   The end result of the run command is not just the pod containing our application containers,
   but a Deployment resource that manages the lifecycle of those pods.


3. Once the status reads `Running`, we need to expose that deployment as a
   service so we can access it through the IP of the worker nodes.
   The `guestbook` application listens on port 3000.  Run:

   ```console
   $ kubectl expose deployment guestbook --type="NodePort" --port=3000
   service "guestbook" exposed
   ```

4. To find the port used on that worker node, examine your new service:

   ```console
   $ kubectl get service guestbook
   NAME        TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
   guestbook   NodePort   10.10.10.253   <none>        3000:31208/TCP   1m
   ```

   We can see that our `<nodeport>` is `31208`. We can see in the output the port mapping from 3000 inside
   the pod exposed to the cluster on port 31208. This port in the 31000 range is automatically chosen,
   and could be different for you.

5. `guestbook` is now running on your cluster, and exposed to the internet. We need to find out where it is accessible.
   The worker nodes running in the container service get external IP addresses.
   Run `$ bx cs workers <name-of-cluster>`, and note the public IP listed on the `<public-IP>` line.

   ```console
   $ bx cs workers osscluster
   OK
   ID                                                 Public IP        Private IP     Machine Type   State    Status   Zone    Version  
   kube-hou02-pa1e3ee39f549640aebea69a444f51fe55-w1   173.193.99.136   10.76.194.30   free           normal   Ready    hou02   1.5.6_1500*
   ```

   We can see that our `<public-IP>` is `173.193.99.136`.

6. Now that you have both the address and the port, you can now access the application in the web browser
   at `<public-IP>:<nodeport>`. In the example case this is `173.193.99.136:31208`.

Congratulations, you've now deployed an application to Kubernetes!

When you're all done, you should move on to the
[Lab 2](../Lab2/README.md).

If you want to stop here and remove the deployment do the following:

  1. To remove the deployment, use `$ kubectl delete deployment guestbook`.

  2. To remove the service, use `$ kubectl delete service guestbook`.

