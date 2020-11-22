# How to use 3bot chart
- add helm repo
```
helm repo add marketplace https://threefoldtech.github.io/marketplace-charts/

```

- install the chart 
```
helm install markteplace/3bot
```

- installing the chart with different parameters
```
helm install marketplace/3bot --set hosts[0].host="myhost" --set hosts[0].path="/" --set env[0].name=BACKUP_PASSWORD set env[0].value="backup_password" --set env[0].name="THREEBOT_NAME" --set env[1].value="threebot_name" --set env[2].name="INSTANCE_NAME" --set env[2].value="instance_name"
```