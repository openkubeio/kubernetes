> **Official Openldap Chart**

Readme https://github.com/helm/charts/tree/master/stable/openldap

$ helm version
version.BuildInfo{Version:"v3.4.0", GitCommit:"7090a89efc8a18f3d8178bf47d2462450349a004", GitTreeState:"clean", GoVersion:"go1.14.10"}

$ helm repo add stable  https://charts.helm.sh/stable

$ helm install my-ldap  stable/openldap 

$ helm pull stable/openldap

> **Install Openlap Helm Chart**
```
helm install my-ldap  openldap-1.2.7.tgz --values ldap.values.yaml
```

> **Test Openldap helm release**
```
LDAP_ADMIN_PASSWORD=$(kubectl get secret --namespace default my-ldap-openldap -o jsonpath="{.data.LDAP_ADMIN_PASSWORD}" | base64 --decode)
LDAP_CONFIG_PASSWORD=$(kubectl get secret --namespace default my-ldap-openldap -o jsonpath="{.data.LDAP_CONFIG_PASSWORD}" | base64 --decode)
LDAP_HOST=ldap://my-ldap-openldap.default.svc.cluster.local:389

kubectl run alpine --image=openkubeio/alpine-openldap-client --restart=Always --env="LDAP_ADMIN_PASSWORD=$LDAP_ADMIN_PASSWORD" --env="LDAP_CONFIG_PASSWORD=$LDAP_CONFIG_PASSWORD"

kubectl exec alpine -- ldapsearch -x -H $LDAP_HOST -b dc=openkube,dc=org -D "cn=admin,dc=openkube,dc=org" -w $LDAP_ADMIN_PASSWORD
```

> **Add User**

LDAP_POD=$(kubectl get pods -o custom-columns=:.metadata.name -l app=openldap)

kubectl exec -it $LDAP_POD -- slappasswd -h {SSHA}
New password:
Re-enter new password:
{SSHA}NMiqcWPcpSQ49n3d6ICPh9R4FsjoNTgD


cat > user1.ldif << EOL
dn: cn=john,dc=openkube,dc=org
uid: OK353524
cn: johnmiller
sn: john
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
loginShell: /bin/bash
homeDirectory: /home/john
uidNumber: 35352400
gidNumber: 14564100
userPassword: {SSHA}NMiqcWPcpSQ49n3d6ICPh9R4FsjoNTgD
mail: johnmiller@myorg.org
gecos: John Miller
EOL

kubectl exec alpine -- ldapadd -x -H $LDAP_HOST -D "cn=admin,dc=openkube,dc=org" -f user1.ldif -w $LDAP_ADMIN_PASSWORD

kubectl exec alpine -- ldapsearch -x -H $LDAP_HOST -D "cn=admin,dc=openkube,dc=org" -w $LDAP_ADMIN_PASSWORD -b dc=openkube,dc=org "(&(objectClass=top)(uid=OK353524))"

> **Update password**

LDAP_POD=$(kubectl get pods -o custom-columns=:.metadata.name -l app=openldap)

kubectl exec -it $LDAP_POD -- slappasswd -h {SSHA}
New password:
Re-enter new password:
{SSHA}NMiqcWPcpSQ49n3d6ICPh9R4FsjoNTgD


cat > updatepasswd.ldif << EOL
dn: cn=john,dc=openkube,dc=org
changetype: modify
replace: userPassword
userPassword: {SSHA}NMiqcWPcpSQ49n3d6ICPh9R4FsjoNTgD
EOL

kubectl exec alpine -- ldapmodify -x -H $LDAP_HOST -D "cn=admin,dc=openkube,dc=org" -w $LDAP_ADMIN_PASSWORD -f updatepasswd.ldif

