## Harmony - Helm chart for Kubernetes Deployment

This is a basic helm chart that allows to run Harmony full node on a Kubernetes cluster.

### How to Deploy ?
```
git clone https://github.com/threefoldfoundation/blockchain_partners.git
cd Harmony/helm
helm install hmy-node .
```
Here hmy-node is the node name which you can be changed as per requirements. If the install is successful, here is what you should see below,

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
root@k8s-master:~/blockchain_partners/Harmony/helm# kubectl get svc -o wide
NAME               TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE     SELECTOR
hmy-node-harmony   NodePort    10.106.211.173   <none>        22:31422/TCP   6m58s   app.kubernetes.io/instance=dgb-node,app.kubernetes.io/name=harmony
kubernetes         ClusterIP   10.96.0.1        <none>        443/TCP        14d     <none>
```
Now you can describe the service with kubectl to see details,

**kubectl describe svc hmy-node-harmony**

```
root@k8s-master:~/blockchain_partners/Harmony/helm# kubectl describe svc hmy-node-harmony
Name:                     hmy-node-harmony
Namespace:                default
Labels:                   app.kubernetes.io/instance=hmy-node
                          app.kubernetes.io/managed-by=Helm
                          app.kubernetes.io/name=harmony
                          app.kubernetes.io/version=1.16.0
                          helm.sh/chart=harmony-0.1.0
Annotations:              meta.helm.sh/release-name: hmy-node
                          meta.helm.sh/release-namespace: default
Selector:                 app.kubernetes.io/instance=hmy-node,app.kubernetes.io/name=harmony
Type:                     NodePort
IP:                       10.100.57.130
Port:                     ssh  22/TCP
TargetPort:               ssh/TCP
NodePort:                 ssh  32630/TCP
Endpoints:                192.168.215.112:22
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

![start_hmy.png](../images/start_hmy.png)

### How to verify the K8s deployment ?

To verify via helm, simply run helm ls

**helm ls**

```
root@k8s-master:~/blockchain_partners/Harmony/helm# helm ls
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
hmy-node        default         1               2020-11-26 08:16:02.787063465 +0000 UTC deployed        harmony-0.1.0   1.16.0
```

Also, you can check via kubectl with the following commands,

```
root@k8s-master:~/blockchain_partners/Harmony/helm# kubectl get deployments -o wide
NAME               READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES                SELECTOR
hmy-node-harmony   1/1     1            1           92m   harmony      arrajput/hmy:latest   app.kubernetes.io/instance=hmy-node,app.kubernetes.io/name=harmony
```

To dig deeper, use kubectl to describe your deployment,

```
root@k8s-master:~/blockchain_partners/Harmony/helm# kubectl describe deployment hmy-node
Name:                   hmy-node-harmony
Namespace:              default
CreationTimestamp:      Thu, 26 Nov 2020 08:16:07 +0000
Labels:                 app.kubernetes.io/instance=hmy-node
                        app.kubernetes.io/managed-by=Helm
                        app.kubernetes.io/name=harmony
                        app.kubernetes.io/version=1.16.0
                        helm.sh/chart=harmony-0.1.0
Annotations:            deployment.kubernetes.io/revision: 1
                        meta.helm.sh/release-name: hmy-node
                        meta.helm.sh/release-namespace: default
Selector:               app.kubernetes.io/instance=hmy-node,app.kubernetes.io/name=harmony
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:           app.kubernetes.io/instance=hmy-node
                    app.kubernetes.io/name=harmony
  Service Account:  hmy-node-harmony
  Containers:
   harmony:
    Image:        arrajput/hmy:latest
    Port:         22/TCP
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:
      /hmydata from hmy-storage (rw)
  Volumes:
   hmy-storage:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  hmy-volume-claim
    ReadOnly:   false
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   hmy-node-harmony-784c98f696 (1/1 replicas created)
Events:          <none>
```

## Harmony Persistence - Where does the HARMONY data live ?

The data for the dash pod lives in the **/hmydata** directory of the host or worker node. The storageClass used uses the host directory for persistence. Based upon your requirements and the size of your K8s cluster, you can change the values in,

* [hmy-volume.yaml](templates/hmy-volume.yaml)
* [hmy-volume-claim.yaml](templates/hmy-volume-claim.yaml)

You can see the contents of the **/hmydata** with the tree command,

![hmy-tree.png](../images/hmy-tree.png)

## Configurable Values ?

Technically almost everything is configurable, however, there are are a few values that you may want to change as this is just a dry run,

* For compute, you can see [values.yaml](values.yaml), under the resources section
* For storage and volumes, you can see [hmy-volume.yaml](templates/hmy-volume.yaml) and [hmy-volume-claim.yaml](templates/hmy-volume-claim.yaml)
* To change underlying docker images used by the pod, see [values.yaml](values.yaml), under the image section
* To make changes in the deployment, you may see [deployment.yaml](templates/deployment.yaml)

## Recommended Node Sizes for Harmony ?

* Minimum 2 cores 
* 4 GB RAM  
* 80 GB HDD or SSD


