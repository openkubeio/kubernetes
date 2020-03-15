References - 

https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/

https://gist.github.com/fntlnz/cf14feb5a46b2eda428e000157447309

Create Root Key
$ openssl genrsa -des3 -out rootCA.key 4096

Create and self sign the Root Certificate
$ openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.crt -subj "/C=US/ST=CA/O=MyOrg, Inc./CN=etc.kube.io"

Create the certificate key
$ openssl genrsa -out etc.kube.io.key 2048
 
Interactive
openssl req -new -key mydomain.com.key -out mydomain.com.csr
Non-Interactive
openssl req -new -sha256 -key etc.kube.io.key -subj "/C=US/ST=CA/O=MyOrg, Inc./CN=master1.etc.kube.io,master2.etc.kube.io,master3.etc.kube.io" -out etc.kube.io.csr


Verify the csr's content
openssl req -in etc.kube.io.csr -noout -text

openssl x509 -req -in etc.kube.io.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out etc.kube.io.crt -days 500 -sha256


Verify the certificate's content
openssl x509 -in etc.kube.io.crt -text -noout