# Lab 1. Set up and deploy your first application

Learn how to deploy an application to a Kubernetes cluster hosted within
the IBM Cloud Kubernetes Service.

## 1. Install the prerequisite CLIs and provision a Kubernetes cluster

If you haven't already:
1. Install the IBM Cloud CLIs and log in, as described in [Lab 0](../Lab0/README.md).
2. Provision a cluster:

   ```$ bx cs cluster-create --name <name-of-cluster>```

   Once the cluster is provisioned, you need to configure the Kubernetes client CLI `kubectl`.
   
3. Run `$ bx cs cluster-config <name-of-cluster>` and set the `KUBECONFIG`
   environment variable that is based on the output of the command. This will
   make your `kubectl` client point to your new Kubernetes cluster.

   Once your client is configured, you are ready to deploy your first application, `guestbook`.

## 2. Deploy your application

In this part of the lab, we deploy an application called `guestbook`
that was built and uploaded to DockerHub under the name
`ibmcom/guestbook:v1`.

1. Run `guestbook`by running the command:

   ```$ kubectl run guestbook --image=ibmcom/guestbook:v1```

   This action will take a bit of time. To check the status of the running application,
   you can use `$ kubectl get pods`.

   Once complete, you should see an output similar to:

   ```console
   $ kubectl get pods
   NAME                          READY     STATUS              RESTARTS   AGE
   guestbook-59bd679fdc-bxdg7    0/1       ContainerCreating   0          1m
   ```
   Eventually, the status will display as `Running`.
   
   ```console
   $ kubectl get pods
   NAME                          READY     STATUS              RESTARTS   AGE
   guestbook-59bd679fdc-bxdg7    1/1       Running             0          1m
   ```
   
   The end result of the run command is not just the pod containing our application containers,
   but a deployment resource that manages the lifecycle of those pods.
 
   
3. Once the status is `Running`, we need to expose that deployment as a
   service so that we can access it through the IP of the worker nodes.
   The `guestbook` application listens on port 3000.  Run:

   ```console
   $ kubectl expose deployment guestbook --type="NodePort" --port=3000
   service "guestbook" exposed
   ```

4. To find the port that was used on that worker node, examine your new service:

   ```console
   $ kubectl get service guestbook
   NAME        TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
   guestbook   NodePort   10.10.10.253   <none>        3000:31208/TCP   1m
   ```
   
   Our `<nodeport>` is `31208`. We can see in the output that the port mapping from 3000 inside 
   the pod exposed it to the cluster on port 31208. This port in the 31000 range is automated 
   and may be different for you.

5. `guestbook` is now running on your cluster and exposed to the Internet. 
   We need to find out where it is accessible.
   The worker nodes that are running in the container service get external IP addresses.
   Run `$ bx cs workers <name-of-cluster>`, and note the public IP listed on the `<public-IP>` line.
   
   ```console
   $ bx cs workers osscluster
   OK
   ID                                                 Public IP        Private IP     Machine Type   State    Status   Zone    Version  
   kube-hou02-pa1e3ee39f549640aebea69a444f51fe55-w1   173.193.99.136   10.76.194.30   free           normal   Ready    hou02   1.5.6_1500*
   ```
   
   Our `<public-IP>` is `173.193.99.136`.
   
6. Now that you have both the address and the port, you can access the application in the web browser
   at `<public-IP>:<nodeport>`. In the example, this is `173.193.99.136:31208`.
   
Congratulations, you've now deployed an application to Kubernetes!

When you're all done, you can either use this deployment in the
[next lab of this course](../Lab2/README.md), or you can remove the deployment
and stop the course.

  1. To remove the deployment, use `$ kubectl delete deployment guestbook`.

  2. To remove the service, use `$ kubectl delete service guestbook`.

If you decide to continue with the course, go back up to the root of the repository in preparation
for the next [Lab 2](../Lab2/README.md), by running: `$ cd ..`.
