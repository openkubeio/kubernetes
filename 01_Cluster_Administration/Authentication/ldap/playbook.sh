# Official Openldap Chart
# https://github.com/helm/charts/tree/master/stable/openldap

helm repo add stable  https://charts.helm.sh/stable

# helm install my-ldap  stable/openldap --values ldap.values.yaml


helm repo list
NAME    URL
stable  https://charts.helm.sh/stable
elastic https://helm.elastic.co

helm pull stable/openldap

helm install openkube  openldap-1.2.7.tgz  --values ldap.values.yaml


LDAP_ADMIN_PASSWORD=$(kubectl get secret --namespace default openkube-openldap -o jsonpath="{.data.LDAP_ADMIN_PASSWORD}" | base64 --decode)
LDAP_CONFIG_PASSWORD=$(kubectl get secret --namespace default openkube-openldap -o jsonpath="{.data.LDAP_CONFIG_PASSWORD}" | base64 --decode)
LDAP_HOST=ldap://openkube-openldap.default.svc.cluster.local:389

kubectl run alpine --image=pramodepandit/alpine-openldap-client --restart=Never --env="LDAP_HOST=$LDAP_HOST" --env="LDAP_ADMIN_PASSWORD=$LDAP_ADMIN_PASSWORD" --env="LDAP_CONFIG_PASSWORD=$LDAP_CONFIG_PASSWORD"

kubectl exec alpine -- ldapsearch -x -H $LDAP_HOST -b dc=openkube,dc=org -D "cn=admin,dc=openkube,dc=org" -w $LDAP_ADMIN_PASSWORD


### Add user ###

cat > user.ldif << EOL
dn: uid=billy,dc=openkube,dc=org
uid: billy
cn: 3
sn: billy
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
loginShell: /bin/bash
homeDirectory: /home/billy
uidNumber: 14583102
gidNumber: 14564100
userPassword: {SSHA}j3lBh1Seqe4rqF1+NuWmjhvtAni1JC5A
mail: billy@example.org
gecos: Billy Kopper
EOL

$ kubectl exec alpine -- ldapadd -x -H $LDAP_HOST -D "cn=admin,dc=openkube,dc=org" -f user.ldif -w $LDAP_ADMIN_PASSWORD


cat > user2.ldif << EOL
dn: cn=john,dc=openkube,dc=org
uid: AO353524
cn: john
sn: john
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
loginShell: /bin/bash
homeDirectory: /home/john
uidNumber: 14583102
gidNumber: 14564100
userPassword: {SSHA}j3lBh1Seqe4rqF1+NuWmjhvtAni1JC5A
mail: john@example.org
gecos: John Miller
EOL


kubectl exec alpine -- ldapadd -x -H $LDAP_HOST -D "cn=admin,dc=openkube,dc=org" -f user2.ldif -w $LDAP_ADMIN_PASSWORD

kubectl exec alpine -- ldapsearch -x -H $LDAP_HOST -D "cn=admin,dc=openkube,dc=org" -w $LDAP_ADMIN_PASSWORD -b dc=openkube,dc=org "(&(objectClass=top)(uid=AO353524))"

### Update password ###

kubectl exec -it openkube-openldap-8c6787988-5ckm4 -- sh
slappasswd -h {SSHA}
New password: xxxxx
Re-enter new password: xxxxx
{SSHA}AAAAAxxxxxxxAAAAAxxxxxx


cat > updatepasswd.ldif << EOL
dn: cn=john,dc=openkube,dc=org
changetype: modify
replace: userPassword
userPassword: {SSHA}AAAAAxxxxxxxAAAAAxxxxxx
EOL

kubectl exec alpine -- ldapmodify -x -H $LDAP_HOST -D "cn=admin,dc=openkube,dc=org" -w $LDAP_ADMIN_PASSWORD -f updatepasswd.ldif
