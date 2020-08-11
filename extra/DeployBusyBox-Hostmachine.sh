cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: DaemonSet
metadata:
  labels:
    k8s-app: df-proxy
  name: df-proxy
spec:
  selector:
    matchLabels:
      k8s-app: df-proxy
  template:
    metadata:
      labels:
        k8s-app: df-proxy
    spec:
      containers:
      - command:
        - sleep
        - "3400"
        image: busybox
        imagePullPolicy: IfNotPresent
        name: df-proxy
        resources: {}
        volumeMounts:
        - name: busybox-dev
          mountPath: /proc
        securityContext:
          privileged: true
          capabilities: {}
          procMount: Default
      hostNetwork: true
      hostPID: true
      hostIPC: true
      securityContext: {}
      volumes:
      - name: busybox-dev
        hostPath: 
          path: /dev
EOF



https://medium.com/lucjuggery/a-container-to-access-the-shell-of-the-host-2c7c227c64e9

docker run --privileged --pid=host -it alpine:3.8 \
nsenter -t 1 -m -u -n -i /bin/sh

https://twpower.github.io/178-run-container-as-privileged-mode-en

https://docs.bitnami.com/tutorials/configure-rbac-in-your-kubernetes-cluster/




kubectl config set-cluster kubernetes --server=https://192.168.210.10:6443 --insecure-skip-tls-verify=true
kubectl config set-credentials employee --client-certificate=/c/Users/Pramode/employee.crt  --client-key=/c/Users/Pramode/employee.key
kubectl config set-context employee-context --cluster=kubernetes --namespace=office --user=employee
kubectl config use-context employee-context
