## Digibyte - Helm chart for Kubernetes Deployment

This is a basic helm chart that allows to run Digibyte full node on a Kubernetes cluster.

### How to Deploy ?
```
git clone https://github.com/threefoldfoundation/blockchain_partners.git
cd Digibyte/helm
helm install dgb-node .
```
Here dgb-node is the node name which you can be changed as per requirements. If the install is successful, here is what you should see below,

![](../images/helm_deploy_success.png)

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
root@k8s-master:~/blockchain_partners/Digibyte/helm# kubectl get svc
NAME                TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
dgb-node-digibyte   NodePort    10.105.230.76   <none>        22:32268/TCP   46m
kubernetes          ClusterIP   10.96.0.1       <none>        443/TCP        5d20h
```
Now you can describe the service with kubectl to see details,

**kubectl describe svc dgb-node-digibyte**

```
root@k8s-master:~/blockchain_partners/Digibyte/helm# kubectl describe svc dgb-node-digibyte
Name:                     dgb-node-digibyte
Namespace:                default
Labels:                   app.kubernetes.io/instance=dgb-node
                          app.kubernetes.io/managed-by=Helm
                          app.kubernetes.io/name=digibyte
                          app.kubernetes.io/version=1.16.0
                          helm.sh/chart=digibyte-0.1.0
Annotations:              meta.helm.sh/release-name: dgb-node
                          meta.helm.sh/release-namespace: default
Selector:                 app.kubernetes.io/instance=dgb-node,app.kubernetes.io/name=digibyte
Type:                     NodePort
IP:                       10.105.230.76
Port:                     ssh  22/TCP
TargetPort:               ssh/TCP
NodePort:                 ssh  32268/TCP
Endpoints:                192.168.215.86:22
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

![dgb_start.png](../images/dgb_start.png)

### How to verify the K8s deployment ?

To verify via helm, simply run helm ls

**helm ls**

```
root@k8s-master:~/blockchain_partners/Digibyte/helm# helm ls
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
dgb-node        default         1               2020-11-17 07:49:37.596095802 +0000 UTC deployed        digibyte-0.1.0  1.16.0
```

Also, you can check via kubectl with the following commands,

```
root@k8s-master:~/blockchain_partners/Digibyte/helm# kubectl get deployments
NAME                READY   UP-TO-DATE   AVAILABLE   AGE
dgb-node-digibyte   1/1     1            1           44m

```

To dig deeper, use kubectl to describe your deployment,

```
root@k8s-master:~/blockchain_partners/Digibyte/helm# kubectl describe deployment dgb-node-digibyte
Name:                   dgb-node-digibyte
Namespace:              default
CreationTimestamp:      Tue, 17 Nov 2020 07:49:38 +0000
Labels:                 app.kubernetes.io/instance=dgb-node
                        app.kubernetes.io/managed-by=Helm
                        app.kubernetes.io/name=digibyte
                        app.kubernetes.io/version=1.16.0
                        helm.sh/chart=digibyte-0.1.0
Annotations:            deployment.kubernetes.io/revision: 1
                        meta.helm.sh/release-name: dgb-node
                        meta.helm.sh/release-namespace: default
Selector:               app.kubernetes.io/instance=dgb-node,app.kubernetes.io/name=digibyte
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:           app.kubernetes.io/instance=dgb-node
                    app.kubernetes.io/name=digibyte
  Service Account:  dgb-node-digibyte
  Containers:
   digibyte:
    Image:        arrajput/digibyte:latest
    Port:         22/TCP
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:
      /dgb from dgb-storage (rw)
  Volumes:
   dgb-storage:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  dgb-volume-claim
    ReadOnly:   false
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   dgb-node-digibyte-564cf74fc4 (1/1 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  56m   deployment-controller  Scaled up replica set dgb-node-digibyte-564cf74fc4 to 1
```

## Digibyte Pod Persistence - Where does the DGB data live ?

The data for the digibyte pod lives in the **/dgb** directory of the host or worker node. The storageClass used uses the host directory for persistence. Based upon your requirements and the size of your K8s cluster, you can change the values in,

* [dgb-volume.yaml](templates/dgb-volume.yaml)
* [dgb-volume-claim.yaml](templates/dgb-volume-claim.yaml)


You can see the contents of the **/dgb** with the tree command,

![dgb-tree.png](../images/dgb-tree.png)

## Configurable Values ?

Technically almost everything is configurable, however, there are are a few values that you may want to change as this is just a dry run,

* For compute, you can see [values.yaml](values.yaml), under the resources section
* For storage and volumes, you can see [dgb-volume.yaml](templates/dgb-volume.yaml) and [dgb-volume-claim.yaml](templates/dgb-volume-claim.yaml)
* To change underlying docker images used by the pod, see [values.yaml](values.yaml), under the image section
* To make changes in the deployment, you may see [deployment.yaml](templates/deployment.yaml)

## Recommended Node Sizes for Digibyte ?

* Minimum 2 cores 
* 4 GB RAM  
* 50 GB HDD or SSD


