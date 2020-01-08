#
# Dockerfile for wireguard
#

FROM alpine
LABEL maintainer="Ricky Li <cnrickylee@gmail.com>"

RUN set -ex \
 && apk add --no-cache -U wireguard-tools \
 && which wg \
 && wg --help \
 && which wg-quick \
 && wg-quick --help

USER root

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "sh", "/entrypoint.sh" ]
