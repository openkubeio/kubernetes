
helm pull bitnami/redis

helm install redis  redis-10.6.12.tgz --set \
master.persistence.enabled=true,\
master.persistence.storageClass=nfs-storageclass,\
master.persistence.accessModes={ReadWriteOnce},\
slave.persistence.enabled=true,\
slave.persistence.storageClass=nfs-storageclass,\
slave.persistence.accessModes={ReadWriteOnce}

helm get values redis
USER-SUPPLIED VALUES:
master:
  persistence:
    accessModes:
    - ReadWriteOnce
    storageClass: nfs-storageclass
slave:
  persistence:
    accessModes:
    - ReadWriteOnce
    storageClass: nfs-storageclass

	
	
helm get all redis --namespace default > redis.yaml	
	

helm delete redis