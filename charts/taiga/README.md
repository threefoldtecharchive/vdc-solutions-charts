# How to use taiga chart
- add helm repo
```
helm repo add test-helm-charts https://sameh-farouk.github.io/test-helm-charts/
```

- install the chart
```
helm install test-helm-charts/taiga
```

- installing the chart with different parameters
```
helm install test-helm-charts/taiga --set ingress.host="domain" --set threefoldlogin.apiAppSecret="login-api-secret-key" --set threefoldlogin.apiAppPublicKey="login-api-public-key" --set threefoldlogin.apiUrl="login-url" --set threefoldlogin.openKycUrl="login-openkyc-url"
```