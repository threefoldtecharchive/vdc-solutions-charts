# Filebrowser - Helm chart for Kubernetes Deployment
Filebrowser provides a file managing interface within a specified directory and it can be used to upload, delete, preview, rename and edit your files. It allows the creation of multiple users and each user can have its own directory. It can be used as a standalone app or as a middleware.
This is a basic helm chart that allows to run Filebrowser full node on a Kubernetes cluster.

# Features
Please refer to our docs at https://filebrowser.org/features

# Repository
https://github.com/crystaluniverse/crystal_filebrowser/tree/development_grid
# Deployment
Filebrowser can be deployed using the following steps:
helm install filebrowser ./ \
--set extraEnvVars[0].name="DOCUMENTSERVER_URL"
--set extraEnvVars[0].value="URL to the documentserver filebrowser can use" 
--set extraEnvVars[1].name="THREEBOT_APP_ID" 
--set extraEnvVars[1].value="Hostname where the application will be exposed" 

