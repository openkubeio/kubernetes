To enable audit logs in Kubernetes:


**1.** Create the policy file at `/etc/kubernetes/audit-policies/audit-policy.yaml` 
to specify the types of API requests you want to capture in your audit 
logs. Audit policy rules are evaluated in order.

**2.** Audit logs are disabled by default in Kubernetes. To enable them in your API server configuration, 
specify an audit policy file path:

kube-apiserver.yaml
```
  [...]
  --audit-log-path=/var/log/kubernetes/apiserver/audit.log
  --audit-policy-file=/etc/kubernetes/audit-policies/audit-policy.yaml
```


##### Enable with Kind Cluster

**1.** Create an audit-policy.yaml file

**2.** Create a kind-config.yaml file

**3.** Launch a new cluster

```
kind create cluster --name aud-cluster --config kind-config.yaml
```

**4.** View audit logs on the control plane 

docker exec  aud-cluster-control-plane cat /var/log/kubernetes/kube-apiserver-audit.log

