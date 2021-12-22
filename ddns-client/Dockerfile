# https://developers.home-assistant.io/docs/add-ons/configuration#add-on-dockerfile

ARG BUILD_FROM
FROM $BUILD_FROM

ARG DDNS_CLIENT_VERSION
ARG BUILD_ARCH

RUN \
    set -x && \
    if [ "${BUILD_ARCH}" = "armhf" ]; then \
        curl -q -SL https://github.com/go-acme/ddns-client/releases/download/${DDNS_CLIENT_VERSION}/ddns-client_${DDNS_CLIENT_VERSION}_linux_armv7.tar.gz | tar xzf - -C /usr/local/bin; \
    elif [ "${BUILD_ARCH}" = "aarch64" ]; then \
        curl -q -SL https://github.com/go-acme/ddns-client/releases/download/${DDNS_CLIENT_VERSION}/ddns-client_${DDNS_CLIENT_VERSION}_linux_arm64.tar.gz | tar xzf - -C /usr/local/bin; \
    elif [ "${BUILD_ARCH}" = "i386" ]; then \
        curl -q -SL https://github.com/go-acme/ddns-client/releases/download/${DDNS_CLIENT_VERSION}/ddns-client_${DDNS_CLIENT_VERSION}_linux_386.tar.gz | tar xzf - -C /usr/local/bin; \
    else \
        curl -q -SL https://github.com/go-acme/ddns-client/releases/download/${DDNS_CLIENT_VERSION}/ddns-client_${DDNS_CLIENT_VERSION}_linux_${BUILD_ARCH}.tar.gz | tar xzf - -C /usr/local/bin; \
    fi \
    && ddns-client --version

RUN apk add ca-certificates

# Copy root filesystem
COPY rootfs/run.sh /

RUN chmod a+x /run.sh

CMD [ "/run.sh" ]