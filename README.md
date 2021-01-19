- [Introduction](#Introduction)
- [Installing Charts](#Installing-Charts)
- [Development Guide](#Development-Guide)
  - [Important Notes](#Important-Notes)
  - [Exposing Services](#Exposing-Services)
  - [Resources Limits](#Resources-Limits)
  - [Adding Labels](#Adding-Labels)
  - [Enable Https](#Adding-Labels)
  - [Adding Chart](#Adding-Chart)
  - [Packaging](#Packaging)

# Introduction
This repo is used to maintain helm charts used as solution in `VDC marketplace` product.



## Installing Charts

-   Adding the repo to your helm 

    ```bash
    helm repo add marketplace https://threefoldtech.github.io/vdc-solutions-charts/
    ```
-   install a chart 

    ```bash
    helm install marketplace/<chart-name>
    ```

# Development Guide
## Important Notes
Charts in this repo will be used `VDC marketplace` and it will be used behind `Traefik` as a load balancer, so make sure if you are adding a chart to follow the exact steps in this development guide. And also make sure no manual interaction is required to deploy your chart

## Exposing Services
We are using `Traefik/Ingress` in exposing services on the `VDC`
### Make sure
- `Ingress` is enabled on your chart
- All services that needs to be exposed are of type `ClusterIp`

If you want to expose a service on port other than 443(https), 80(http), make sure 

## Resources Limits

Make sure that your chart already configures resources limits for `memory` and `cpu` in `values.yaml` in resources section, just in case your chart go beyond deployed cluster resources.

###### example

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
## Adding Labels
 Make sure the deployment file or statefulset file in your chart has **some labels**, that will help in listing the solution instances:
  ```yaml
  app.kubernetes.io/name: <your-chart-name>
  app.kubernetes.io/instance: {{ .Release.Name }}
  app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
  ```

## Enable Https
To enable https on your chart using `gridca` as a certificate resolver, you can do the following

Make sure to add `global.ingress.certresolver` field in your values.
  ```yaml
  global:
    ingress:
      certresolver: default
  ```
  and include it in your ingress annotations in your ingress.yaml in the parent and subcharts if needed
  ```yaml
  annotations:
    {{- if .Values.ingress.certresolver }}
    traefik.ingress.kubernetes.io/router.tls.certresolver: {{ .Values.global.ingress.certresolver }}
    {{- end }}
  ```

## Adding Chart
Consider adding your chart under `charts` directory


## Packaging

  

- Do `helm lint charts/<your-chart-name>`
- Regenerate the packages `helm package -u charts/<your-chart-name>`
- Regenerate `index.yaml` 
    `helm repo index --url https://threefoldtech.github.io/vdc-solutions-charts/ --merge index.yaml .`

- Push your changes