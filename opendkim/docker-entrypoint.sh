#!/bin/sh
for config in /config/*
do
  envsubst < $config > /etc/opendkim/${config##*/}
done


if [ ! -d "/tmp/keys/${DOMAIN}" ]; then
    mkdir -p /tmp/keys/${DOMAIN}
    cd /tmp/keys/${DOMAIN}
    opendkim-genkey -s mail -d ${DOMAIN}
    chown opendkim:opendkim mail.private
fi


cp -R /tmp/keys /etc/opendkim/keys
chown -R  opendkim:opendkim /etc/opendkim/keys
exec "$@"
