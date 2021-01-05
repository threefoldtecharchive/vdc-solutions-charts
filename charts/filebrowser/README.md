## Filebrowser - Helm chart for Kubernetes Deployment

This is a basic helm chart that allows to run Filebrowser full node on a Kubernetes cluster.

Filebrowser can be deployed using the following steps:
helm install filebrowser ./ \
--set DOCUMENTSERVER_URL="URL to the documentserver filebrowser can use"
--set THREEBOT_APP_ID="Hostname where the application will be exposed" 

Important note:
The application does a redirect for authorization. When the app is exposed to another port the redirect won't work as the javascript isn't taking into account the port number.
Make sure to expose the deployed solution on default webserver ports  (80 or 443)