# How to use and add charts to this repo
## Installing charts 
- Adding the repo to your helm 
```
 helm repo add marketplace https://threefoldtech.github.io/marketplace-charts/
 ```
- install a chart 
```
helm install markteplace <chart-name>
```
## adding a chart to the repo 
1. consider adding your chart under `charts` directory
2. do helm lint `charts/<your-chart-name>`
3. re-generate `index.yaml` 
```
helm repo index --url https://threefoldtech.github.io/marketplace-charts/ --merge index.yaml .
```
4. push your changes

