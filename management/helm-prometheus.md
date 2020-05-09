helm delete prometheus

helm install prometheus stable/prometheus --set \
server.replicaCount=3,\
server.statefulSet.enabled=true,\
server.persistentVolume.enabled=true,\
server.persistentVolume.storageClass=nfs-storageclass,\
server.persistentVolume.accessModes={ReadWriteOnce},\
alertmanager.persistentVolume.enabled=true,\
alertmanager.persistentVolume.storageClass=nfs-storageclass


helm install prometheus stable/prometheus --set \
server.persistentVolume.enabled=true,\
server.persistentVolume.storageClass=nfs-storageclass,\
server.persistentVolume.accessModes={ReadWriteOnce},\
alertmanager.persistentVolume.enabled=true,\
alertmanager.persistentVolume.storageClass=nfs-storageclass