# *** UNDER CONSTRUCTION ***

# 1. Check the health of apps

Kubernetes uses availability checks (liveness probes) to know when to restart a container. For example, liveness probes could catch a deadlock, where an application is running, but unable to make progress. Restarting a container in such a state can help to make the application more available despite bugs.

Also, Kubernetes uses readiness checks to know when a container is ready to start accepting traffic. A pod is considered ready when all of its containers are ready. One use of this check is to control which pods are used as backends for services. When a pod is not ready, it is removed from load balancers.

In this example, we have defined a HTTP liveness probe to check health of the container every five seconds. For the first 10-15 seconds the `/healthz` returns a `200` response and will fail afterward. Kubernetes will automatically restart the service.  

1. Open the `healthcheck.yml` file with a text editor. This configuration script combines a few steps from the previous lesson to create a deployment and a service at the same time. App developers can use these scripts when updates are made or to troubleshoot issues by re-creating the pods:

   1. Update the details for the image in your private registry namespace:

      ```
      image: "ibmcom/guestbook:v2"
      ```

   2. Note the HTTP liveness probe that checks the health of the container every five seconds.

      ```
      livenessProbe:
                  httpGet:
                    path: /healthz
                    port: 3000
                  initialDelaySeconds: 5
                  periodSeconds: 5
      ```

   3. In the **Service** section, note the `NodePort`. Rather than generating a random NodePort like you did in the previous lesson, you can specify a port in the 30000 - 32767 range. This example uses 30072.

2. Run the configuration script in the cluster. When the deployment and the service are created, the app is available for anyone to see:

   ```
   kubectl apply -f healthcheck.yml
   ```
   
   Now that all the deployment work is done, check how everything turned out. You might notice that because more instances are running, things might run a bit slower.

3. Open a browser and check out the app. To form the URL, combine the IP with the NodePort that was specified in the configuration script. To get the public IP address for the worker node:

   ```
   ibmcloud cs workers <cluster-name>
   ```

   In a browser, you'll see a success message. If you do not see this text, don't worry. This app is designed to go up and down.

   For the first 10 - 15 seconds, a 200 message is returned, so you know that the app is running successfully. After those 15 seconds, a timeout message is displayed, as is designed in the app.

4. Launch your Kubernetes dashboard:

   1. Get your credentials for Kubernetes.
      
      ```
      kubectl config view -o jsonpath='{.users[0].user.auth-provider.config.id-token}'
      ```

   2. Copy the **id-token** value that is shown in the output.     
   
   3. Set the proxy with the default port number.

      ```
      kubectl proxy
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
  
   In the **Workloads** tab, you can see the resources that you created. From this tab, you can continually refresh and see that the health check is working. In the **Pods** section, you can see how many times the pods are restarted when the containers in them are re-created. You might happen to catch errors in the dashboard, indicating that the health check caught a problem. Give it a few minutes and refresh again. You see the number of restarts changes for each pod.

5. Ready to delete what you created before you continue? This time, you can use the same configuration script to delete both of the resources you created.

   ```kubectl delete -f healthcheck.yml```

6. When you are done exploring the Kubernetes dashboard, in your CLI, enter `CTRL+C` to exit the `proxy` command.
