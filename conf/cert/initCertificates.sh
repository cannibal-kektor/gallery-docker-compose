#!/bin/sh
set -e

if [ -e gateway_certs/gateway-server.pem ]; then
  echo "Certificates already exists."
  exit 0;
fi

CONF_FILE="../conf/openssl.conf"

# API GATEWAY SECTION
echo "Generating api gateway server certificate"

GATEWAY_DIR="gateway_certs"
cd "$GATEWAY_DIR"

# Generate RSA private key
openssl genrsa -out gateway-server.key 4096
# Generate self-signed certificate using [gateway] section of the openssl.conf
openssl req -x509 -new -key gateway-server.key \
    --days 1024 \
    -out gateway-server.pem \
    -section gateway \
    -config "$CONF_FILE"

echo "Certificate for Gateway api server generated successfully at ${PWD}"

cd ..

# JWT AUTH SECTION
echo "Generating jwt authentication server keys"

JWT_AUTH_KEYS_DIR="auth_keys"
JWT_PUB_KEY_DIR="auth_pubkey"
cd "$JWT_AUTH_KEYS_DIR"

# Generate RSA private key
openssl genrsa -out auth-server.key 4096
# Generate self-signed certificate using [auth] section of the openssl.conf
openssl req -x509 -new -key auth-server.key \
    --days 1024 \
    -out auth-server.pem \
    -section auth \
    -config "$CONF_FILE"

# Extract public key from the private key
openssl rsa -in auth-server.key \
    -pubout -out "../$JWT_PUB_KEY_DIR/auth-pubkey.pem"

echo "Jwt authentication keys were generated successfully"

cd ..

echo "Applying file permissions"
find $GATEWAY_DIR $JWT_AUTH_KEYS_DIR $JWT_PUB_KEY_DIR \
    -type f \( -name "*.pem" -o -name "*.key" \) \
    -exec chmod 644 {} \;

echo "All keys and certificates generated successfully."
