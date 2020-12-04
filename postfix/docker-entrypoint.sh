#!/bin/sh
for config in /config/*
do
  envsubst < $config > /etc/postfix/${config##*/}
done

postmap /etc/postfix/NetworkTable
postfix set-permissions
postfix start-fg
