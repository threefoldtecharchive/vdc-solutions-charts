#!/bin/bash

directories=`ls -d charts/*`

for f in $directories; do
  helm package -u $f
done

helm repo index --url https://threefoldtech.github.io/vdc-solutions-charts/  .
