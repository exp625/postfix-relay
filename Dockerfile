FROM ubuntu:20.04

WORKDIR /usr/src/app

RUN apt-get update && apt-get upgrade -y \
&& export DEBIAN_FRONTEND=noninteractive \
&& apt-get install -y --no-install-recommends --no-install-suggests \
python3 python3-pip git bash postfix postfix-pcre opendkim opendkim-tools \
&& pip3 install --upgrade pip

RUN pip3 install socrate

COPY config /config
COPY start.py /start.py

EXPOSE 25/tcp 10025/tcp

WORKDIR /etc/opendkim
RUN echo 'SOCKET="inet:8891@localhost"' >> /etc/default/opendkim

RUN echo ${DOMAIN}

WORKDIR /etc/opendkim/keys/${DOMAIN}
RUN opendkim-genkey -r -d ${DOMAIN} \
    && chown opendkim.opendkim default.private \
    && echo 'default._domainkey.${DOMAIN} ${DOMAIN}:default:/etc/opendkim/keys/${DOMAIN}/default.private' >> /etc/opendkim/SigningTable \
    && echo '${DOMAIN} default._domainkey.${DOMAIN}' >> /etc/opendkim/SigningTable \

WORKDIR /usr/src/app
RUN /config.py
CMD /start.py

HEALTHCHECK --start-period=350s CMD echo QUIT|nc localhost 25|grep "220 .* ESMTP Postfix"
