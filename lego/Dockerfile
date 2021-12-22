# https://developers.home-assistant.io/docs/add-ons/configuration#add-on-dockerfile
ARG BUILD_FROM
FROM $BUILD_FROM

ARG LEGO_VERSION
ARG BUILD_ARCH

RUN \
    set -x && \
    if [ "${BUILD_ARCH}" = "armhf" ]; then \
        curl -q -SL https://github.com/go-acme/lego/releases/download/${LEGO_VERSION}/lego_${LEGO_VERSION}_linux_armv7.tar.gz | tar xzf - -C /usr/local/bin; \
    elif [ "${BUILD_ARCH}" = "aarch64" ]; then \
        curl -q -SL https://github.com/go-acme/lego/releases/download/${LEGO_VERSION}/lego_${LEGO_VERSION}_linux_arm64.tar.gz | tar xzf - -C /usr/local/bin; \
    else \
        curl -q -SL https://github.com/go-acme/lego/releases/download/${LEGO_VERSION}/lego_${LEGO_VERSION}_linux_${BUILD_ARCH}.tar.gz | tar xzf - -C /usr/local/bin; \
    fi \
    && lego --version

RUN apk add tzdata jq

COPY rootfs /

RUN chmod a+x /run.sh

CMD [ "/run.sh" ]