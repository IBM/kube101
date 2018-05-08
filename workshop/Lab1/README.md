# Lab 1. Set up and deploy your first application

Learn how to deploy an application to a Kubernetes cluster hosted within
the IBM Container Service.

# 0. Install Prerequisite CLIs and Provision a Kubernetes Cluster

If you haven't already:
1. Install the IBM Cloud CLIs and login, as described in [Lab 0](../Lab0/README.md).
2. Provision a cluster:

   ```$ bx cs cluster-create --name <name-of-cluster>```

# 1. Push an image to IBM Cloud Container Registry

1. Download a copy of this repository:

   ```$ git clone https://github.com/IBM/kube101```

2. Change directory to Lab 1:

   ```$ cd Lab1```

3. Verify that your Kubernetes cluster is ready for use

   1. Run `$ bx cs clusters` and wait until your cluster is in "normal" state.
   2. Use `$ bx cs workers <name-of-cluster>`, and make sure that all workers
      are in "normal" state with "Ready" status.

You are now ready to use Kubernetes to deploy an application, in this case
the "guestbook" application.

# 2. Deploy your application

In this part of the lab we will deploy an application called `guestbook`
that has already been built and uploaded to DockerHub under the name
`ibmcom/guestbook:v1`.

1. Run `$ bx cs cluster-config <name-of-cluster>`, and set the `KUBECONFIG`
   environment variable based on the output of the command. This will
   make your `kubectl` client point to your new Kubernetes cluster.

2. Start by running `guestbook` as a deployment:

   ```$ kubectl run guestbook --image=ibmcom/guestbook:v1```

   This action will take a bit of time. To check the status of your deployment,
   you can use `$ kubectl get pods`.

   You should see output similar to the following:

   ```
   $ kubectl get pods
   NAME                          READY     STATUS              RESTARTS   AGE
   guestbook-59bd679fdc-bxdg7    0/1       ContainerCreating   0          1m
   ```

3. Once the status reads `Running`, we need to expose that deployment as a
   service so we can access it through the IP of the worker nodes.
   The example for this course listens on port 8080.  Run:

   ```$ kubectl expose deployment/guestbook --type="NodePort" --port=3000```

4. To find the port used on that worker node, examine your new service:

   ```$ kubectl describe service guestbook```

   Take note of the "NodePort:" line as `<nodeport>`

5. Run `$ bx cs workers <name-of-cluster>`, and note the public IP listed
   on the `<public-IP>` line.

6. You can now access the application using
   `$ curl <public-IP>:<nodeport>` (or use your favorite web browser).
   You should see the HTML output from the guestbook application.

Congratulations, you've now deployed an application to Kubernetes!

When you're all done, you can either use this deployment in the
[next lab of this course](../Lab2/README.md), or you can remove the deployment
and thus stop taking the course.

  1. To remove the deployment, use `$ kubectl delete deployment guestbook`.

  2. To remove the service, use `$ kubectl delete service guestbook`.

You should now go back up to the root of the repository in preparation
for the next lab: `$ cd ..`.
