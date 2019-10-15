#
# Dockerfile for wireguard
#

FROM alpine
LABEL maintainer="Ricky Li <cnrickylee@gmail.com>"

RUN set -ex \
 && apk add --no-cache --virtual .build-deps \
    build-base \
    git \
    linux-headers \
    libmnl-dev \
 && TMP=`mktemp -d` \
 && cd ${TMP} \
 && git clone https://git.zx2c4.com/WireGuard.git \
 && cd WireGuard \
 && TAG=`git tag -l | sort -r | head -n 1` \
 && git checkout tags/${TAG} -b ${TAG} \
 && cd src \
 && make \
 && make install \
 && rm -rf ${TMP} \
# && apk del .build-deps \
 && wg --help \
 && wg-quick --help

USER root

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "sh", "/entrypoint.sh" ]
