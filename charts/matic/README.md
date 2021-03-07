## Matic Full / Sentry Node

This helm chart(solution) is going to launch a Matic full node or a Sentry on Mainnet. The chart should have 3 inputs,

#### Inputs

* Node Name (which will serve as the subdomain and it can be converted to an FQDN from the chatflow itself)
* access_code (web access token for the node)
* eth_rpc_url (optional input to run as a full node)

Here is an example,

```
git clone https://github.com/threefoldtech/vdc-solutions-charts.git
cd vdc-solutions-charts
helm --install matic-node charts/matic --set global.ingress.host="mynodesomething.webgw1.grid.tf" --set access_code="mywebpasscode" --set env.eth_rpc_url="https://my_eth_api" 
```

### Services that need to be exposed

* WEB - Default traefik config should work with web ports (80/443) TCP
* BOR - 30303 TCP - from the chatflow
* HEIMDALL - 26656 TCP - from the chatflow

### Chatflow steps

* Get the node name (At the end of the chatflow, this would be a publicly reachable link where the user would be able to view the status of his node - Status Page)
* Enter your access code 
* Enter your eth_rpc_url for full node. If you don't, this would serve as the sentry node that you can use for the Validator

### Expected Results

* Successful deployment should give the end user a link based upon the node name that will allow him to see the status page (Example http://mymaticnode.webg1test.grid.tf)
* Failed deployment should request the end user to start over with the appropriate error message (if any)

