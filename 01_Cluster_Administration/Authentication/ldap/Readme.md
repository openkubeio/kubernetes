> **Install Openlap Helm Chart**
```
helm install --name my-ldap  stable/openldap --values ldap.values.yaml
```

> **Test Openldap helm release**
```
LDAP_ADMIN_PASSWORD=$(kubectl get secret --namespace default my-ldap-openldap -o jsonpath="{.data.LDAP_ADMIN_PASSWORD}" | base64 --decode)
LDAP_CONFIG_PASSWORD=$(kubectl get secret --namespace default my-ldap-openldap -o jsonpath="{.data.LDAP_CONFIG_PASSWORD}" | base64 --decode)

kubectl run alpine --image=pramodepandit/alpine-openldap-client --restart=Never --env="LDAP_ADMIN_PASSWORD=$LDAP_ADMIN_PASSWORD" --env="LDAP_CONFIG_PASSWORD=$LDAP_CONFIG_PASSWORD"

kubectl exec alpine -- ldapsearch -x -H ldap://my-ldap-openldap.default.svc.cluster.local:389 -b dc=openkube,dc=org -D "cn=admin,dc=openkube,dc=org" -w $LDAP_ADMIN_PASSWORD
```
