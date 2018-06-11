# Lab 2: Scale and update deployments on Kubernetes

In this lab, learn how to update the number of instances
that a deployment has and how you can safely roll out an update of your application
on Kubernetes. 

For this lab, you need a running deployment of the `guestbook` application
from the [previous lab](https://github.com/IBM/kube101/tree/master/workshop/Lab1). If you deleted it, you can recreate it by using:

```console
$ kubectl run guestbook --image=ibmcom/guestbook:v1
```
    
## 1. Scale apps with replicas

A *replica* is a copy of a pod that contains a running service. By having
multiple replicas of a pod, you can ensure your deployment has the available
resources to handle an increasing load on your application.

1. `kubectl` provides a `scale` subcommand to change the size of an
   existing deployment. Let's increase our capacity from a single running instance of
   `guestbook` up to 10 instances:

   ``` console
   $ kubectl scale --replicas=10 deployment guestbook
   deployment "guestbook" scaled
   ```

   Kubernetes will now try to make reality match the desired state of
   10 replicas by starting 9 new pods with the same configuration as
   the first.

1. To see your changes being rolled out, you can run:
   `kubectl rollout status deployment guestbook`.

   _Note: The rollout might occur quickly, so these messages might not display:_

   ```console
   $ kubectl rollout status deployment guestbook
   Waiting for rollout to finish: 1 of 10 updated replicas are available...
   Waiting for rollout to finish: 2 of 10 updated replicas are available...
   Waiting for rollout to finish: 3 of 10 updated replicas are available...
   Waiting for rollout to finish: 4 of 10 updated replicas are available...
   Waiting for rollout to finish: 5 of 10 updated replicas are available...
   Waiting for rollout to finish: 6 of 10 updated replicas are available...
   Waiting for rollout to finish: 7 of 10 updated replicas are available...
   Waiting for rollout to finish: 8 of 10 updated replicas are available...
   Waiting for rollout to finish: 9 of 10 updated replicas are available...
   deployment "guestbook" successfully rolled out
   ```

1. When the rollout finishes, ensure your pods are running by using:
   `kubectl get pods`.

   You should see an output that lists 10 replicas of your deployment, like this:

   ```console
   $ kubectl get pods
   NAME                        READY     STATUS    RESTARTS   AGE
   guestbook-562211614-1tqm7   1/1       Running   0          1d
   guestbook-562211614-1zqn4   1/1       Running   0          2m
   guestbook-562211614-5htdz   1/1       Running   0          2m
   guestbook-562211614-6h04h   1/1       Running   0          2m
   guestbook-562211614-ds9hb   1/1       Running   0          2m
   guestbook-562211614-nb5qp   1/1       Running   0          2m
   guestbook-562211614-vtfp2   1/1       Running   0          2m
   guestbook-562211614-vz5qw   1/1       Running   0          2m
   guestbook-562211614-zksw3   1/1       Running   0          2m
   guestbook-562211614-zsp0j   1/1       Running   0          2m
   ```

**Tip:** Another way to improve availability is to
[add clusters and regions](https://console.bluemix.net/docs/containers/cs_planning.html#cs_planning_cluster_config)
to your deployment, as shown in the following diagram:

![HA with more clusters and regions](../images/cluster_ha_roadmap.png)

## 2. Update and roll back apps

Kubernetes allows you to conduct a rolling upgrade of your application to a new
container image. This allows you to easily update the running image and
undo a rollout if you discover a problem during or after deployment.

In the previous lab, we used an image with a `v1` tag. For our upgrade,
we'll use the image with the `v2` tag.

Follow these steps to update and roll back your app:

1. Update your deployment to use the
   `v2` image. Use `kubectl`, which allows you to change details about existing
   resources with the `set` subcommand. We can use it to change the
   image being used.

    ```$ kubectl set image deployment/guestbook guestbook=ibmcom/guestbook:v2```

   Note that a pod can have multiple containers, each with its own name.
   Each image can be changed individually or all at once by referring to the name.
   In the case of our `guestbook` deployment, the container name is also `guestbook`.
   You can also update multiple containers simultaneously. Read the [Kubernetes guide
   on how to update multiple containers](https://kubernetes.io/docs/user-guide/kubectl/kubectl_set_image/).

1. Run `kubectl rollout status deployment/guestbook` to check the status of
   the rollout. The rollout might occur so quickly that the following messages
   might _not_ display:

   ```console
   $ kubectl rollout status deployment/guestbook
   Waiting for rollout to finish: 2 out of 10 new replicas have been updated...
   Waiting for rollout to finish: 3 out of 10 new replicas have been updated...
   Waiting for rollout to finish: 3 out of 10 new replicas have been updated...
   Waiting for rollout to finish: 3 out of 10 new replicas have been updated...
   Waiting for rollout to finish: 4 out of 10 new replicas have been updated...
   Waiting for rollout to finish: 4 out of 10 new replicas have been updated...
   Waiting for rollout to finish: 4 out of 10 new replicas have been updated...
   Waiting for rollout to finish: 4 out of 10 new replicas have been updated...
   Waiting for rollout to finish: 4 out of 10 new replicas have been updated...
   Waiting for rollout to finish: 5 out of 10 new replicas have been updated...
   Waiting for rollout to finish: 5 out of 10 new replicas have been updated...
   Waiting for rollout to finish: 5 out of 10 new replicas have been updated...
   Waiting for rollout to finish: 6 out of 10 new replicas have been updated...
   Waiting for rollout to finish: 6 out of 10 new replicas have been updated...
   Waiting for rollout to finish: 6 out of 10 new replicas have been updated...
   Waiting for rollout to finish: 7 out of 10 new replicas have been updated...
   Waiting for rollout to finish: 7 out of 10 new replicas have been updated...
   Waiting for rollout to finish: 7 out of 10 new replicas have been updated...
   Waiting for rollout to finish: 7 out of 10 new replicas have been updated...
   Waiting for rollout to finish: 8 out of 10 new replicas have been updated...
   Waiting for rollout to finish: 8 out of 10 new replicas have been updated...
   Waiting for rollout to finish: 8 out of 10 new replicas have been updated...
   Waiting for rollout to finish: 8 out of 10 new replicas have been updated...
   Waiting for rollout to finish: 9 out of 10 new replicas have been updated...
   Waiting for rollout to finish: 9 out of 10 new replicas have been updated...
   Waiting for rollout to finish: 9 out of 10 new replicas have been updated...
   Waiting for rollout to finish: 1 old replicas are pending termination...
   Waiting for rollout to finish: 1 old replicas are pending termination...
   Waiting for rollout to finish: 1 old replicas are pending termination...
   Waiting for rollout to finish: 9 of 10 updated replicas are available...
   Waiting for rollout to finish: 9 of 10 updated replicas are available...
   Waiting for rollout to finish: 9 of 10 updated replicas are available...
   deployment "guestbook" successfully rolled out
   ```

1. Test the application as before, by accessing `<public-IP>:<nodeport>` 
   in the browser to confirm your new code is active.

   Remember, to get the "nodeport" and "public-ip" use:

   `$ kubectl describe service guestbook`
   and
   `$ bx cs workers <name-of-cluster>`

   To verify that you're running "v2" of guestbook, look at the title of the page,
   it should now be `Guestbook - v2`

1. If you want to undo your latest rollout, use:
   ```console
   $ kubectl rollout undo deployment guestbook
   deployment "guestbook"
   ```

   You can then use `kubectl rollout status deployment/guestbook` to see
   the status.
   
1. When doing a rollout, you see references to *old* replicas and *new* replicas.
   The *old* replicas are the original 10 pods deployed when we scaled the application.
   The *new* replicas come from the newly created pods with the different image.
   All of these pods are owned by the Deployment.
   The deployment manages these two sets of pods with a resource called a ReplicaSet.
   We can see the guestbook ReplicaSets with:
   ```console
   $ kubectl get replicasets -l run=guestbook
   NAME                   DESIRED   CURRENT   READY     AGE
   guestbook-5f5548d4f    10        10        10        21m
   guestbook-768cc55c78   0         0         0         3h
   ```
Congratulations! You deployed the second version of the app. Lab 2
is now complete.

Before we continue to the next lab, delete the application. Don't worry, you'll
learn about a different way to deploy the same guestbook application:

 To remove the deployment, use `kubectl delete deployment guestbook`.

 To remove the service, use `kubectl delete service guestbook`.
