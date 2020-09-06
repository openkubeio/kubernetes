cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: office
EOF


cat <<EOF | kubectl apply -f -
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: deployment-manager-binding
  namespace: office
subjects:
- kind: User
  name: employee  
  apiGroup: ""
roleRef:
  kind: ClusterRole
  name: deployment-manager
  apiGroup: ""
EOF

