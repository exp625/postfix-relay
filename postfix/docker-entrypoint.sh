#!/bin/sh
for config in /config/*
do
  envsubst < $config > /etc/postfix/${config##*/}
done

/etc/postfix/post-install meta_directory=/etc/postfix create-missing
postfix set-permissions
