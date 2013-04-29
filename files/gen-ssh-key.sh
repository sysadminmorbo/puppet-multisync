#! /bin/sh

if [ "x$1" = "x" -o "x$2" = "x" ]; then
  echo "$0 <fqdn> <confdir>"
  exit 1
fi

conf=`mktemp`
cat >>"$conf" <<EOF
[ req ]
prompt = no
distinguished_name = req_distinguished_name

[ req_distinguished_name ]
CN = $1
EOF

openssl genrsa \
	-out "$2/csync2_ssl_key.pem" 1024 || exit 1
openssl req -new \
	-key "$2/csync2_ssl_key.pem" \
	-out "$2/csync2_ssl_cert.csr" \
	-config "$conf" || exit 1
openssl x509 -req -days 600 \
	-in "$2/csync2_ssl_cert.csr" \
	-signkey "$2/csync2_ssl_key.pem" \
	-out "$2/csync2_ssl_cert.pem" || exit 1

rm -f "${conf}" "$2/csync2_ssl_cert.csr"
