# Lab 5: Set up advance security with IBM Cloud Container Service

In this lab, get an introduction to Kubernetes-specific security features that are used to limit the attack surface and harden your cluster against network threats. You can use built-in security features for risk analysis and security protection. These features help you protect your cluster infrastructure and network communication, isolate your compute resources, and ensure security compliance across your infrastructure components and container deployments.

# 1. Add network policies
In most cases, the default policies do not need to be changed. Only advanced security scenarios might require changes. If you find that you must make changes, install the Calico CLI and create your own network policies.

Before you begin:

Target the Kubernetes CLI to the cluster. Include the `--admin` option with the `bx cs cluster-config` command, which is used to download the certificates and permission files. This download also includes the keys for the Administrator RBAC role, which you need to run Calico commands.

```bx cs cluster-config <cluster_name> --admin```

**Note:** Calico CLI, Version 1.6.1, is supported.

To add network policies:

1. Install the [Calico CLI](https://github.com/projectcalico/calicoctl/releases/tag/v1.6.1).

   **Tip:** If you are using Windows, install the Calico CLI in the same directory as the IBM Cloud CLI. This setup saves you some filepath changes when you run commands later.

2. For OS X and Linux users, move the executable file to the /usr/local/bin directory:
   - Linux:

      ```mv /<path_to_file>/calicoctl /usr/local/bin/calicoctl```
   
   - OS X:
   
      ```mv /<path_to_file>/calico-darwin-amd64 /usr/local/bin/calicoctl```


3. Convert the binary file to an executable:

   ```chmod +x /usr/local/bin/calicoctl```

4. Verify that the Calico commands run properly by checking the Calico CLI client version:
   
   ```calicoctl version```


# 2. Configure the Calico CLI

1. For OS X and Linux, create the /etc/calico directory:

   ```mkdir -p /etc/calico/```

   For Windows, any directory can be used.

2. Create a calicoctl.cfg file.

   OS X and Linux:

      ```sudo vi /etc/calico/calicoctl.cfg```

   Windows: Create the file with a text editor.

3. Enter the following information in the calicoctl.cfg file:

   ```
   apiVersion: v1
   kind: calicoApiConfig
   metadata:
   spec:
     etcdEndpoints: <ETCD_URL>
     etcdKeyFile: <CERTS_DIR>/admin-key.pem
     etcdCertFile: <CERTS_DIR>/admin.pem
     etcdCACertFile: <CERTS_DIR>/<ca-*pem_file>
   ```

4. Retrieve the <ETCD_URL>.

   OS X and Linux:

      ```kubectl get cm -n kube-system calico-config -o yaml | grep "etcd_endpoints:" | awk '{ print $2 }'```
      
   Output example: 
   
      ```https://169.1.1.1:30001```

   Windows:
   1. Get the calico configuration values from the config map:
   
      ```kubectl get cm -n kube-system calico-config -o yaml```

   2. In the data section, locate the etcd_endpoints value. Example: https://169.1.1.1:30001.
   
5. Retrieve the <CERTS_DIR>, the directory that the Kubernetes certificates are downloaded in.

   OS X and Linux:

      ```dirname $KUBECONFIG```

   Output example:

      ```/home/sysadmin/.bluemix/plugins/container-service/clusters/<cluster_name>-admin/```

   Windows:

      ```echo %KUBECONFIG%```

   Output example:

      ```C:/Users/<user>/.bluemix/plugins/container-service/<cluster_name>-admin/kube-config-prod-<location>-<cluster_name>.yml```

   **Note:** To get the directory path, remove the file name kube-config-prod-<location>-<cluster_name>.yml from the end of the output.

6. Retrieve the ca-*pem_file.

   OS X and Linux:

      ```
      ls `dirname $KUBECONFIG` | grep ca-*.pem
      ```
   Windows:

   1. Open the directory you retrieved in the last step.

      ```C:\Users\.bluemix\plugins\container-service\<cluster_name>-admin\```

   2. Locate the ca-*pem_file file.

7. Verify that the Calico configuration is working correctly.

   OS X and Linux:

      ```calicoctl get nodes```

   Windows:

      ```calicoctl get nodes --config=<path_to_>/calicoctl.cfg```

   Output:
      ```
      NAME
      kube-dal10-crc21191ee3997497ca90c8173bbdaf560-w1.cloud.ibm
      kube-dal10-crc21191ee3997497ca90c8173bbdaf560-w2.cloud.ibm
      kube-dal10-crc21191ee3997497ca90c8173bbdaf560-w3.cloud.ibm
      ```

8. Examine the existing network policies.

9. View the Calico host endpoint:

   ```calicoctl get hostendpoint -o yaml```

10. View all of the Calico and Kubernetes network policies that were created for the cluster. This list includes policies that might not be applied to any pods or hosts yet. For a network policy to be enforced, it must find a Kubernetes resource that matches the selector that was defined in the Calico network policy.

   ```calicoctl get policy -o wide```

11. View details for a network policy:
   
   ```calicoctl get policy -o yaml <policy_name>```

12. View the details of all network policies for the cluster:

   ```calicoctl get policy -o yaml```

# 3. Define a Calico network policy

Defining a Calico network policy for Kubernetes clusters is simple once the Calico CLI is installed. In this part of the lab, walk through using the Calico APIs directly in conjunction with Kubernetes `NetworkPolicy` in order to define more complex network policies.

1. Begin by creating a namespace in your Kubernetes cluster:

   ```kubectl create ns advanced-policy-demo```

2. Enable isolation on the namespace:

   ```kubectl annotate ns advanced-policy-demo "net.beta.kubernetes.io/network-policy={\"ingress\":{\"isolation\":\"DefaultDeny\"}}"```

3. Run an nginx service in the namespace that you created:

   ```kubectl run --namespace=advanced-policy-demo nginx --replicas=2 --image=nginx```
   ```kubectl expose --namespace=advanced-policy-demo deployment nginx --port=80```

Now that you’ve created a namespace and a set of pods, you should see those objects show up in the Calico API using `calicoctl`.

You can see that the namespace has a corresponding network profile.

`calicoctl get profile -o wide`

```
NAME                          TAGS
k8s_ns.advanced-policy-demo   k8s_ns.advanced-policy-demo
k8s_ns.default                k8s_ns.default
k8s_ns.kube-system            k8s_ns.kube-system
```

Because you’ve enabled isolation on the namespace, the profile denies all ingress traffic and allows all egress traffic. Inspect the YAML file to verify.

`calicoctl get profile k8s_ns.advanced-policy-demo -o yaml`

```
- apiVersion: v1
  kind: profile
  metadata:
    name: k8s_ns.advanced-policy-demo
    tags:
    - k8s_ns.advanced-policy-demo
  spec:
    egress:
    - action: allow
      destination: {}
      source: {}
    ingress:
    - action: deny
      destination: {}
      source: {}
```
You can see that this is the case by running another pod in the namespace and attempting to access the nginx service.

```
$ kubectl run --namespace=advanced-policy-demo access --rm -ti --image busybox /bin/sh
Waiting for pod advanced-policy-demo/access-472357175-y0m47 to be running, status is Pending, pod ready: false
If you don't see a command prompt, try pressing enter.
/ # wget -q --timeout=5 nginx -O -
wget: download timed out
/ #
```

You can also see that the two nginx pods are represented as WorkloadEndpoints in the Calico API.

```
calicoctl get workloadendpoint

NODE          ORCHESTRATOR   WORKLOAD                                     NAME
k8s-node-01   k8s            advanced-policy-demo.nginx-701339712-x1uqe   eth0
k8s-node-02   k8s            advanced-policy-demo.nginx-701339712-xeeay   eth0
k8s-node-01   k8s            kube-system.kube-dns-v19-mjd8x               eth0
```

Taking a closer look, you can see that they reference the correct profile for the namespace, and that the correct label information has been filled in. Notice that the endpoint also includes a special label calico/k8s_ns, which is automatically populated with the pod’s Kubernetes namespace.

```
$ calicoctl get wep --workload advanced-policy-demo.nginx-701339712-x1uqe -o yaml
- apiVersion: v1
  kind: workloadEndpoint
  metadata:
    labels:
      calico/k8s_ns: advanced-policy-demo
      pod-template-hash: "701339712"
      run: nginx
    name: eth0
    node: k8s-node-01
    orchestrator: k8s
    workload: advanced-policy-demo.nginx-701339712-x1uqe
  spec:
    interfaceName: cali347609b8bd7
    ipNetworks:
    - 192.168.44.65/32
    mac: 56:b5:54:be:b2:a2
    profiles:
    - k8s_ns.advanced-policy-demo

```

4. Now, create a new Kubernetes config yaml file, this time with `kind: NetworkPolicy`. The following example shows a network policy that allows traffic.

5. Create a file named `networkpol.yaml`, and enter the following information into the file:

   ```
   kind: NetworkPolicy
   apiVersion: extensions/v1beta1
   metadata:
     name: access-nginx
     namespace: advanced-policy-demo
   spec:
     podSelector:
       matchLabels:
         run: nginx
     ingress:
       - from:
         - podSelector:
             matchLabels: {}
   ```

6. Apply the policies to the cluster.

   OS X and Linux:

      ```calicoctl apply -f networkpol.yaml```

   It now shows up as a policy object in the Calico API.

      ```
      $ calicoctl get policy -o wide
      NAME                                ORDER   SELECTOR
      advanced-policy-demo.access-nginx   1000    calico/k8s_ns == 'advanced-policy-demo' && run == 'nginx'
      k8s-policy-no-match                 2000    has(calico/k8s_ns)
      ```

Congrats! You just defined your first network policy, and entered into your first foray into network security and network hardening.
