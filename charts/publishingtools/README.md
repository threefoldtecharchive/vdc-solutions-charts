# publishingtools

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.0.0-alpha.18](https://img.shields.io/badge/AppVersion-v1.0.0--alpha.18-informational?style=flat-square)

A Helm chart for Kubernetes to deploy websites and wikis using publishingtools

# publishingtools

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.16.0](https://img.shields.io/badge/AppVersion-1.16.0-informational?style=flat-square)

A Helm chart for Kubernetes to deploy single websites and wikis using publishingtools.


## Prerequisites
* Kubernetes 1.9+ with Beta APIs enabled
* Helm v2/v3

## Installation

```
helm repo add marketplace https://threefoldtech.github.io/vdc-solutions-charts/
helm install marketplace/publishingtools --set env.title=mywebsite --set env.url=https://github.com/threefoldfoundation/www_tffoundation --set env.branch=development --set env.type=www --set env.srcdir=html
```

## Values

| Key                                                                  | Type   | Default                                                 | Description                                                  |
| -------------------------------------------------------------------- | ------ | ------------------------------------------------------- | ------------------------------------------------------------ |
| affinity                                                             | object | `{}`                                                    |                                                              |
| autoscaling.enabled                                                  | bool   | `false`                                                 |                                                              |
| autoscaling.maxReplicas                                              | int    | `100`                                                   |                                                              |
| autoscaling.minReplicas                                              | int    | `1`                                                     |                                                              |
| autoscaling.targetCPUUtilizationPercentage                           | int    | `80`                                                    |                                                              |
| env.branch                                                           | string | `"main"`                                                | repo branch                                                  |
| env.srcdir                                                           | string | `"html"`                                                | source files directory inside a wiki or website              |
| env.title                                                            | string | `"My website"`                                          | site title                                                   |
| env.url                                                              | string | `"https://github.com/threefoldfoundation/wiki_example"` | repository                                                   |
| env.type                                                             | string | `"wiki"`                                                | deployment type, possible values are "wiki", "www" or "blog" |
| fullnameOverride                                                     | string | `""`                                                    |                                                              |
| image.pullPolicy                                                     | string | `"IfNotPresent"`                                        |                                                              |
| image.repository                                                     | string | `"abom/tfweb_alpine"`                                   |                                                              |
| image.tag                                                            | string | `"latest"`                                              |                                                              |
| imagePullSecrets                                                     | list   | `[]`                                                    |                                                              |
| ingress.annotations."kubernetes.io/ingress.class"                    | string | `"traefik"`                                             |                                                              |
| ingress.annotations."traefik.ingress.kubernetes.io/request-modifier" | string | `"AddPrefix: /site"`                                    |                                                              |
| ingress.enabled                                                      | bool   | `true`                                                  |                                                              |
| ingress.host                                                         | string | `"chart-example.local"`                                 | domain name for your deployment                              |
| ingress.paths[0]                                                     | string | `"/"`                                                   |                                                              |
| ingress.tls                                                          | list   | `[]`                                                    |                                                              |
| nameOverride                                                         | string | `""`                                                    |                                                              |
| nodeSelector                                                         | object | `{}`                                                    |                                                              |
| podAnnotations                                                       | object | `{}`                                                    |                                                              |
| podSecurityContext                                                   | object | `{}`                                                    |                                                              |
| replicaCount                                                         | int    | `1`                                                     |                                                              |
| resources                                                            | object | `{}`                                                    |                                                              |
| securityContext                                                      | object | `{}`                                                    |                                                              |
| service.port                                                         | int    | `3000`                                                  |                                                              |
| service.type                                                         | string | `"ClusterIP"`                                           |                                                              |
| serviceAccount.annotations                                           | object | `{}`                                                    |                                                              |
| serviceAccount.create                                                | bool   | `true`                                                  |                                                              |
| serviceAccount.name                                                  | string | `""`                                                    |                                                              |
| tolerations                                                          | list   | `[]`                                                    |                                                              |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.4.0](https://github.com/norwoodj/helm-docs/releases/v1.4.0)
