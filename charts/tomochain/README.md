## TomoChain - Helm chart for Kubernetes Deployment

This is a basic helm chart that allows to run Dash full node on a Kubernetes cluster.

### How to Deploy ?
```
git clone https://github.com/threefoldfoundation/blockchain_partners.git
cd Tomochain/helm
helm install tomo-node .
```
Here tomo-node is the node name which you can be changed as per requirements. If the install is successful, here is what you should see below,

![](../images/helm-deploy-success.png)

Next you need to run the 3 commands to SSH into the pod,
```
export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services dgb-node-digibyte)
export NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")
echo "ssh root@$NODE_IP -p $NODE_PORT"
```
This should give you the IP and port to log in. The chart uses the SSH service over the NodePort setting. An example below,

```
ssh root@172.31.105.191 -p 32268
Default root password is tfnow2020
```
You can alternately log in with the pod IP using the following commands. First get the service name and then describe it with kubectl to get the POD endpoint,

**kubectl get svc**

```
root@k8s-master:~/blockchain_partners/Tomochain/helm# kubectl get svc -o wide
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE   SELECTOR
kubernetes   ClusterIP   10.96.0.1        <none>        443/TCP        17d   <none>
tomo-node    NodePort    10.111.223.162   <none>        22:30567/TCP   13m   app.kubernetes.io/instance=tomo-node,app.kubernetes.io/name=tomo
```
Now you can describe the service with kubectl to see details,

**kubectl describe svc tomo-node**

```
root@k8s-master:~/blockchain_partners/Tomochain/helm# kubectl describe svc tomo-node
Name:                     tomo-node
Namespace:                default
Labels:                   app.kubernetes.io/instance=tomo-node
                          app.kubernetes.io/managed-by=Helm
                          app.kubernetes.io/name=tomo
                          app.kubernetes.io/version=1.16.0
                          helm.sh/chart=tomo-0.1.0
Annotations:              meta.helm.sh/release-name: tomo-node
                          meta.helm.sh/release-namespace: default
Selector:                 app.kubernetes.io/instance=tomo-node,app.kubernetes.io/name=tomo
Type:                     NodePort
IP:                       10.111.223.162
Port:                     ssh  22/TCP
TargetPort:               ssh/TCP
NodePort:                 ssh  30567/TCP
Endpoints:                192.168.215.72:22
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>
```

SSH via the endpoint listed without using the NodePort,

```
ssh root@192.168.215.86
Default root password is tfnow2020
```

Once you log in, you should see below,

![tomo_start.png](../images/tomo_start.png)

### How to verify the K8s deployment ?

To verify via helm, simply run helm ls

**helm ls**

```
root@k8s-master:~/blockchain_partners/Tomochain/helm# helm ls
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
tomo-node       default         1               2020-11-28 16:55:09.923091072 +0000 UTC deployed        tomo-0.1.0      1.16.0
```

Also, you can check via kubectl with the following commands,

```
root@k8s-master:~/blockchain_partners/Tomochain/helm# kubectl get deployments -o wide
NAME        READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES                 SELECTOR
tomo-node   1/1     1            1           15m   tomo         arrajput/tomo:latest   app.kubernetes.io/instance=tomo-node,app.kubernetes.io/name=tomo
```

To dig deeper, use kubectl to describe your deployment,

```
root@k8s-master:~/blockchain_partners/Tomochain/helm# kubectl describe deployment tomo-node
Name:                   tomo-node
Namespace:              default
CreationTimestamp:      Sat, 28 Nov 2020 16:55:10 +0000
Labels:                 app.kubernetes.io/instance=tomo-node
                        app.kubernetes.io/managed-by=Helm
                        app.kubernetes.io/name=tomo
                        app.kubernetes.io/version=1.16.0
                        helm.sh/chart=tomo-0.1.0
Annotations:            deployment.kubernetes.io/revision: 1
                        meta.helm.sh/release-name: tomo-node
                        meta.helm.sh/release-namespace: default
Selector:               app.kubernetes.io/instance=tomo-node,app.kubernetes.io/name=tomo
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:           app.kubernetes.io/instance=tomo-node
                    app.kubernetes.io/name=tomo
  Service Account:  tomo-node
  Containers:
   tomo:
    Image:        arrajput/tomo:latest
    Port:         22/TCP
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:
      /tomodata from tomo-storage (rw)
  Volumes:
   tomo-storage:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  tomo-volume-claim
    ReadOnly:   false
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   tomo-node-66945cbfdd (1/1 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  31m   deployment-controller  Scaled up replica set tomo-node-66945cbfdd to 1
```

## TomoChain Persistence - Where does the TOMOCHAIN data live ?

The data for the tomochain pod lives in the **/tomodata** directory of the host or worker node. The storageClass used uses the host directory for persistence. Based upon your requirements and the size of your K8s cluster, you can change the values in,

* [tomo-volume.yaml](templates/tomo-volume.yaml)
* [tomo-volume-claim.yaml](templates/tomo-volume-claim.yaml)

You can see the contents of the **/tomo** with the tree command,

![tomo-tree.png](../images/tomo-tree.png)

## Configurable Values ?

Technically almost everything is configurable, however, there are are a few values that you may want to change as this is just a dry run,

* For compute, you can see [values.yaml](values.yaml), under the resources section
* For storage and volumes, you can see [tomo-volume.yaml](templates/tomo-volume.yaml) and [tomo-volume-claim.yaml](templates/tomo-volume-claim.yaml)
* To change underlying docker images used by the pod, see [values.yaml](values.yaml), under the image section
* To make changes in the deployment, you may see [deployment.yaml](templates/deployment.yaml)

## Recommended Node Sizes for TomoChain ?

* Minimum 2 cores 
* 4 GB RAM  
* 80 GB HDD or SSD


