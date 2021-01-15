# Lab 1. Deploy your first application

Learn how to deploy an application to a Kubernetes cluster hosted within
the IBM Container Service.

## 0. Prerequisites

Make sure you satisfy the prerequisites as outlined in [Lab 0](../Lab0/README.md)

   ```$ ibmcloud cs cluster-create --name <name-of-cluster>```

   If the above command doesn't work, please try the command below：

   ```$ ibmcloud cs cluster create classic --name <name-of-cluseter>```

Once the cluster is provisioned, the kubernetes client CLI `kubectl` needs to be
configured to talk to the provisioned cluster.

1. Run `$ ibmcloud cs cluster-config <name-of-cluster>`, and set the `KUBECONFIG`
   environment variable based on the output of the command. This will
   make your `kubectl` client point to your new Kubernetes cluster.

Once your client is configured, you are ready to deploy your first application, `guestbook`.

## 1. Deploy the guestbook application

In this part of the lab we will deploy an application called `guestbook`
that has already been built and uploaded to DockerHub under the name
`ibmcom/guestbook:v1`.

1. Start by running `guestbook`:

   ```shell
   kubectl create deployment guestbook --image=ibmcom/guestbook:v1
   ```

   This action will take a bit of time. To check the status of the running application,
   you can use `$ kubectl get pods`.

   You should see output similar to the following:

   ```shell
   kubectl get pods
   ```

   Eventually, the status should show up as `Running`.

   ```shell
   $ kubectl get pods
   NAME                          READY     STATUS              RESTARTS   AGE
   guestbook-59bd679fdc-bxdg7    1/1       Running             0          1m
   ```

   The end result of the run command is not just the pod containing our application containers,
   but a Deployment resource that manages the lifecycle of those pods.

1. Once the status reads `Running`, we need to expose that deployment as a
   service so we can access it through the IP of the worker nodes.
   The `guestbook` application listens on port 3000.  Run:

   ```shell
   kubectl expose deployment guestbook --type="NodePort" --port=3000
   ```

1. To find the port used on that worker node, examine your new service:

   ```shell
   $ kubectl get service guestbook
   NAME        TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
   guestbook   NodePort   10.10.10.253   <none>        3000:31208/TCP   1m
   ```

   We can see that our `<nodeport>` is `31208`. We can see in the output the port mapping from 3000 inside
   the pod exposed to the cluster on port 31208. This port in the 31000 range is automatically chosen,
   and could be different for you.

1. `guestbook` is now running on your cluster, and exposed to the internet. We need to find out where it is accessible.
   The worker nodes running in the container service get external IP addresses.
   Get the workers for your cluster and note one (any one) of the public IPs listed on the `<public-IP>` line. Replace `$CLUSTER_NAME` with your cluster name unless you have this environment variable set.

   ```shell
   $ kubectl get nodes -o wide
   NAME           STATUS   ROLES           AGE   VERSION           INTERNAL-IP    EXTERNAL-IP      OS-IMAGE   KERNEL-VERSION                CONTAINER-RUNTIME
   10.185.199.3   Ready    master,worker   63d   v1.16.2+283af84   10.185.199.3   169.59.228.215   Red Hat    3.10.0-1127.13.1.el7.x86_64   cri-o://1.16.6-17.rhaos4.3.git4936f44.el7
   10.185.199.6   Ready    master,worker   63d   v1.16.2+283af84   10.185.199.6   169.47.78.51     Red Hat    3.10.0-1127.13.1.el7.x86_64   cri-o://1.16.6-17.rhaos4.3.git4936f44.el7
   ```

   We can see that our `<public-IP>` is `173.193.99.136`.

1. Now that you have both the address and the port, you can now access the application in the web browser
   at `<public-IP>:<nodeport>`. In the example case this is `173.193.99.136:31208`.

Congratulations, you've now deployed an application to Kubernetes!

When you're all done, continue to the
[next lab of this course](../Lab2/README.md).
