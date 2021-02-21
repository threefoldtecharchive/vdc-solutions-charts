# Gitea Helm Chart

[Gitea](https://gitea.io/en-us/) is a community managed lightweight code hosting solution written in Go. It is published under the MIT license.

## Introduction

This helm chart has taken some inspiration from https://github.com/jfelten/gitea-helm-chart
But takes a completly different approach in providing database and cache with dependencies.
Also this chart provides ldap and admin user configuration with values as well as it is deployed as statefulset to retain stored repositories.

*NOTE:* Gitea image is built from [tf-gitea](https://github.com/threefoldtech/tf-gitea) repo.

## Dependencies

Gitea can be run with external database and cache. This chart provides those dependencies, which can be
enabled, or disabled via [configuration](#configuration).

Dependencies:

* Postgresql
* Memcached
* Mysql

## Installing

```
  helm repo add marketplace https://threefoldtech.github.io/vdc-solutions-charts/
  helm install gitea marketplace/gitea
```

## Prerequisites

* Kubernetes 1.12+
* Helm 3.0+
* PV provisioner for persistent data support

## Examples

### Gitea Configuration

Gitea offers lots of configuration. This is fully described in the [Gitea Cheat Sheet](https://docs.gitea.io/en-us/config-cheat-sheet/).

```yaml
  gitea:
    config:
      APP_NAME: "Gitea: With a cup of tea."
      repository:
        ROOT: "~/gitea-repositories"
      repository.pull-request:
        WORK_IN_PROGRESS_PREFIXES: "WIP:,[WIP]:"
```

### Default Configuration

This chart will set a few defaults in the gitea configuration based on the service and ingress settings. All defaults can be overwritten in gitea.config.

INSTALL_LOCK is always set to true, since we want to configure gitea with this helm chart and everything is taken care of.

*All default settings are made directly in the generated app.ini, not in the Values.*

#### Database defaults

If a builtIn database is enabled the database configuration is set automatically. For example postgresql builtIn which will appear in the app.ini as:

```
[database]
DB_TYPE = postgres
HOST = RELEASE-NAME-postgresql.default.svc.cluster.local:5432
NAME = gitea
PASSWD = gitea
USER = gitea
```

#### Memcached defaults

Memcached is handled the exakt same way as database builtIn. Once memcached builtIn is enabled, this chart will generate the following part in the app.ini:

```
[cache]
ADAPTER = memcache
ENABLED = true
HOST = RELEASE-NAME-memcached.default.svc.cluster.local:11211
```

#### Server defaults

The server defaults are a bit more complex.
If ingress is enabled, the ROOT_URL, DOMAIN and SSH_DOMAIN will be set accordingly. HTTP_PORT always defaults to 3000 as well as SSH_PORT to 22.

```
[server]
APP_DATA_PATH = /data
DOMAIN = git.example.com
HTTP_PORT = 3000
PROTOCOL = http
ROOT_URL = http://git.example.com
SSH_DOMAIN = git.example.com
SSH_LISTEN_PORT = 22
SSH_PORT = 22
```

### External Database

An external Database can be used instead of builtIn postgresql or mysql.

```yaml
  gitea:
    database:
      builtIn:
        postgresql:
          enabled: false

    config:
      database:
        DB_TYPE: mysql
        HOST: 127.0.0.1:3306
        NAME: gitea
        USER: root
        PASSWD: gitea
        SCHEMA: gitea
```

### Ports and external url

By default port 3000 is used for web traffic and 22 for ssh. Those can be changed:

```yaml
  service:
    http: 
      port: 3000
    ssh:
      port: 22
```

This helmchart automatically configures the clone urls to use the correct ports. You can change these ports by hand using the gitea.config dict. However you should know what you're doing.

### SSH and Ingress

If you're using ingress and wan't to use SSH, keep in mind, that ingress is not able to forward SSH Ports.
You will need a LoadBalancer like metallb and a setting in your ssh service annotations.

```yaml
service:
  ssh:
    annotations:
      metallb.universe.tf/allow-shared-ip: test
```

### Cache

This helm chart can use a built in cache. The default is memcached from bitnami.

```yaml
  gitea:
    cache:
      builtIn:
        enabled: true
```

If the built in cache should not be used simply configure the cache in gitea.config

```yaml
  gitea:
    config:
      cache:
        ENABLED: true
        ADAPTER: memory
        INTERVAL: 60
        HOST: 127.0.0.1:9090
```

### Persistence

Gitea will be deployed as a statefulset. By simply enabling the persistence and setting the storage class according to your cluster
everything else will be taken care of. The following example will create a PVC as a part of the statefulset. This PVC will not be deleted
even if you uninstall the chart.
When using Postgresql as dependency, this will also be deployed as a statefulset by default. 

If you want to manage your own PVC you can simply pass the PVC name to the chart. 

```yaml
  persistence:
    enabled: true
    existingClaim: MyAwesomeGiteaClaim
```

In case that peristence has been disabled it will simply use an empty dir volume.

Postgresql handles the persistence in the exact same way. 
You can interact with the postgres settings as displayed in the following example:

```yaml
  postgresql:
    persistence:
      enabled: true
      existingClaim: MyAwesomeGiteaPostgresClaim
```

Mysql also handles persistence the same, even though it is not deployed as a statefulset.
You can interact with the postgres settings as displayed in the following example:

```yaml
  mysql:
    persistence:
      enabled: true
      existingClaim: MyAwesomeGiteaMysqlClaim
```

### Admin User

This chart enables you to create a default admin user. It is also possible to update the password for this user by upgrading or redeloying the chart.
It is not possible to delete an admin user after it has been created. This has to be done in the ui.

```yaml
  gitea:
    admin:
      username: "MyAwesomeGiteaAdmin"
      password: "AReallyAwesomeGiteaPassword"
      email: "gi@tea.com"
```

### LDAP Settings

Like the admin user the ldap settings can be updated but also disabled or deleted.

```yaml
  gitea:
    ldap:
      enabled: true
      name: 'MyAwesomeGiteaLdap'
      securityProtocol: unencrypted
      host: "127.0.0.1"
      port: "389"
      userSearchBase: ou=Users,dc=example,dc=com
      userFilter: sAMAccountName=%s
      adminFilter: CN=Admin,CN=Group,DC=example,DC=com
      emailAttribute: mail
      bindDn: CN=ldap read,OU=Spezial,DC=example,DC=com
      bindPassword: JustAnotherBindPw
      usernameAttribute: CN
```

### Pod Annotations

Annotations can be added to the Gitea pod.

```yaml
  gitea:
    podAnnotations: {}
```

## Configuration

### Others

| Parameter           | Description                       | Default                      |
|---------------------|-----------------------------------|------------------------------|
|statefulset.terminationGracePeriodSeconds| Image to start for this pod | gitea/gitea |
|statefulset.env           | Additional environment variables to pass to containers | [] |

### Image

| Parameter           | Description                       | Default                      |
|---------------------|-----------------------------------|------------------------------|
|image.repository| Image to start for this pod | gitea/gitea |
|image.version| Image Version | 1.13.0 |
|image.pullPolicy| Image pull policy | Always |

### Persistence

| Parameter           | Description                       | Default                      |
|---------------------|-----------------------------------|------------------------------|
|persistence.enabled| Enable persistence for Gitea |true|
|persistence.existingClaim| Use an existing claim to store repository information | |
|persistence.size| Size for persistence to store repo information | 10Gi |
|persistence.accessModes|AccessMode for persistence||
|persistence.storageClass|Storage class for repository persistence||

### Ingress

| Parameter           | Description                       | Default                      |
|---------------------|-----------------------------------|------------------------------|
|ingress.enabled| enable ingress | false|
|ingress.annotations| add ingress annotations | |
|ingress.hosts| add hosts for ingress as string list | git.example.com |
|ingress.tls|add ingress tls settings|[]|

### Service

| Parameter           | Description                       | Default                      |
|---------------------|-----------------------------------|------------------------------|
|service.http.type| Kubernetes service type for web traffic | ClusterIP |
|service.http.port| Port for web traffic | 3000 |
|service.ssh.type| Kubernetes service type for ssh traffic | ClusterIP |
|service.ssh.port| Port for ssh traffic | 22 |
|service.ssh.externalTrafficPolicy| If `service.ssh.type` is `NodePort` or `LoadBalancer`, set this to `Local` to enable source IP preservation | |
|service.ssh.externalIPs| SSH service external IP addresses |[]|
|service.ssh.annotations| Additional ssh annotations for the ssh service ||

### Gitea Configuration

| Parameter           | Description                       | Default                      |
|---------------------|-----------------------------------|------------------------------|
|gitea.config | Everything in app.ini can be configured with this dict. See Examples for more details | {} |

### Memcached BuiltIn

Memcached is loaded as a dependency from [Bitnami](https://github.com/bitnami/charts/tree/master/bitnami/memcached) if enabled in the values. Complete Configuration can be taken from their website.

The following parameters are the defaults set by this chart

| Parameter           | Description                       | Default                      |
|---------------------|-----------------------------------|------------------------------|
|memcached.service.port|Memcached Port| 11211|

### Mysql BuiltIn

Mysql is loaded as a dependency from stable. Configuration can be found from this [website](https://github.com/helm/charts/tree/master/stable/mysql)

The following parameters are the defaults set by this chart

| Parameter           | Description                       | Default                      |
|---------------------|-----------------------------------|------------------------------|
|mysql.mysqlRootPassword|Password for the root user. Ignored if existing secret is provided|gitea|
|mysql.mysqlUser|Username of new user to create.|gitea|
|mysql.mysqlPassword|Password for the new user. Ignored if existing secret is provided|gitea|
|mysql.mysqlDatabase|Name for new database to create.|gitea|
|mysql.service.port|Port to connect to mysql service|3306|
|mysql.persistence.size|Persistence size for mysql |10Gi|

### Postgresql BuiltIn

Postgresql is loaded as a dependency from bitnami. Configuration can be found from this [Bitnami](https://github.com/bitnami/charts/tree/master/bitnami/postgresql)

The following parameters are the defaults set by this chart

| Parameter           | Description                       | Default                      |
|---------------------|-----------------------------------|------------------------------|
|postgresql.global.postgresql.postgresqlDatabase| PostgreSQL database (overrides postgresqlDatabase)|gitea|
|postgresql.global.postgresql.postgresqlUsername| PostgreSQL username (overrides postgresqlUsername)|gitea|
|postgresql.global.postgresql.postgresqlPassword| PostgreSQL admin password (overrides postgresqlPassword)|gitea|
|postgresql.global.postgresql.servicePort|PostgreSQL port (overrides service.port)|5432|
|postgresql.persistence.size| PVC Storage Request for PostgreSQL volume |10Gi|

### MariaDB BuiltIn

MariaDB is loaded as a dependency from bitnami. Configuration can be found from this [Bitnami](https://github.com/bitnami/charts/tree/master/bitnami/mariadb)

The following parameters are the defaults set by this chart

| Parameter           | Description                       | Default                      |
|---------------------|-----------------------------------|------------------------------|
|mariadb.auth.username|Username of new user to create.|gitea|
|mariadb.auth.password|Password for the new user. Ignored if existing secret is provided|gitea|
|mariadb.auth.database|Name for new database to create.|gitea|
|mariadb.auth.rootPassword|Password for the root user.|gitea|
|mariadb.primary.service.port|Port to connect to mariadb service|3306|
|mariadb.primary.persistence.size|Persistence size for mariadb |10Gi|
