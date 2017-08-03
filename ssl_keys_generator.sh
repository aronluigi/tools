#/bin/bash
openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
openssl rsa -passin pass:x -in server.pass.key -out server.key
rm server.pass.key

cat > openssl.cnf <<-EOF
  [req]
  distinguished_name = req_distinguished_name
  x509_extensions = v3_req
  prompt = no
  [req_distinguished_name]
  CN = *.cpa.local
  [v3_req]
  keyUsage = keyEncipherment, dataEncipherment
  extendedKeyUsage = serverAuth
  subjectAltName = @alt_names
  [alt_names]
  DNS.1 = *.cpa.local
EOF

openssl req \
        -new \
        -newkey rsa:2048 \
        -sha1 \
        -days 3650 \
        -nodes \
        -x509 \
        -keyout server.key \
        -out server.crt \
        -config openssl.cnf

rm openssl.cnf
