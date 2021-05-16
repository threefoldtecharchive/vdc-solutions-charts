## Dash Full Node

This helm chart(solution) is going to launch a Dash full node on Mainnet. The chart should have 3 inputs,

#### Inputs

* Node Name (which will serve as the subdomain and it can be converted to an FQDN from the chatflow itself)
* rpcuser (The node RPC credentials user/pass)
* rpcpasswd

Here is an example,

```
git clone https://github.com/threefoldtech/vdc-solutions-charts.git
cd vdc-solutions-charts
helm --install dgb-node charts/dash --set global.ingress.host="mynodesomething.webgw1.grid.tf" --set env.rpcuser="abdulgig" --set env.rpcpasswd="test7654" 
```

### Services that need to be exposed

* WEB - Default traefik config should work with web ports (80/443) TCP
* RPC - 14022 TCP - from the chatflow
* P2P - 12024 TCP - from the chatflow

### Chatflow steps

* Get the node name (At the end of the chatflow, this would be a publicly reachable link where the user would be able to view the status of his node - Status Page)
* Get the RPC credentials from the user ( rpcuser and rpcpasswd )

### Expected Results

* Successful deployment should give the end user a link based upon the node name that will allow him to see the status page (Example http://mydgbnode.webg1test.grid.tf)
* Failed deployment should request the end user to start over with the appropriate error message (if any)

