install_ldap(){

# https://github.com/helm/charts/tree/master/stable/openldap

helm install --name my-ldap  stable/openldap --values ldap.values.yaml
}

test_ldap(){
 LDAP_ADMIN_PASSWORD=$(kubectl get secret --namespace default my-ldap-openldap -o jsonpath="{.data.LDAP_ADMIN_PASSWORD}" | base64 --decode)
 LDAP_CONFIG_PASSWORD=$(kubectl get secret --namespace default my-ldap-openldap -o jsonpath="{.data.LDAP_CONFIG_PASSWORD}" | base64 --decode)

 kubectl run alpine --image=pramodepandit/alpine-openldap-client --restart=Never --env="LDAP_ADMIN_PASSWORD=$LDAP_ADMIN_PASSWORD" --env="LDAP_CONFIG_PASSWORD=$LDAP_CONFIG_PASSWORD"

 kubectl exec alpine -- ldapsearch -x -H ldap://my-ldap-openldap.default.svc.cluster.local:389 -b dc=openkube,dc=org -D "cn=admin,dc=openkube,dc=org" -w $LDAP_ADMIN_PASSWORD
}

add_user(){
https://github.com/osixia/docker-openldap/issues/227
cat >> user.ldif <<EOL
dn: uid=admin,dc=example,dc=org
uid: admin
cn: admin
sn: 3
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
loginShell: /bin/bash
homeDirectory: /home/admin
uidNumber: 14583102
gidNumber: 14564100
userPassword: admin
mail: admin@example.com
gecos: admin
EOL

}

