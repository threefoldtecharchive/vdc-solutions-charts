## Dash - Helm chart for Kubernetes Deployment

This is a basic helm chart that allows to run Dash full node on a Kubernetes cluster.

### How to Deploy ?
```
git clone https://github.com/threefoldfoundation/blockchain_partners.git
cd Dash/helm
helm install dash-node .
```
Here dash-node is the node name which you can be changed as per requirements. If the install is successful, here is what you should see below,

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
root@k8s-master:~/blockchain_partners/Dash/helm# kubectl get svc -o wide
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE     SELECTOR
dash         NodePort    10.100.91.76   <none>        22:32613/TCP   8m23s   app.kubernetes.io/instance=dash,app.kubernetes.io/name=dash
kubernetes   ClusterIP   10.96.0.1      <none>        443/TCP        11d     <none>
```
Now you can describe the service with kubectl to see details,

**kubectl describe svc dash**

```
root@k8s-master:~/blockchain_partners/Dash/helm# kubectl describe svc dash
Name:                     dash
Namespace:                default
Labels:                   app.kubernetes.io/instance=dash
                          app.kubernetes.io/managed-by=Helm
                          app.kubernetes.io/name=dash
                          app.kubernetes.io/version=1.16.0
                          helm.sh/chart=dash-0.1.0
Annotations:              meta.helm.sh/release-name: dash
                          meta.helm.sh/release-namespace: default
Selector:                 app.kubernetes.io/instance=dash,app.kubernetes.io/name=dash
Type:                     NodePort
IP:                       10.102.200.184
Port:                     ssh  22/TCP
TargetPort:               22/TCP
NodePort:                 ssh  31843/TCP
Endpoints:                192.168.215.120:22
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

![dash_start.png](../images/dash_start.png)

### How to verify the K8s deployment ?

To verify via helm, simply run helm ls

**helm ls**

```
root@k8s-master:~/blockchain_partners/Dash/helm# helm ls
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
dash    default         1               2020-11-22 16:54:31.640808286 +0000 UTC deployed        dash-0.1.0      1.16.0
```

Also, you can check via kubectl with the following commands,

```
root@k8s-master:~/blockchain_partners/Dash/helm# kubectl get deployments -o wide
NAME   READY   UP-TO-DATE   AVAILABLE   AGE    CONTAINERS   IMAGES                 SELECTOR
dash   1/1     1            1           7m7s   dash         arrajput/dash:latest   app.kubernetes.io/instance=dash,app.kubernetes.io/name=dash
```

To dig deeper, use kubectl to describe your deployment,

```
root@k8s-master:~/blockchain_partners/Dash/helm# kubectl describe deployment dash
Name:                   dash
Namespace:              default
CreationTimestamp:      Sun, 22 Nov 2020 16:54:31 +0000
Labels:                 app.kubernetes.io/instance=dash
                        app.kubernetes.io/managed-by=Helm
                        app.kubernetes.io/name=dash
                        app.kubernetes.io/version=1.16.0
                        helm.sh/chart=dash-0.1.0
Annotations:            deployment.kubernetes.io/revision: 1
                        meta.helm.sh/release-name: dash
                        meta.helm.sh/release-namespace: default
Selector:               app.kubernetes.io/instance=dash,app.kubernetes.io/name=dash
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:           app.kubernetes.io/instance=dash
                    app.kubernetes.io/name=dash
  Service Account:  dash
  Containers:
   dash:
    Image:        arrajput/dash:latest
    Port:         22/TCP
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:
      /dash from dash-storage (rw)
  Volumes:
   dash-storage:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  dash-volume-claim
    ReadOnly:   false
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   dash-57c9c84555 (1/1 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  8m6s  deployment-controller  Scaled up replica set dash-57c9c84555 to 1
```

## Dash Persistence - Where does the DASH data live ?

The data for the dash pod lives in the **/dash** directory of the host or worker node. The storageClass used uses the host directory for persistence. Based upon your requirements and the size of your K8s cluster, you can change the values in,

* [dash-volume.yaml](templates/dash-volume.yaml)
* [dash-volume-claim.yaml](templates/dash-volume-claim.yaml)

You can see the contents of the **/dash** with the tree command,

![dash-tree.png](../images/dash-tree.png)

## Configurable Values ?

Technically almost everything is configurable, however, there are are a few values that you may want to change as this is just a dry run,

* For compute, you can see [values.yaml](values.yaml), under the resources section
* For storage and volumes, you can see [dash-volume.yaml](templates/dash-volume.yaml) and [dash-volume-claim.yaml](templates/dash-volume-claim.yaml)
* To change underlying docker images used by the pod, see [values.yaml](values.yaml), under the image section
* To make changes in the deployment, you may see [deployment.yaml](templates/deployment.yaml)

## Recommended Node Sizes for Dash ?

* Minimum 2 cores 
* 4 GB RAM  
* 80 GB HDD or SSD


