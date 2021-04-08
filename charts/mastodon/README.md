# Mastodon chart

A Helm chart for [Mastodon](https://github.com/tootsuite/mastodon).
Mastodon is a free, open-source social network server.

This Helm chart is designed/tested with:

| Package | Version |
| ------- | ------- |
| Mastodon | `tootsuite/mastodon:v3.3.0` |
| Kubernetes | v1.17 |

## How to Install?
Copy and edit `secrets.yaml.sample` and `values.yaml.sample` to provide your
own `secrets.yaml` and `values.yaml` files, and then deploy the Helm chart
with: 

```
helm upgrade --install -f secrets.yaml mastodon .
```

### Maintainer & License
Maintained by Tim Walls <tim.walls@snowgoons.com> - for more information see
here: https://snowgoons.ro/posts/2020-08-29-mastodon-on-kubernetes/

Based on the original chart developed by Ladicle - https://github.com/Ladicle/mastodon-chart
