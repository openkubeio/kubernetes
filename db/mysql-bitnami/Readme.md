# To Install this helm chart:

helm repo add bitnami https://charts.bitnami.com/bitnami

helm repo update

kubectl create ns bitnami-mysql

helm install mysql bitnami/mysql --namespace bitnami-mysql --values mysql-values.yaml

--------------------------------------------------------------------------

# To upgrade this helm chart:

ROOT_PASSWORD=$(kubectl get secret --namespace bitnami-mysql mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode)
      
helm upgrade mysql bitnami/mysql --set root.password=$ROOT_PASSWORD --namespace bitnami-mysql --values mysql-values.yaml
	  
-------------------------------------------------------------------------
Service_Master: mysql.bitnami-mysql.svc.cluster.local:3306
Service_Slave : mysql-slave.bitnami-mysql.svc.cluster.local:3306

Administrator credentials:
Username: root
Password: $(kubectl get secret --namespace bitnami-mysql mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode)

To connect to your database:

  1. Run a pod that you can use as a client:

      kubectl run mysql-client --rm --tty -i --restart='Never' --image  docker.io/bitnami/mysql:8.0.19-debian-10-r64 --namespace bitnami-mysql --command -- bash

  2. To connect to master service (read/write):

      mysql -h mysql.bitnami-mysql.svc.cluster.local -u root -p my_database

  3. To connect to slave service (read-only):

      mysql -h mysql-slave.bitnami-mysql.svc.cluster.local -uroot -p my_database

---------------------------------------------------------------------------

# Ref : https://kubernetes.io/docs/tasks/run-application/run-replicated-stateful-application/