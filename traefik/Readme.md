To install traeik inress controller

	oficial : https://docs.traefik.io/v1.3/user-guide/kubernetes/
	Helm    : https://github.com/helm/charts/tree/master/stable/traefik
	
Test with http : 

    kubectl create ns traefik-ingress
	
	helm install stable/traefik --name-template nossl-traefik --set dashboard.enabled=true,serviceType=NodePort,dashboard.domain=dashboard.traefik.io,rbac.enabled=true  --namespace traefik-ingress
	
	kubectl get svc --namespace traefik-ingress
	NAME                    TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)                      AGE
	nossl-traefik             LoadBalancer   10.150.54.87   <pending>     443:32524/TCP,80:31626/TCP   70s
	nossl-traefik-dashboard   ClusterIP      10.150.26.9    <none>        80/TCP                       70s

	edit /etc/hosts
	192.168.205.11	worker1.dv.kube.io  dashboard.traefik.io  grafana.traefik.io
	192.168.205.12	worker2.dv.kube.io  dashboard.traefik.io  grafana.traefik.io
	
	http://dashboard.traefik.io:31626/
	
	kubectl apply -f grafana
	
	http://grafana.traefik.io:31626/
	
	helm delete nossl-traefik -n traefik-ingress

Prod with SSL Enabled : 

    Cretae Namespace
	
    kubectl create ns traefik-ingress
	
	Create Traefik Certificate
	
	sudo mkdir /etc/mycerts
    
	sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/mycerts/traefik.mycluster.net.key -out /etc/mycerts/traefik.mycluster.net.crt \
	-subj "/C=US/ST=PA/L=PI/O=AU/OU=BU/CN=*.traefik.mycluster.net/emailAddress=admin@myclster.net"

	ssl.defaultCert=cat /etc/mycerts/traefik.mycluster.net.crt | base64 -w0
	ssl.defaultKey=cat /etc/mycerts/traefik.mycluster.net.key | base64 -w0

	Install Traeik thru Official Helm Chart Or run the scripts ssl-traeik.* in sequence
	
	helm install stable/traefik --name-template ssl-traefik --namespace traefik-ingress --set dashboard.enabled=true,dashboard.domain=dashboard.traefik.mycluster.net,rbac.enabled=true,ssl.enabled=true,ssl.enforced=true,ssl.defaultCert=LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUQ0VENDQXNtZ0F3SUJBZ0lKQVAzWnlKdVl6Vk9MTUEwR0NTcUdTSWIzRFFFQkN3VUFNSUdHTVFzd0NRWUQKVlFRR0V3SlZVekVMTUFrR0ExVUVDQXdDVUVFeEN6QUpCZ05WQkFjTUFsQkpNUXN3Q1FZRFZRUUtEQUpCVlRFTApNQWtHQTFVRUN3d0NRbFV4SURBZUJnTlZCQU1NRnlvdWRISmhaV1pwYXk1dGVXTnNkWE4wWlhJdWJtVjBNU0V3Ckh3WUpLb1pJaHZjTkFRa0JGaEpoWkcxcGJrQnRlV05zYzNSbGNpNXVaWFF3SGhjTk1qQXdNakF5TVRBMU56UXkKV2hjTk1qRXdNakF4TVRBMU56UXlXakNCaGpFTE1Ba0dBMVVFQmhNQ1ZWTXhDekFKQmdOVkJBZ01BbEJCTVFzdwpDUVlEVlFRSERBSlFTVEVMTUFrR0ExVUVDZ3dDUVZVeEN6QUpCZ05WQkFzTUFrSlZNU0F3SGdZRFZRUUREQmNxCkxuUnlZV1ZtYVdzdWJYbGpiSFZ6ZEdWeUxtNWxkREVoTUI4R0NTcUdTSWIzRFFFSkFSWVNZV1J0YVc1QWJYbGoKYkhOMFpYSXVibVYwTUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFxZTR1WmZNOQpZOUNyeG1pN052U2RiOUM5UTRJNXJ0cTZveUhnMUNBanRDOHhTaEsyQ3MvQlRwVlJkZ3cvc0lpVDhRY1laRSsyCmtsVkhnaktOamxFcGU4VVJ4bXBMdkxiTXgxai9TbGVKdFl0VTRlQk41bjVTbDMyOTExOGUyY3VGTGZrZGJFRlYKdjc2enZ0N0hOUlBTdjU4L3p1QkdWUHY5d2hPK2loWXdJaldNK3NteG9KUUQ1U3hKWDhBL0ROU1JmNkxMTVN6SgpiM1RkalRXaVlvbW8xZ1JRdVd4bFJhM0JEbHpudzlpL3N5RUYwTDNBcHEzQmJHUGdrRXFCK3U1Z1VhY3hpb0VuClJ3YUp6Tld6ckhBMzdDMTFIekZSQmRabW9QZFhiRDJ3K2loellVakk2UkJxUUMraXNvU2RNbStnNHArSUxMZXUKd1pUUmpUUmU5UHhXTVFJREFRQUJvMUF3VGpBZEJnTlZIUTRFRmdRVXFkajVscWtpVHYyU25RR2loUXRIWkFIdgpHU3N3SHdZRFZSMGpCQmd3Rm9BVXFkajVscWtpVHYyU25RR2loUXRIWkFIdkdTc3dEQVlEVlIwVEJBVXdBd0VCCi96QU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FRRUFmWmU1NTN5N3MvYk1ORm1TZ2lFeFhHME5MS2g2ZGtuVmM4OTkKYTlndjMyaStTMjZGV2htKzFCMmNCbTI1MWkxZWpwcHQ1NEErRC9KMTJUS2J2eG1Sd0lUdklWM2ZxQkJ3c0FvSwpHSmFYa3d4aGY3b3RDa3crNGtvM3RQQ3FYVjExNE5oOHg0c0paejNXVVVEN2NuVlpNL2lIbTV4T0ozNXpiRDZwCk9mM3M4T3FObklKWUdlKzRmc3ZmdWZ1Qnl0OENDUHdUdXRuajRIN21JUXowYlpYVVBKLzZaUDBzM1lCRHdQcGcKTmRJbithUmhFYXJSOVdVbnBXM1BNNUdZVlJFd1lJUjE2VmpjUGdVaUpraTdtU1ZoZWsyTWtnWDdIS1I1RVlkNAowVTJ4Rmdya1FINWJhTEZTdmI4SHVrVTNxS0FSYmxjV2JaTDduNXFld1dYeWhGQm5Udz09Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K,ssl.defaultKey=LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tCk1JSUV2d0lCQURBTkJna3Foa2lHOXcwQkFRRUZBQVNDQktrd2dnU2xBZ0VBQW9JQkFRQ3A3aTVsOHoxajBLdkcKYUxzMjlKMXYwTDFEZ2ptdTJycWpJZURVSUNPMEx6RktFcllLejhGT2xWRjJERCt3aUpQeEJ4aGtUN2FTVlVlQwpNbzJPVVNsN3hSSEdha3U4dHN6SFdQOUtWNG0xaTFUaDRFM21mbEtYZmIzWFh4N1p5NFV0K1Ixc1FWVy92ck8rCjNzYzFFOUsvbnovTzRFWlUrLzNDRTc2S0ZqQWlOWXo2eWJHZ2xBUGxMRWxmd0Q4TTFKRi9vc3N4TE1sdmROMk4KTmFKaWlhaldCRkM1YkdWRnJjRU9YT2ZEMkwreklRWFF2Y0NtcmNGc1krQ1FTb0g2N21CUnB6R0tnU2RIQm9uTQoxYk9zY0Rmc0xYVWZNVkVGMW1hZzkxZHNQYkQ2S0hOaFNNanBFR3BBTDZLeWhKMHliNkRpbjRnc3Q2N0JsTkdOCk5GNzAvRll4QWdNQkFBRUNnZ0VCQUlWdUpMaWcybDk2QnFkd3JUQmx1d21GbWxkYjlmYzZnTHAvYTQ2ay9lUUoKK21YemMwWGlCQ08wVTVhaDM1QzZiWkFneGlKZUJUbTZCTUJTK1p2NlZ0eDh6WXhEQXQxWG5Fd2JzYm1xS3RPRwphRXhFV0diWVlmbmFIaXJ5NGNLYWNDUzlLMEZKdkE4bnF2UUE4ZUxYZ2ZBOUYxbFYrV1BaeWxPT05Wc3dPUE5pCldXY1BzQlg0UGxKVVpZMXViMjRNWC8xeFlhelpPMFNTaXhuTHpSU2hmRThLSVRDcXRRK3NzRlQ0UTlQUURzM00KbmNGUk1NRDRsaFNzRE8xOElwd0ljNmorYnpnNWduNk94QTR5SnFIYzJLRnBad2IrM0NCRFZOMDJqRlhJSFVzcQpEZUlsNTdadTdxYm5hT2VTTUUvTjZjc1Y3MmsrdDdMWGtvVG5KeU9lQjhFQ2dZRUExOW1iU2xvMnAzWGhoakRLClJ5aDJnbVBSSlViVWlpSXZuajRtTSt2Yi9sRUxxb3doWDBHTnlDVVhVU0gyMVBmUGg2WW90VW8xWUswSkRHV2UKWTVGdmhiUW96UzczbzhzMHRjN25nSzdHbmEwMUdud1Q4TVFqMWtJRHFxM1NmWDBvWnd5RVRsVzkwMFR3bENBVgpUNUZLbUdOVjJTWEY0V3Y3Y0lvcjh4eS94bDBDZ1lFQXlZbjJ0ZU1xc21mQnVBMERaVlY1V2FrMnpJSWVsRnhpCmV3RUZwWlRmU2hZa1U0QzF3THhybHBvbWo5M0haZ1F3OEx3ZzNTOVZMbS9KeHdGL0FlVmtISDVTVUpXdG92YW0KUzh4NGVRNFU3TkM5WHhLWlpBQ0M0V1dQck1NWHYrRUQrNktJblE4RmI2Ym5nS05MTCs0cGxRVEZkbkJIYkM0UQpSTGFTbzZDbktlVUNnWUVBek85bk9FWEU1R1BRbHNhV0ZzOTlEVGxXSmsxRW1FM3k1Z3hkMnlnUmZEbFltVGxvCnFmY2tkU1Y2S09iVllzaFJ1cG53eG9kSmZKdHRIdDhRYmJwMHB2NHhTdlpQMnF5aFJBakkxZTJhMTdQTzJuRjUKd1R1SVJ2SHdaMG1Yc3R0MDA3b1htQVJpTVVlZ0h4TURDTU9Lam5xcDFIeS9qdEltTFdpU1o4VWc4MlVDZ1lCTgp4TC8vbGNZZkM2eVQ0ZW1paTZZRTlDZmlLSCsyVGlQdVJRbXh5RTJWWUEvcWJPczFrVCtPNExMcXB2RFBxK1JhCnNLMlp6Qzc1ZVVlS1ZFaDNLZFpFckhZRkJJejVLbVluTDZKNVMvYkZIeE5FQVlCUk4yVkpwcEFYWVR6ajNPZFYKalhWYjdiVHlUWnhkWmlXWVBEV3RmQ2JhT2g5RlhrMEd4dEMwOVVRc0JRS0JnUUNVQ3VuNERsL1owUkpZYW9ZMgpaUEZlc2hmQWZXaWw1ZERneThKUlh3WGtDdSswcGx1b1dXTVY1c21FY3E1QWY1dE1KRDhKeGJvSHFkb05uQTZqCnErYTh1N0w2WnpsMzR4RFFTMHc5UFlEeEFJb0ViWHRWQUxFUkdBMEFaSy9nbENQMmJtTXMxbHFxakVjWDNIZ3oKSmlweWlFc1JKYXI2ZThzVVNkSXZJempZS0E9PQotLS0tLUVORCBQUklWQVRFIEtFWS0tLS0tCg==

	kubectl get svc --namespace traefik-ingress
	NAME                    TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)                      AGE
	ssl-traefik             LoadBalancer   10.150.72.17   <pending>     443:30052/TCP,80:30919/TCP   10s
	ssl-traefik-dashboard   ClusterIP      10.150.97.52   <none>        80/TCP                       11s

	edit /etc/hosts
	192.168.205.11	worker1.dv.kube.io dashboard.traefik.mycluster.net
    192.168.205.12	worker2.dv.kube.io dashboard.traefik.mycluster.net
	
	https://dashboard.traefik.mycluster.net:30052/
	
	To Install Grafana and access via Ingress - with self-signed traeik wildcard domain certificate
	
	kubectl apply -f grafana.yaml
	
	https://grafana.traefik.mycluster.net:30052/
	
	To Install Kibana and access via Ingress - with self-signed kibana domain certificate
	
	sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/mycerts/kibana.traefik.mycluster.net -out /etc/mycerts/traefik.mycluster.net.crt \
    -subj "/C=US/ST=PA/L=PI/O=AU/OU=BU/CN=kibana.traefik.mycluster.net/emailAddress=admin@myclster.net"

	kubectl -n monitor create secret tls kibana-tls \
    --cert=/etc/mycerts/kibana.traefik.mycluster.net.crt \
    --key=/etc/mycerts/kibana.traefik.mycluster.net.key
 
    kubectl apply -f kibana.yaml
	
	https://kibana.traefik.mycluster.net:30052/
	
	helm delete ssl-traefik -n traefik-ingress
	
	