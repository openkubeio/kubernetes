cat <<EOF | kubectl apply -f -	
apiVersion: v1
kind: Pod
metadata:
  name: busybox
  labels:
    app: busybox
spec:
  containers:
  - image: busybox
    command:
      - sleep
      - "3600"
    imagePullPolicy: IfNotPresent
    name: busybox
    env:
    - name: TZ
      value: America/New_York
  restartPolicy: Always
EOF