Instructions to deployments can be found at official kubernetes github https://github.com/kubernetes/dashboard

$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml

$ kubect proxy

http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login

To reteive token to login

$ kubectl get sa -n kubernetes-dashboard

$ kubectl describe sa kubernetes-dashboard -n kubernetes-dashboard

$ kubectl describe secret kubernetes-dashboard-token-wtrqz -n kubernetes-dashboard

Copy token and login. After login you will have limites access to resources. To get full cluster access cretae a service account with cluster-admin role

$ kubectl apply -f sa-custer-admin.yaml

$ kubectl get sa -n kubernetes-dashboard

$ kubectl describe sa dashboard-admin -n kubernetes-dashboard

$ kubectl describe secret dashboard-admin-token-6kmlg -n kubernetes-dashboard

Copy token and login with new token

Now you should have full cluster access

To access the dashboard across network , update dashboard service to NodePort

$ kubect edit svc kubernetes-dashboard -n kubernetes-dashboard
Change ClusterIP to NodePort
:wq to save

$ kubect get svc -n kubernetes-dashboard

Access using node port as https://worker-node:node-port/




