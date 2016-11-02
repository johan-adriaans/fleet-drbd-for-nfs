FROM johanadriaans/docker-base-alpine:3.4
MAINTAINER Johan Adriaans <johan@shoppagina.nl>

RUN apk add --update ssmtp mailx drbd-utils perl e2fsprogs

COPY files/drbd.d /etc/drbd.d
COPY service /etc/service
COPY files/ssmtp.conf /etc/ssmtp/ssmtp.conf
COPY files/aliases /etc/aliases

ENTRYPOINT ["/sbin/dumb-init", "/sbin/runsvdir", "-P", "/etc/service"]
