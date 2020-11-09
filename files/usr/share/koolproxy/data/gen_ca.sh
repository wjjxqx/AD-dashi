#!/bin/sh

if [ ! -f openssl.cnf ]; then
	logger -t "【koolproxy】" "Cannot found openssl.cnf"
	exit 1
fi
if [ -f /tmp/7620koolproxy/data/private/ca.key.pem ]; then
	logger -t "【koolproxy】" "已经有证书了！"
else
	logger -t "【koolproxy】" "生成证书中..."

	#step 1, root ca
	mkdir -p certs private
	rm -f index.txt serial private/ca.key.pem
	chmod 700 private
	touch index.txt
	echo 1000 > serial
	openssl genrsa -aes256 -passout pass:koolshare -out private/ca.key.pem 2048
	chmod 400 private/ca.key.pem
	openssl req -config openssl.cnf -passin pass:koolshare \
		-subj "/C=CN/ST=Beijing/L=KP/O=KoolProxy inc/CN=koolproxy.com" \
		-key private/ca.key.pem \
		-new -x509 -days 7300 -sha256 -extensions v3_ca \
		-out certs/ca.crt

	#step 2, domain rsa key
	openssl genrsa -aes256 -passout pass:koolshare -out private/base.key.pem 2048
	logger -t "【koolproxy】" "证书生成完毕..."
fi
