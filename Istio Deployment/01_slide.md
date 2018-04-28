!SLIDE[bg=_images/backgrounds/white_bg.png]

# Outline

* Configure ``istioctl``
* Clone source code (of istio sample dir)
* Deploy Istio control plane
* Deploy sample app (book review app)
* Poke app /w stick
* Attempt to use Istio features
** Mutual TLS
** Dashboard/Reporting
** Traffic control
* Delete app


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Account setup

    $ bx login
    $ bx api https://api.ng.bluemix.net

!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Account setup

    $ bx cs clusters
    Name                         ID                                 State       Created          Workers   Location   Version   
    k8s.nibz.science             c78ab82852aa47c793aa993178f1c560   normal      2 months ago     4         dal10      1.8.11_1509   
    $ bx cs cluster-config k8s.nibz.science
    OK
    The configuration for k8s.nibz.science was downloaded successfully. Export environment variables to start using Kubernetes.
    export KUBECONFIG=/home/nibz/.bluemix/plugins/container-service/clusters/k8s.nibz.science/kube-config-dal10-k8s.nibz.science.yml

    $ export KUBECONFIG=/home/nibz/.bluemix/plugins/container-service/clusters/k8s.nibz.science/kube-config-dal10-k8s.nibz.science.yml



!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Clone the code

    $ curl -L https://git.io/getLatestIstio | sh -
    Downloading istio-0.7.1 from https://github.com/istio/istio/releases/download/0.7.1/istio-0.7.1-linux.tar.gz ...
    ...

!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Clone the code


    $ ls
    istio-0.7.1
    $ cd istio-0.7.1/
    $ ls
    bin  istio.VERSION  LICENSE  README.md  samples  tools
    $ export PATH=${PATH}:`pwd`/bin/
    $ which istioctl
    /home/nibz/projects/istio/quick_install_2/istio-0.7.1/bin//istioctl



!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Install Istio


    $ kubectl apply -f install/kubernetes/istio-auth.yaml
    namespace "istio-system" configured
    clusterrole.rbac.authorization.k8s.io "istio-pilot-istio-system" configured
    clusterrole.rbac.authorization.k8s.io "istio-sidecar-injector-istio-system" configured


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

#  Setup automatic sidecar injection

    $ ./install/kubernetes/webhook-create-signed-cert.sh \
    --service istio-sidecar-injector \
    --namespace istio-system \
    --secret sidecar-injector-certs

    $ kubectl apply -f install/kubernetes/istio-sidecar-injector-configmap-release.yaml


    $ cat install/kubernetes/istio-sidecar-injector.yaml | \
     ./install/kubernetes/webhook-patch-ca-bundle.sh > \
     install/kubernetes/istio-sidecar-injector-with-ca-bundle.yaml


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

#  Setup automatic sidecar injection


    $ kubectl apply -f install/kubernetes/istio-sidecar-injector-with-ca-bundle.yaml

    $ kubectl -n istio-system get deployment -listio=sidecar-injector


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental


#  Evaluate what has been created


    $ kubectl get namespace -L istio-injection
    NAME           STATUS        AGE       ISTIO-INJECTION
    default        Active        1h        
    istio-system   Active        1h        
    kube-public    Active        1h        
    kube-system    Active        1h


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Evaluate what has been created 

    $ kubectl run -i --tty --rm debug --image=busybox --restart=Never -- sh
    $


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental


#  Evaluate what has been created

    $ kubectl get pods
    NAME                        READY     STATUS    RESTARTS   AGE 
    debug                             2/2       Running   0          1m



!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental


#  Evaluate what has been created

    $ kubectl describe pod/debug
    Name:         debug
    Namespace:    default
    Node:         10.186.59.118/10.186.59.118
    Start Time:   Sat, 28 Apr 2018 10:37:40 -0500
    Labels:       run=debug
    ...

!SLIDE[bg=_images/backgrounds/black_bg.png]

.blockwhite Pause and Inquire!

.blockteal What has happened?

.blockteal What can you tell about the 'sidecar' container?

``Hint! Use kubectl describe``

!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Deploy guestbook


    $ kubectl apply -f samples/bookinfo/kube/bookinfo.yaml
    service "details" created
    deployment.extensions "details-v1" created
    service "ratings" created
    deployment.extensions "ratings-v1" created
    service "reviews" created
    deployment.extensions "reviews-v1" created
    deployment.extensions "reviews-v2" created
    deployment.extensions "reviews-v3" created
    service "productpage" created
    deployment.extensions "productpage-v1" created
    ingress.extensions "gateway" created


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental


# Evaluate what has been created


    $ kubectl get services
    NAME          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
    details       ClusterIP   172.21.136.89    <none>        9080/TCP   2m
    kubernetes    ClusterIP   172.21.0.1       <none>        443/TCP    2d
    nginx         ClusterIP   172.21.119.32    <none>        80/TCP     11h
    productpage   ClusterIP   172.21.211.176   <none>        9080/TCP   2m
    ratings       ClusterIP   172.21.206.64    <none>        9080/TCP   2m
    reviews       ClusterIP   172.21.137.145   <none>        9080/TCP   2m
    sleep         ClusterIP   172.21.146.101   <none>        80/TCP     12h
    $: kubectl get pod
    NAME                              READY     STATUS    RESTARTS   AGE
    details-v1-64b86cd49-cr8r2        2/2       Running   0          2m
    productpage-v1-84f77f8747-xs2xn   2/2       Running   0          2m
    ratings-v1-5f46655b57-gnmvv       2/2       Running   0          2m
    reviews-v1-ff6bdb95b-mrzzr        2/2       Running   0          2m
    reviews-v2-5799558d68-nbbv6       2/2       Running   0          2m
    reviews-v3-58ff7d665b-7zcd9       2/2       Running   0          2m
    sleep-776b7bcdcd-8fnvl            2/2       Running   0          11h


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental


# Access the app!

    $ bx cs workers nibz-istio-demo
    OK
    ID                                                 Public IP       Private IP      Machine Type         State    Status   Zone    Version   
    kube-dal13-crc8288301442945038323eee630614baa-w1   169.61.33.107   10.186.59.118   b2c.4x16.encrypted   normal   Ready    dal13   1.9.3_1508   
    kube-dal13-crc8288301442945038323eee630614baa-w2   169.61.33.102   10.186.59.116   b2c.4x16.encrypted   normal   Ready    dal13   1.9.3_1508   
    kube-dal13-crc8288301442945038323eee630614baa-w3   169.61.33.67    10.186.59.66    b2c.4x16.encrypted   normal   Ready    dal13   1.9.3_1508   

!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental


# Access the app!

    $ kubectl get svc istio-ingress -n istio-system -o jsonpath='{.spec.ports[0].nodePort}'
    31489


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental


# Access the app!

    $ curl -I http://169.61.33.107:31489/productpageHTTP/1.1 200 OK
    content-type: text/html; charset=utf-8
    content-length: 5723
    server: envoy
    date: Sat, 28 Apr 2018 15:47:32 GMT
    x-envoy-upstream-service-time: 88


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Analysis

    $ kubectl get ing
    NAME      HOSTS     ADDRESS        PORTS     AGE
    gateway   *         169.61.55.42   80        2h
    $ kubectl describe ing/gateway
    Name:             gateway
    Namespace:        default
    Address:          169.61.55.42
    Default backend:  default-http-backend:80 (<none>)
    Rules:
      Host  Path  Backends
      ----  ----  --------
      *
            /productpage         productpage:9080 (<none>)
            /login               productpage:9080 (<none>)
            /logout              productpage:9080 (<none>)
            /api/v1/products.*   productpage:9080 (<none>)


!SLIDE[bg=_images/backgrounds/black_bg.png]

.blockwhite Pause and Inquire!

.blockteal What has happened?

.blockteal What do the headers, ingress configuration tell you?

``Hint! Use kubectl describe``


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Look at Mutual TLS

    $ kubectl exec -it productpage-v1-84f77f8747-xs2xn -c istio-proxy /bin/bash
    I have no name!@productpage-v1-5f9b797dfc-wc25f:/$ ls /etc/certs
    cert-chain.pemkey.pem  root-cert.pem
    I have no name!@productpage-v1-5f9b797dfc-wc25f:/$ which curl
    I have no name!@productpage-v1-5f9b797dfc-wc25f:/$ exit


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental


# Change sidecar to debug

    $ kubectl apply -f install/kubernetes/istio-sidecar-injector-configmap-debug.yaml
    configmap "istio-inject" configured
    $ kubectl delete productpage-v1-5f9b797dfc-wc25f


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Evaluate Diff between debug and non debug

    $: diff install/kubernetes/istio-sidecar-injector-configmap-debug.yaml install/kubernetes/istio-sidecar-injector-configmap-release.yaml 
    25d24
    <           privileged: true
    27,39d25
    <       - args:
    <         - -c
    <         #/etc/istio/proxy value here matches ConfigPathDir const in context.go
    <         - sysctl -w kernel.core_pattern=/etc/istio/proxy/core.%e.%p.%t && ulimit -c
    <           unlimited
    <         command:
    <         - /bin/sh
    <         image: alpine
    <         imagePullPolicy: IfNotPresent
    <         name: enable-core-dump
    <         resources: {}
    <         securityContext:
    <           privileged: true
    42c28
    <         image: docker.io/istio/proxy_debug:0.7.1
    ---
    >         image: docker.io/istio/proxy:0.7.1
    89,90c75,76
    <             privileged: true
    <             readOnlyRootFilesystem: false
    ---
    >             privileged: false
    >             readOnlyRootFilesystem: true


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Look at Mutual TLS

    $ kubectl exec -it productpage-v1-84f77f8747-xs2xn -c istio-proxy /bin/bash
    I have no name!@productpage-v1-5f9b797dfc-wc25f:/$ ls /etc/certs

!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Inspect certificate


    $ openssl x509 -text -noout -in /tmp/certs.pem
    Certificate:
        Data:
            ...
            X509v3 extensions:
                X509v3 Key Usage: critical
                    Digital Signature, Key Encipherment
                X509v3 Extended Key Usage: 
                    TLS Web Server Authentication, TLS Web Client Authentication
                X509v3 Basic Constraints: critical
                    CA:FALSE
                X509v3 Subject Alternative Name: 
                    URI:spiffe://cluster.local/ns/default/sa/default
        Signature Algorithm: sha256WithRSAEncryption

!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Use curl to eval mutual TLS

    $ curl -v https://details:9080/details/0
    *   Trying 172.21.136.89...
    * Connected to details (172.21.136.89) port 9080 (#0)
    * error reading ca cert file /etc/ssl/certs/ca-certificates.crt (Error while reading file.)
    * Closing connection 0
    curl: (77) Problem with the SSL CA cert (path? access rights?)


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Use curl to eval mutual TLS


    $ curl -v https://details:9080/details/0  --cacert /etc/certs/root-cert.pem   
    *   Trying 172.21.136.89...
    * Connected to details (172.21.136.89) port 9080 (#0)
    * found 1 certificates in /etc/certs/root-cert.pem
    * found 0 certificates in /etc/ssl/certs
    * ALPN, offering http/1.1
    * gnutls_handshake() failed: Handshake failed
    * Closing connection 0
    curl: (35) gnutls_handshake() failed: Handshake failed

!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Use curl to eval mutual TLS


    $ curl -v https://details:9080/details/0  --cacert /etc/certs/root-cert.pem  --key /etc/certs/key.pem --cert /etc/certs/cert-chain.pem
    *   Trying 172.21.136.89...
    * Connected to details (172.21.136.89) port 9080 (#0)
    * found 1 certificates in /etc/certs/root-cert.pem
    * found 0 certificates in /etc/ssl/certs
    * ALPN, offering http/1.1
    * SSL connection using TLS1.2 / ECDHE_RSA_AES_128_GCM_SHA256
    *    server certificate verification OK
    *    server certificate status verification SKIPPED
    * error fetching CN from cert:The requested data were not available.
    * SSL: certificate subject name () does not match target host name 'details'
    * Closing connection 0
    curl: (51) SSL: certificate subject name () does not match target host name 'details'


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Use curl to eval mutual TLS


    $ curl -v https://details:9080/details/0  --cacert /etc/certs/root-cert.pem  --key /etc/certs/key.pem --cert /etc/certs/cert-chain.pem -k
    *   Trying 172.21.136.89...
    * Connected to details (172.21.136.89) port 9080 (#0)
    * found 1 certificates in /etc/certs/root-cert.pem
    * error fetching CN from cert:The requested data were not available.
    *    common name:  (does not match 'details')
    *    server certificate expiration date OK
    *    server certificate activation date OK
    *    issuer: O=k8s.cluster.local
    < HTTP/1.1 200 OK
    < content-type: application/json
    < server: envoy
    < x-envoy-upstream-service-time: 2
    < x-envoy-decorator-operation: default-route

!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Use curl to eval mutual TLS

    $ curl -v https://details:9080/details/0  --cacert /etc/certs/root-cert.pem  --key /etc/certs/key.pem --cert /etc/certs/cert-chain.pem -k


# Delete Everything


    $ kubectl delete -f .
    deployment.apps "redis-master" deleted
    service "redis-master" deleted
