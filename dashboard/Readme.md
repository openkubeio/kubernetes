#### Instructions to deployments can be found at official kubernetes github https://github.com/kubernetes/dashboard

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml

kubect proxy

http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login

```

#### To reteive token to login

```
kubectl get sa -n kubernetes-dashboard

secret=$(kubectl get sa kubernetes-dashboard -n kubernetes-dashboard -o jsonpath="{.secrets[0].name}")

token=$(kubectl get secret $secret -n  kubernetes-dashboard  -o jsonpath="{.data.token}")

echo $token | base64 -d
```
Copy token and login. After login you will have limites access to resources. To get full cluster access cretae a service account with cluster-admin role

<br/>

#### Create Admin user with admin role

```
kubectl apply -f sa-custer-admin.yaml

kubectl get sa -n kubernetes-dashboard

admin_secret=$(kubectl get sa dashboard-admin -n kubernetes-dashboard -o jsonpath="{.secrets[0].name}")

admin_token=$(kubectl get secret $admin_secret -n  kubernetes-dashboard  -o jsonpath="{.data.token}")

echo $admin_token | base64 -d
```
Copy token and login with new token, now you should have full cluster access

<br/>

#### To intall metrics server to see dashboard metrics  
> https://github.com/kubernetes-sigs/metrics-server

```
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.4.0/components.yaml

kubectl get pods -n kube-system | grep metrics

## Patch the deployment to skip validation of client ca cert presented by kubelet - OKAY for Dev! ##

kubectl patch deploy metrics-server -n kube-system  --type='json' -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-inse
cure-tls" }]'

kubectl get deploy metrics-server -n kube-system -o jsonpath={.spec.template.spec.containers[0].args}

kubectl top pods
```

