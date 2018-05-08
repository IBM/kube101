# Lab 2: Scale and update apps -- services and health checks

In this lab, you'll learn how to update the number of instances (or "replicas")
a deployment has and how to safely roll out an update of your application
on Kubernetes. You'll also learn, how to perform a simple health check.

For this lab, you need a running deployment of the `guestbook` application
from the previous lab. If you deleted it, recreate it using:
    ```
    $ kubectl run guestbook --image=ibmcom/guestbook:v1
    ```

First, let's change into the `Lab2` directory: `cd Lab`.

# 1. Scale apps with replicas

A *replica* is a copy of a pod that contains a running service. By having
multiple replicas of a pod, you can ensure your deployment has the available
resources to handle increasing load on your application.

1. `kubectl` provides a `scale` subcommand to change the size of an
   existing deployment. Let's change our single running instance of
   `guestbook` up to 10 instances:

   ``` console
   $ kubectl scale --replicas=10 deployment guestbook
   deployment "guestbook" scaled
   ```

   Kubernetes will now try to make reality match the desired state of
   10 replicas by starting 9 new pods with the same configuration as
   the first.

4. To see your changes being rolled out, you can run:
   `kubectl rollout status deployment/guestbook`.

   The rollout might occur so quickly that the following messages might
   _not_ display:

   ```
   $ kubectl rollout status deployment/guestbook
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

5. Once the rollout has finished, ensure your pods are running by using:
   `kubectl get pods`.

   You should see output listing 10 replicas of your deployment:

   ```
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

# 2. Update and roll back apps

Kubernetes allows you to do rolling upgrade of your application to a new
Docker image. This means that it will go through each of your application's
pods, one at a time, and replace the pod with a new pod running the new image.
This allows you to easily update the running image and also allows you to
easily undo a rollout, if a problem is discovered during or after deployment.

In the previous lab, we used an image with a `v1` tag. For our upgrade
we'll use the image with the `v2` tag.

To update and roll back:
1. Using `kubectl`, you can now update your deployment to use the
   `v2` image. `kubectl` allows you to change details about existing
   resources with the `set` subcommand. We can use it to change the
   image being used.

    ```$ kubectl set image deployment/guestbook guestbook=ibmcom/guestbook:v2```

   Note that a pod could have multiple containers, in which case each
   container will have its own name.  Multiple containers can be updated at
   the same time.
   ([More information](https://kubernetes.io/docs/user-guide/kubectl/kubectl_set_image/).)

3. Run `kubectl rollout status deployment/guestbook` to check the status of
   the rollout. The rollout might occur so quickly that the following messages
   might _not_ display:

   ```
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

4. Now perform a `curl <public-IP>:<nodeport>` to confirm your new code is
   active.

   Remember, to get the "nodeport" and "public-ip" use:

   `$ kubectl describe service guestbook`
   and
   `$ bx cs workers <name-of-cluster>`

   To verify that you're running "v2" of guestbook, look for the
   HTML "title" element: `<title>Guestbook - v2</title>` near the top
   of the output.

5. If you want to undo your latest rollout, use:
   `$ kubectl rollout undo deployment/guestbook`.

   You can then use `kubectl rollout status deployment/guestbook` to see
   the status.

Before we continue, let's delete the application so we can learn about
a different way to achieve the same results:

 To remove the deployment, use `kubectl delete deployment guestbook`.

 To remove the service, use `kubectl delete service guestbook`.

# 3. Check the health of apps

Kubernetes uses availability checks (liveness probes) to know when to restart
a container. For example, liveness probes could catch a deadlock, where an
application is running, but unable to make progress. Restarting a container in
such a state can help to make the application more available despite bugs.

Also, Kubernetes uses readiness checks to know when a container is ready to
start accepting traffic. A pod is considered ready when all of its containers
are ready. One use of this check is to control which pods are used as backends
for services. When a pod is not ready, it is removed from load balancers.

In this example, we have defined a HTTP liveness probe to check health of the
container every five seconds. For the first 10-15 seconds the `/healthz`
endpoint will return a `200` response and will fail afterward. Upon detecting
this, Kubernetes will automatically restart the service.

In the previous sections we deployed our applications using helper
utilities provided to us via the `kubectl` cli tool.  For example,
`kubectl run` will create a new Deployment resource for us automatically
so we don't need to be concerned with all of the details normally
associated with those that resource. This is nice, however, is it limiting
since it only allows us to modify a subset of the full set of configuration
settings associated with Deployments.

In order to use more advanced features, such as liveness probes, we'll
need to switch from using the `kubectl` utilities and instead specify
the full descriptions of the resources we want to create in a more
programmatic way.

In Lab3 we'll dive more into these configuration files and the structure
of Kubernetes resources, but for now we'll just focus on the availability
checking aspects of it.

1. Open the `healthcheck.yml` file with a text editor. This configuration
   file defines two resources, a Deployment and a Service within the same
   file. When we as Kubernetes to process this file it will create both
   resources for us at the same time.

   1. Notice tht the `image:` line references `ibmcom/guestbook:v2`. That
      tells Kubernetes to create a container with that image.

   2. Note the HTTP liveness probe that checks the health of the container
      (at the `/healthz` endpoint) every five seconds, after waiting 5 seconds.

      ```
          livenessProbe:
            httpGet:
              path: /healthz
              port: 3000
            initialDelaySeconds: 5
            periodSeconds: 5
      ```

   3. In the **Service** section, note the `NodePort`. Rather than generating
      a random NodePort like you did in the previous section, you can specify
      a port in the 30000 - 32767 range. This example uses 30072.

2. Run the configuration script in the cluster. When the Deployment and the
   Service are created, the app is available for anyone to see:

   ```
   $ kubectl apply -f healthcheck.yml
   ```

   Now that all the deployment work is done, check how everything turned out.
   You can do this using the same `curl` command as before but use port
   `30072` instead this time.
   You might notice that because more instances are running, things might run
   a bit slower.

3. Launch your Kubernetes dashboard:

   1. Get your credentials for Kubernetes.

      ```
      $ kubectl config view -o jsonpath='{.users[0].user.auth-provider.config.id-token}'
      ```

   2. Copy the **id-token** value that is shown in the output.

   3. Set the proxy with the default port number.

      ```
      $ kubectl proxy
      ```

      Output:

      ```
      Starting to serve on 127.0.0.1:8001
      ```

   4. Sign in to the dashboard.

      1. Open the following URL in a web browser.

         ```
         http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
         ```

      2. In the sign-on page, select the **Token** authentication method.

      3. Then, paste the **id-token** value that you previously copied into the **Token** field and click **SIGN IN**.

   In the **Workloads** tab, you can see the resources that you created.
   From this tab, you can continually refresh and see that the health check is
   working. In the **Pods** section, you can see how many times the pods are
   restarted when the containers in them are re-created. You might happen to
   catch errors in the dashboard, indicating that the health check caught a
   problem. Give it a few minutes and refresh again. You see the number of
   restarts changes for each pod.

4. Ready to delete what you created before you continue? This time, you can
   use the same configuration script to delete both of the resources you
   created.

   ```$ kubectl delete -f healthcheck.yml```

5. When you are done exploring the Kubernetes dashboard, in your CLI, enter
   `CTRL-C` to exit the `proxy` command.


Congratulations! You deployed the second version of the app. You had to use
fewer commands, learned how health check works, and edited a deployment,
which is great! Lab 2 is now complete.
