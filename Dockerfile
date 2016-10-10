FROM alpine:latest

RUN apk update && apk upgrade

RUN apk add --no-cache samba-dc krb5 && rm -rf /var/cache/apk/*

VOLUME /etc/samba
VOLUME /var/lib/samba

EXPOSE 139 445

CMD /usr/sbin/samba -i

