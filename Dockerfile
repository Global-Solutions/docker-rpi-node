FROM resin/rpi-raspbian:jessie-20181024

MAINTAINER Global-solutions

ENV NODE_VERSION=10.12.0 \
    ARCH=armv7l

RUN DEPS="ca-certificates curl" && \
    apt-get update && apt-get install -y --no-install-recommends $DEPS && \
    set -ex && for key in \
      94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
      B9AE9905FFD7803F25714661B63B535A4C206CA9 \
      77984A986EBC2AA786BC0F66B01FBB92821C587A \
      71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
      FD3A5288F042B6850C66B31F09FE44734EB7990E \
      8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
      C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
      DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    ; do \
      gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
      gpg --keyserver keyserver.pgp.com --recv-keys "$key" || \
      gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
    done && \
    NODE_FILENAME="node-v$NODE_VERSION-linux-$ARCH.tar.gz" && \
    curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/$NODE_FILENAME" && \
    curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" && \
    gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc && \
    grep " $NODE_FILENAME\$" SHASUMS256.txt | sha256sum -c - && \
    tar -xzf "$NODE_FILENAME" -C /usr/local --strip-components=1 && \
    rm "$NODE_FILENAME" SHASUMS256.txt SHASUMS256.txt.asc && \
    apt-get remove --purge -y $DEPS && \
    rm -rf /var/lib/apt/lists/* /tmp/* && \
    apt-get clean && \
    apt-get autoclean && apt-get autoremove -y
