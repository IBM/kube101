# Lab 1. Set up and deploy your first application

Learn how to push an image of an application to IBM Cloud Container Registry and deploy a basic application to a cluster.

# 0. Install Prerequisite CLIs and Provision a Kubernetes Cluster

If you haven't already:
1. Install the CLIs and Docker, as described in [Lab 0](../Lab0/README.md).
2. Provision a cluster: 

   ```bx cs cluster-create --name <name-of-cluster>```

# 1. Push an image to IBM Cloud Container Registry

To push an image, we first must have an image to push. We have
prepared several `Dockerfile`s in this repository that will create the
images. We will be running the images, and creating new ones, in the
later labs. 

This lab uses the Container Registry built in to IBM Cloud, but the
image can be created and uploaded to any standard Docker registry to
which your cluster has access.

1. Download a copy of this repository:

1a. [Clone or download](..) the GitHub repository associated with this course

2. Change directory to Lab 1: 

   ```cd Lab1```

3. Log in to the IBM Cloud CLI: 

   ```bx login```
   
   To specify an IBM Cloud region, include the API endpoint. <!-- what does this mean? can we add an example? -->

   **Note:** If you have a federated ID, use `bx login --sso` to log in to the IBM Cloud CLI. You know you have a federated ID when the login fails without the `--sso` and succeeds with the `--sso` option.

4. Run `bx cr login`, and log in with your IBM Cloud credentials. This will allow you to push images to the IBM Cloud Container Registry.

   **Tip:** This course's commands show the `ng` region. Replace `ng` with the region outputted from the `bx cr login` command.

5. In order to upload images to the IBM Cloud Container Registry, you first need to create a namespace with the following command: 

   ```bx cr namespace-add <my_namespace>```
   
6. Build the Docker image in this directory with a `1` tag:

   ```docker build --tag registry.ng.bluemix.net/<my_namespace>/hello-world:1 .```

7. Verify the image is built: 

   ```docker images```

8. Now push that image up to IBM Cloud Container Registry: 

   ```docker push registry.ng.bluemix.net/<my_namespace>/hello-world:1```

9. If you created your cluster at the beginning of this, make sure it's ready for use. 
   1. Run `bx cs clusters` and make sure that your cluster is in "Normal" state.  
   2. Use `bx cs workers <yourclustername>`, and make sure that all workers are in "Normal" state with "Ready" status.
   3. Make a note of the public IP of the worker.

You are now ready to use Kubernetes to deploy the hello-world application.

# 2. Deploy your application

1. Run `bx cs cluster-config <yourclustername>`, and set the variables based on the output of the command.

2. Start by running your image as a deployment: 

   ```kubectl run hello-world --image=registry.ng.bluemix.net/<my_namespace>/hello-world:1```

   This action will take a bit of time. To check the status of your deployment, you can use `kubectl get pods`.

   You should see output similar to the following:
   
   ```
   => kubectl get pods
   NAME                          READY     STATUS              RESTARTS   AGE
   hello-world-562211614-0g2kd   0/1       ContainerCreating   0          1m
   ```

3. Once the status reads `Running`, expose that deployment as a service, accessed through the IP of the worker nodes.  The example for this course listens on port 8080.  Run:

   ```kubectl expose deployment/hello-world --type="NodePort" --port=8080```

4. To find the port used on that worker node, examine your new service: 

   ```kubectl describe service <name-of-deployment>```

   Take note of the "NodePort:" line as `<nodeport>`

5. Run `bx cs workers <name-of-cluster>`, and note the public IP as `<public-IP>`.

6. You can now access your container/service using `curl <public-IP>:<nodeport>` (or your favorite web browser). If you see, "Hello world! Your app is up and running in a cluster!" you're done!

When you're all done, you can either use this deployment in the [next lab of this course](../Lab2/README.md), or you can remove the deployment and thus stop taking the course.

1. To remove the deployment, use `kubectl delete deployment hello-world`. 
2. To remove the service, use `kubectl delete service hello-world`.
