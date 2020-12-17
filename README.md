# How to use and add charts to this repo

## Installing charts

-   Adding the repo to your helm 

    ```
    helm repo add marketplace https://threefoldtech.github.io/vdc-solutions-charts/
    ```
-   install a chart 

    ```
    helm install marketplace/<chart-name>
    ```

## adding/modifying a chart in the repo

1.  Consider adding your chart under `charts` directory
2.  Make sure the deployment file or statefulset file in your chart has **some labels**, that will help in listing the solution instances:
    ```
    app.kubernetes.io/name: <your-chart-name>
    app.kubernetes.io/instance: {{ .Rleease.Name }}
    app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
    ```
3.  Do `helm lint charts/<your-chart-name>`
4.  Regenerate the packages `helm package charts/<your-chart-name>`
5.  Re-generate `index.yaml` 


    `helm repo index --url https://threefoldtech.github.io/vdc-solutions-charts/ --merge index.yaml .`

6.  Push your changes

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
