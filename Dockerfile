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
    bash \
 && TMP=`mktemp -d` \
 && cd ${TMP} \
 && git clone https://git.zx2c4.com/WireGuard.git \
 && cd WireGuard \
 && TAG=`git tag -l | sort -r | head -n 1` \
 && git checkout tags/${TAG} -b ${TAG} \
 && cd src \
 && make tools \
 && make -C tools install \
 && install tools/wg-quick/linux.bash /usr/bin/wg-quick \
 && ls -lh /usr/bin/wg /usr/bin/wg-quick \
 && rm -rf ${TMP} \
 && apk del .build-deps \
 && apk add --no-cache bash \
    $(scanelf --needed --nobanner /usr/bin/wg /usr/bin/wg-quick | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' | sort -u) \
 && which wg \
 && wg --help \
 && which wg-quick \
 && cat `which wg-quick` \
 && wg-quick --help

USER root

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "sh", "/entrypoint.sh" ]
