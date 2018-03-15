
# Understand the security offerings available to developers to create a highly secure deployment in IBM Cloud Container Service

Every Kubernetes cluster is set up with a network plug-in that is called Calico. Default network policies are set up to secure the public network interface of every worker node. You can use Calico and native Kubernetes capabilities to configure more network policies for a cluster when you have unique security requirements. These network policies specify the network traffic that you want to allow or block to and from a pod in a cluster.

You can choose between Calico and native Kubernetes capabilities to create network policies for your cluster. You might use Kubernetes network policies to get started, but for more robust capabilities, use the Calico network policies.

Kubernetes network policies External link icon: Some basic options are provided, such as specifying which pods can communicate with each other. Incoming network traffic for pods can be allowed or blocked for a protocol and port based on the labels and Kubernetes namespaces of the pod that is trying to connect to them.
These policies can be applied by using kubectl commands or the Kubernetes APIs. When these policies are applied, they are converted into Calico network policies and Calico enforces these policies.
Calico network policies External link icon: These policies are a superset of the Kubernetes network policies and enhance the native Kubernetes capabilities with the following features:
* Allow or block network traffic on specific network interfaces, not only Kubernetes pod traffic.
* Allow or block incoming (ingress) and outgoing (egress) network traffic.
* Allow or block traffic that is based on a source or destination IP address or CIDR.

These policies are applied by using calicoctl commands. Calico enforces these policies, including any Kubernetes network policies that are converted to Calico policies, by setting up Linux iptables rules on the Kubernetes worker nodes. Iptables rules serve as a firewall for the worker node to define the characteristics that the network traffic must meet to be forwarded to the targeted resource.
Default policy configuration
When a cluster is created, default network policies are automatically set up for the public network interface of each worker node to limit incoming traffic for a worker node from the public internet. These policies do not affect pod to pod traffic and are set up to allow access to the Kubernetes nodeport, load balancer, and Ingress services.

Default policies are not applied to pods directly; they are applied to the public network interface of a worker node by using a Calico host endpoint External link icon. When a host endpoint is created in Calico, all traffic to and from that worker node's network interface is blocked, unless that traffic is allowed by a policy.

Note that a policy to allow SSH does not exist, so SSH access by way of the public network interface is blocked, as are all other ports that do not have a policy to open them. SSH access, and other access, is available on the private network interface of each worker node.

Important: Do not remove policies that are applied to a host endpoint unless you fully understand the policy and know that you do not need the traffic that is being allowed by the policy.



 Default policies for each cluster:
```
allow-all-outbound	//Allows all outbound traffic.
allow-icmp	 //Allows incoming icmp packets (pings).
allow-kubelet-port	//Allows all incoming traffic to port 10250, which is the port that is used by the kubelet. This policy allows kubectl logs and kubectl exec to work properly in the Kubernetes cluster.
allow-node-port-dnat	//Allows incoming nodeport, load balancer, and ingress service traffic to the pods that those services are exposing.
allow-sys-mgmt	//Allows incoming connections for specific IBM Cloud Infrastructure (SoftLayer) systems that are used to manage the worker nodes.
allow-vrrp  	//Allow vrrp packets, which are used to monitor and move virtual IP addresses between worker nodes.
```

The lab will help you install, learn, and set up a basic calico network policy to secure your own clusters.
