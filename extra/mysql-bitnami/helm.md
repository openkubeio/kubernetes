$ kubectl create ns mysql

$ helm install mysql --set \
mysqlRootPassword=secretpassword,\
mysqlUser=my-user,\
mysqlPassword=my-password,\
mysqlDatabase=my-database,\
master.persistence.enabled=fase,\
slave.persistence.enabled=false,\
slave.replicas=3 \		
bitnami/mysql --namespace=mysql


# master.persistence.storageClass=haketi,\
# slave.persistence.storageClass=haketi,\

NAME: mysql
LAST DEPLOYED: Tue Mar 17 10:44:41 2020
NAMESPACE: mysql
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Please be patient while the chart is being deployed

Tip:

  Watch the deployment status using the command: kubectl get pods -w --namespace mysql

Services:

  echo Master: mysql.mysql.svc.cluster.local:3306
  echo Slave:  mysql-slave.mysql.svc.cluster.local:3306

Administrator credentials:

  echo Username: root
  echo Password : $(kubectl get secret --namespace mysql mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode)

To connect to your database:

  1. Run a pod that you can use as a client:

      kubectl run mysql-client --rm --tty -i --restart='Never' --image  docker.io/bitnami/mysql:8.0.19-debian-10-r49 --namespace mysql --command -- bash

  2. To connect to master service (read/write):

      mysql -h mysql.mysql.svc.cluster.local -uroot -p my_database

  3. To connect to slave service (read-only):

      mysql -h mysql-slave.mysql.svc.cluster.local -uroot -p my_database

To upgrade this helm chart:

  1. Obtain the password as described on the 'Administrator credentials' section and set the 'root.password' parameter as shown below:

      ROOT_PASSWORD=$(kubectl get secret --namespace mysql mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode)
      helm upgrade mysql bitnami/mysql --set root.password=$ROOT_PASSWORD

Pramode@pandit-pramode MINGW64 /D/pramode2009/kubernetes (master)