# Meetings - Helm chart for Kubernetes Deployment

This is a basic helm chart that allows to run Meetings full node on a Kubernetes cluster.

## Install helm package
Meetings can be deployed using the following steps:
helm install meetings ./ 

## Project setup
Backend: https://github.com/crystaluniverse/crystalmeet_backend
Frontend: https://github.com/crystaluniverse/crystalmeet_frontend
Janus Server: https://github.com/crystaluniverse/crystalmeet_janus
Combine the 3 servicese in one docker: https://github.com/jimbertools/freeflowconnect_grid