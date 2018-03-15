# Lab 3: Deploy an application with IBM Watson services

In this lab, set up an application to leverage the Watson Tone Analyzer service. If you have yet to create a cluster, please refer to first lab of this course.

# 1. Build the Watson images

1. Log in to IBM Cloud Container Registry.

   ```bx cr login```

2. Build the `watson` image.

   ```docker build -t registry.ng.bluemix.net/<namespace>/watson ./watson```

3. Push the `watson` image to IBM Cloud Container Registry.

   ```docker push registry.ng.bluemix.net/<namespace>/watson```

   **Tip:** If you run out of registry space, clean up the previous lab's images with this example command: 
      ```bx cr image-rm registry.ng.bluemix.net/<namespace>/hello-world:2```

4. Build the `watson-talk` image.

   ```docker build -t registry.ng.bluemix.net/<namespace>/watson-talk ./watson-talk```

5. Push the `watson-talk` image to IBM Cloud Container Registry.

   ```docker push registry.ng.bluemix.net/<namespace>/watson-talk```

6. In watson-deployment.yml, update the image tag with the registry path to the image you created in the following two sections.

   ```yml
       spec:
         containers:
           - name: watson
             image: "registry.ng.bluemix.net/<namespace>/watson" 
             # change to the path of the watson image you just pushed
             # ex: image: "registry.ng.bluemix.net/<namespace>/watson"
   ...
       spec:
         containers:
           - name: watson-talk
             image: "registry.ng.bluemix.net/<namespace>/watson-talk" 
             # change to the path of the watson-talk image you just pushed
             # ex: image: "registry.ng.bluemix.net/<namespace>/watson-talk"
   ```


# 2. Create an instance of the IBM Watson service via the CLI

In order to begin using the Watson Tone Analyzer (the IBM Cloud service for this application), you must first request an instance of the Watson service in the org and space where you have set up our cluster.

1. If you need to check what space and org you are currently using, simply run `bx login`. Then use `bx target --cf` to select the space and org you were using for the previous labs.

2. Once you have set your space and org, run `bx cf create-service tone_analyzer standard tone`, where `tone` is the name you will use for the Watson Tone Analyzer service.

   **Note:** When you add the Tone Analyzer service to your account, a message is displayed that the service is not free. If you [limit your API calls](https://www.ibm.com/watson/developercloud/tone-analyzer.html#pricing-block), this course does not incur charges from the Watson service.

3. Run `bx cf services` to ensure a service named `tone` was created.

# 3. Bind the Watson service to your cluster

1. Run `bx cs cluster-service-bind <name-of-cluster> default tone` to bind the service to your cluster. This command will create a secret for the service.

2. Verify the secret was created by running `kubectl get secrets`.

# 4. Create pods and services

Now that the service is bound to the cluster, you want to expose the secret to your pod so that it can utilize the service. To do this, create a secret datastore as a part of your deployment configuration. This has been done for you in watson-deployment.yml:

```yml
    volumeMounts:
            - mountPath: /opt/service-bind
              name: service-bind-volume
      volumes:
        - name: service-bind-volume
          secret:
            defaultMode: 420
            secretName: binding-tone
            # from the kubectl get secrets command above
```

1. Build the application using the yaml.

   ```kubectl create -f watson-deployment.yml```

2. Verify the pod has been created:

   ```kubectl get pods```

Your secret has now been created. Note that for this lab, this has been done for you.

# 5. Putting it all together - Run the application and service

By this time you have created pods, services, and volumes for this lab.

1. You can open the Kubernetes dashboard and explore all the new objects created or use the following commands.

   ```
   kubectl get pods
   kubectl get deployments
   kubectl get services
   ```

2. Get the public IP for the worker node to access the application:

   ```bx cs workers <name-of-cluster>```

3. Now that the you have the container IP and port, go to your favorite web browser and launch the following URL to analyze the text and see output.
 
   ```http://<public-IP>:30080/analyze/"Today is a beautiful day"```

If you can see JSON output on your screen, congratulations! You are done with this lab!
