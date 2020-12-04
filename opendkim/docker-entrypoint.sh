#!/bin/sh
for config in /config/*
do
  envsubst < $config > /etc/opendkim/${config##*/}
done


if [ ! -d "/tmp/keys/${DOMAIN}" ]; then
    mkdir -p /tmp/keys/${DOMAIN}
    cd /tmp/keys/${DOMAIN}
    opendkim-genkey -s default -d ${DOMAIN}
    chown opendkim:opendkim default.private
fi


cp -R /tmp/keys /etc/opendkim
chown -R  opendkim:opendkim /etc/opendkim/keys
exec "$@"
