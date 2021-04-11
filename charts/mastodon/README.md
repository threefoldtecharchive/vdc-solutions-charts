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
## Parameters
The following tables lists the configurable parameters of the mastodon chart and their default values.
| Parameter                                       | Description                                                                                                                                               | Default                                                     |
|-------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------|
| `web.image`                          | web image       | `threefolddev/tf-mastodon` 
| `web.imageTag`                          | web image tag      | `v3.3.0.tf` 
| `web.imagePullPolicy`                          | web image pull policy      | `IfNotPresent` 
| `web.servicePort`                          | web image service port      | `3000` 
| `web.containerPort`                          | web image container port      | `3000` 
| `web.ingress.host`                          | web image ingress host      | `mastodon.test` 
| `streaming.image`                          | streaming image       | `tootsuite/mastodon` 
| `streaming.imageTag`                          | streaming image tag      | `v3.3.0` 
| `streaming.imagePullPolicy`                          | streaming image pull policy      | `IfNotPresent` 
| `streaming.servicePort`                          | streaming image service port      | `4000` 
| `streaming.containerPort`                          | streaming image container port      | `4000` 
| `sidekiq.image`                          | sidekiq image       | `tootsuite/mastodon` 
| `sidekiq.imageTag`                          | sidekiq image tag      | `v3.3.0` 
| `sidekiq.imagePullPolicy`                          | sidekiq image pull policy      | `IfNotPresent` 
| `redis.image`                          | redis image       | `redis` 
| `redis.imageTag`                          | redis image tag      | `6-alpine` 
| `redis.imagePullPolicy`                          | redis image pull policy      | `IfNotPresent` 
| `redis.servicePort`                          | redis image service port      | `6379` 
| `redis.containerPort`                          | redis image container port      | `6379` 
| `postgres.image`                          | postgres image       | `postgres` 
| `postgres.imageTag`                          | postgres image tag      | `9.6.2` 
| `postgres.imagePullPolicy`                          | postgres image pull policy      | `IfNotPresent` 
| `postgres.containerPort`                          | postgres image container port      | `5432` 
| `postgres.servicePort`                          | postgres image service port      | `5432` 
| `postgres.metrics.enabled`                          | enable postgres metrics        | `true` 
| `postgres.metrics.image`                          | metrics image       | `wrouesnel/postgres_exporter` 
| `postgres.metrics.imageTag`                          | metrics image tag      | `v0.1.1` 
| `postgres.metrics.imagePullPolicy`                          | metrics image pull policy      | `IfNotPresent` 
| `global.ingress.certresolver`                          | allow cert resolver to issue https certificate      | `default` 
| `postgresPassword`                          | postgress password      | `dummy` 
| `redisPassword`                          | redis password      | `dummy` 
| `paperclipSecret`                          | paperclib secret      | `dummy` 
| `secretKeyBase`                          | secret key base      | `dummy` 
| `otpSecret`                          | opt secret      | `dummy` 
| `smtpPassword`                          | smtp password      | `dummy` 
| `resources.limits.cpu`                          | cpu resources limits      | `3000` 
| `resources.limits.memory`                          | memory resources limits      | `3072` 
| `env.smtp.server`                          | smpt server      | `smtp.gmail.com` 
| `env.smtp.port`                          | smpt port      | `587` 
| `env.smtp.login`                          | smpt login      | `testmail@gmail.com` 
| `env.smtp.address`                          | smpt address      | `smtp.gmail.com` 
| `env.smtp.opensslVerifyMode`                          | smpt open ssl verify mode      | `none` 
| `env.smtp.domain`                          | smpt domain      | `mastodon.test` 
| `env.extraEnvVars[0].name`                          | environment variable name used to generate a seed      | `THREEBOT_KEY` 
| `env.extraEnvVars[0].value`                          | environment variable value used to generate a seed      |  `""`


### Maintainer & License
Maintained by Tim Walls <tim.walls@snowgoons.com> - for more information see
here: https://snowgoons.ro/posts/2020-08-29-mastodon-on-kubernetes/

Based on the original chart developed by Ladicle - https://github.com/Ladicle/mastodon-chart
