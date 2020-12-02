#!/bin/sh
for config in /config/*
do
  envsubst < $config > /etc/postfix/${config##*/}
done
usermod -a -G opendkim postfix
postmap /etc/postfix/NetworkTable
/etc/postfix/post-install meta_directory=/etc/postfix create-missing
postfix set-permissions
postfix start-fg
