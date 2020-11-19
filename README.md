# How to use and add charts to this repo

## Installing charts

-   Adding the repo to your helm 


     helm repo add marketplace https://threefoldtech.github.io/marketplace-charts/

-   install a chart 


    helm install markteplace <chart-name>

## adding/modifying a chart in the repo

1.  consider adding your chart under `charts` directory
2.  do `helm lint charts/<your-chart-name>`
3.  regenerate the packages `helm package charts/<your-chart-name>`
4.  re-generate `index.yaml` 


    `helm repo index --url https://threefoldtech.github.io/marketplace-charts/ --merge index.yaml .`

5.  push your changes

## Note

For creating new charts make sure to add memory and cpu limits in values.yaml in resources section

example

```yaml
resources:
  # We usually recommend not to specify default resources and to leave this as a conscious
  # choice for the user. This also increases chances charts run on environments with little
  # resources, such as Minikube. If you do want to specify resources, uncomment the following
  # lines, adjust them as necessary, and remove the curly braces after 'resources:'.
  limits:
    cpu: 1000m
    memory: 1024Mi
  requests:
    cpu: 900m
    memory: 1000Mi
```
