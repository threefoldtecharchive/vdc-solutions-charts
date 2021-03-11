# How to use taiga6 chart
- add helm repo
```
helm repo add marketplace https://threefoldtech.github.io/vdc-solutions-charts/
```

- install the chart 
```
helm install markteplace/taiga
```

- installing the chart with different parameters
```
helm install markteplace/taiga --set ingress.host="domain"
```