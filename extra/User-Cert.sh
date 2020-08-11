cd /etc/kubernetes/pki

openssl genrsa -out employee.key 2048
 
openssl req -new -key employee.key -out employee.csr -subj "/CN=employee/O=openkube"

openssl x509 -req -in employee.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out employee.crt -days 500

