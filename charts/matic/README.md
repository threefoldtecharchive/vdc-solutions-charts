## Polygon (Matic) Nodes

This helm chart(solution) is capable of launching 3 types of nodes,

* Sentry Node
* Full Node
* Validator

### Inputs

Specify each parameter using the --set key=value[,key=value] argument to helm install. For example,

#### Input for sentry node

* Node Name (which will serve as the subdomain and it can be converted to an FQDN from the chatflow itself)
* access_code (web access token for the node)

#### Input for full node

* Node Name (which will serve as the subdomain and it can be converted to an FQDN from the chatflow itself)
* access_code (web access token for the node)
* env.eth_rpc_url (optional input to run as a full node)

#### Input for validator node

* Node Name (which will serve as the subdomain and it can be converted to an FQDN from the chatflow itself)
* access_code (web access token for the node)
* env.eth_rpc_url (ethereum rpc url)
* eth_privkey (ethereum wallet's *private* key)
* env.eth_walletaddr (ethereum wallet address)
* eth_key_passphrase (passphrase for your ethereum wallet's *private* key)
* env.sentry_nodeid (sentry nodeid for heimdall)
* env.sentry_enodeid (sentry nodeid for bor)

Here is an example for a validator,

```
git clone https://github.com/threefoldtech/vdc-solutions-charts.git
cd vdc-solutions-charts/charts/matic

helm install matic-node \
--set global.ingress.host="mynodesomething.webgw1.grid.tf" \
--set access_code="mywebpasscode" \
--set env.eth_rpc_url="https://my_eth_api" \
--set eth_privkey=myethprivkey \
--set eth_key_passphrase=mykeypass \
--set env.eth_walletaddr=0xcvas67ga1WEGas \
--set env.sentry_nodeid=6yytaZcbghaspitre \
--set env.sentry_enodeid=oPnbVzxasq3412 \
--set threefoldVdc.backup=vdc . 

```

### Services that need to be exposed

* WEB - Default traefik config should work with web ports (80/443) TCP
* BOR - 30303 TCP 
* HEIMDALL - 26656 TCP 


### Expected Results

* Successful deployment should give the end user a link based upon the node name that will allow him to see the status page (Example http://mymaticnode.webg1test.grid.tf)
* Failed deployment should request the end user to start over with the appropriate error message (if any)

