> **Official OpenldapPHPAdmin Chart**

&nbsp;&nbsp;&nbsp;  https://artifacthub.io/packages/helm/cetic/phpldapadmin <br/>
&nbsp;&nbsp;&nbsp;  https://github.com/cetic/helm-phpLDAPadmin
```
helm version
version.BuildInfo{Version:"v3.4.0", GitCommit:"", GitTreeState:"clean", GoVersion:"go1.14.10"}

helm repo add cetic https://cetic.github.io/helm-charts

helm repo update

helm pull cetic/phpldapadmin
```

<br/><br/>

> **Install Ldap Php Admin Helm Chart**
```
helm install ldapphpadmin  phpldapadmin-0.1.4.tgz --values phpadmin.values.yaml

export PHPADMIN_POD=$(kubectl get pods -o custom-columns=:.metadata.name -l app=phpldapadmin)

export NODE_IP=$(kubectl get pod $PHPADMIN_POD -o jsonpath="{.status.hostIP}")

export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services ldapphpadmin-phpldapadmin)

echo http://$NODE_IP:$NODE_PORT
```
