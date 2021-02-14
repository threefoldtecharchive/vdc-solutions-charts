## Presearch Node

This helm chart (solution) is going to launch a Presearch node. The chart should have 2 inputs,

#### Inputs

* Node Name (This would be hostname which will serve as the subdomain and it can be converted to an FQDN from the chatflow itself)
* REGISTRATION_CODE (This is provided by the user and it is mandatory to launch the node)

Here is an example,

```
git clone https://github.com/threefoldtech/vdc-solutions-charts.git
cd vdc-solutions-charts
helm --install presearch-node charts/presearch --set global.ingress.host="mynodesomething.webgw1.grid.tf" --set REGISTRATION_CODE="code_given_by_user" 

```
### Services that need to be exposed

* WEB - Default traefik config should work with web ports (80/443) TCP

### Chatflow steps

* Get the node name (At the end of the chatflow, this would be a publicly reachable link where the user would be able to view the status of his node - Status Page)
* Get the registration code from the user ( REGISTRATION_CODE ), this is mandatory

### Expected Results

* Successful deployment should give the end user a link based upon the node name that will allow him to see the status page (Example http://mypresearchnode.webg1test.grid.tf)
* Failed deployment should request the end user to start over with the appropriate error message (if any)

