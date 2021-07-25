> **Official Openldap Chart**

https://github.com/helm/charts/tree/master/stable/openldap

```
helm version
>>>
version.BuildInfo{Version:"v3.4.0", GitCommit:"", GitTreeState:"clean", GoVersion:"go1.14.10"}
<<<

helm repo add stable  https://charts.helm.sh/stable

helm install my-ldap  stable/openldap 

helm pull stable/openldap
```

<br/><br/>

> **Install Openlap Helm Chart**
```
helm install my-ldap  charts/openldap-1.2.7.tgz --values values/ldap.values.yaml
```

<br/><br/>

> **Test Openldap helm release**
```
LDAP_ADMIN_PASSWORD=$(kubectl get secret --namespace default my-ldap-openldap -o jsonpath="{.data.LDAP_ADMIN_PASSWORD}" | base64 --decode)

LDAP_CONFIG_PASSWORD=$(kubectl get secret --namespace default my-ldap-openldap -o jsonpath="{.data.LDAP_CONFIG_PASSWORD}" | base64 --decode)

LDAP_HOST=ldap://my-ldap-openldap.default.svc.cluster.local:389

kubectl run alpine --generator=run-pod/v1 --image=openkubeio/alpine-openldap-client --restart=Always --env="LDAP_HOST=$LDAP_HOST"  --env="LDAP_ADMIN_PASSWORD=$LDAP_ADMIN_PASSWORD" --env="LDAP_CONFIG_PASSWORD=$LDAP_CONFIG_PASSWORD"

kubectl exec alpine -- ldapsearch  -H $LDAP_HOST -b dc=openkube,dc=org -D "cn=admin,dc=openkube,dc=org" -w $LDAP_ADMIN_PASSWORD -x

```

<br/><br/>

> **Add Users and Groups with ldif file**

```
kubectl cp soa.openkube.org.ldif  alpine:/soa.openkube.org.ldif

kubectl exec alpine -- ldapadd -x -H $LDAP_HOST -D "cn=admin,dc=openkube,dc=org" -w $LDAP_ADMIN_PASSWORD -f /soa.openkube.org.ldif

```

<br/><br/>

> **Serach and validate  Users and Groups**

```
kubectl exec alpine -- ldapsearch  -H $LDAP_HOST -D "cn=admin,dc=openkube,dc=org" -b dc=soa,dc=openkube,dc=org -w $LDAP_ADMIN_PASSWORD -x 

kubectl exec alpine -- ldapsearch  -H $LDAP_HOST -D "cn=admin,dc=openkube,dc=org" -b ou=Groups,dc=soa,dc=openkube,dc=org -w $LDAP_ADMIN_PASSWORD -x 

kubectl exec alpine -- ldapsearch  -H $LDAP_HOST -D "cn=admin,dc=openkube,dc=org" -b ou=Users,dc=soa,dc=openkube,dc=org -w $LDAP_ADMIN_PASSWORD -x  "(&(objectclass=*))" +

```

<br/><br/>

> **Generate hashed password for User**

```
LDAP_POD=$(kubectl get pods -o custom-columns=:.metadata.name -l app=openldap)

kubectl exec -it $LDAP_POD -- slappasswd -h {SSHA}

New password:
Re-enter new password:
{SSHA}NMiqcWPcpSQ49n3d6ICPh9R4FsjoNTgD
```


<br/><br/>

> **Update password for a user with ldif file**
```

kubectl exec -it alpine -- sh

cat > updatepasswd.ldif << EOL
dn: cn=SOA2007,ou=Users,dc=soa,dc=openkube,dc=org
changetype: modify
replace: userpassword
userpassword: {SSHA}NMiqcWPcpSQ49n3d6ICPh9R4FsjoNTgD
EOL

ldapmodify -x -H $LDAP_HOST -D "cn=admin,dc=openkube,dc=org" -w $LDAP_ADMIN_PASSWORD -f updatepasswd.ldif

```
