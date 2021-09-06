# publishtools

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0](https://img.shields.io/badge/AppVersion-1.0-informational?style=flat-square)

A Helm chart for Kubernetes to deploy publishtools.

## Prerequisites
* Kubernetes 1.9+ with Beta APIs enabled
* Helm v2/v3

## Installation

```
helm repo add marketplace https://threefoldtech.github.io/vdc-solutions-charts/
export SSHKEY=$(cat ~/.ssh/github1)
helm install marketplace/publishtools --set ssh_key=$SSHKEY --set env.dns_enabled=false
```

## Values

Possible config values with examples (configuration to twin server are passed via env)

```yaml
ingress.host: chart-example.local
env.name: ""
env.dns_port: 53
env.dns_enabled: true
env.http_port: 80
env.http_session_secret: fbc5def3-bbef-4836-8c76-51e0cef14e2f
env.http_devport: 3000
env.http_publishtoolsport: 9998
env.hyperdrive_path: ~/.digitaltwin'
env.hyperdrive_enabled: false
env.hyperdrive_drives: []
env.publishtools_root: /workspace/publisher/
env.publishtools_sitesconfig: https://github.com/threefoldfoundation/www_config_private/tree/main
env.threebot_passphrase: analyst wrist friend quick person embrace spell bacon congress gorilla price figure mind camp vanish enrich large rhythm space garden arrive doctor poverty special
```

