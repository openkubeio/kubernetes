> **Instructions to deployments can be found at official kubernetes github https://github.com/kubernetes/dashboard**

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml

kubect proxy

http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login

```

> **To reteive token to login**

```
kubectl get sa -n kubernetes-dashboard

secret=$(kubectl get sa kubernetes-dashboard -n kubernetes-dashboard -o jsonpath="{.secrets[0].name}")

token=$(kubectl get secret $secret -n  kubernetes-dashboard  -o jsonpath="{.data.token}")

echo $token | base64 -d
```

Copy token and login. After login you will have limites access to resources. To get full cluster access cretae a service account with cluster-admin role


> **Create Admin user with admin role**

```
kubectl apply -f sa-custer-admin.yaml

kubectl get sa -n kubernetes-dashboard

admin_secret=$(kubectl get sa dashboard-admin -n kubernetes-dashboard -o jsonpath="{.secrets[0].name}")

admin_token=$(kubectl get secret $admin_secret -n  kubernetes-dashboard  -o jsonpath="{.data.token}")

echo $admin_token | base64 -d
```
Copy token and login with new token, now you should have full cluster access


> **To intall metrics server to see dashboard metrics  https://github.com/kubernetes-sigs/metrics-server**

```
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.4.0/components.yaml

kubectl get pods -n kube-system | grep metrics

kubectl top pods
``

