[ -d certs ] || mkdir certs

country=US
state=PA
locality=PI
organization=AU
organizationalunit=IT
email=administrator@myclster.net
commonname=*.local.mycluster.net

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout certs/local.key -out certs/local.crt \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit\
/CN=$commonname/emailAddress=$email"
