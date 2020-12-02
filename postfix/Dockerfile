FROM alpine:latest

RUN apk upgrade --update \
 && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
 && apk --no-progress --no-cache add postfix postfix-pcre cyrus-sasl-plain cyrus-sasl-login gettext \
 && rm -rf /var/cache/apk/* \
 && mkdir /etc/supervisor.d/ \
 && echo "*.* -/dev/stdout" >> /etc/syslog.conf

RUN postconf -d | grep mail_version

COPY ./supervisord.conf /etc/supervisor.d/supervisord.conf
COPY ./docker-entrypoint.sh /entrypoint.sh
COPY ./postfix.sh /postfix.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
CMD /usr/bin/supervisord -c /etc/supervisor.d/supervisord.conf
