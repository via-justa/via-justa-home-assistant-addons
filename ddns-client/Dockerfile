# https://developers.home-assistant.io/docs/add-ons/configuration#add-on-dockerfile

ARG BUILD_FROM
FROM $BUILD_FROM

ARG DDNS_CLIENT_VERSION
ARG BUILD_ARCH

RUN apk add --no-cache -t deps git make musl-dev go \
    && echo "Building ddns-client version: ${DDNS_CLIENT_VERSION}" \
    && git clone https://github.com/via-justa/ddns-client.git \
    && cd ddns-client \
    && git checkout ${DDNS_CLIENT_VERSION} \
    && go env \
    && go build -v -ldflags="-s -w -X 'main.appVersion=${DDNS_CLIENT_VERSION}'" -o /usr/local/bin/ddns-client \
    && apk del deps && rm -r /root/go \
    && chmod +x /usr/local/bin/ddns-client

RUN apk add ca-certificates

# Copy root filesystem
COPY rootfs/run.sh /

RUN chmod a+x /run.sh

CMD [ "/run.sh" ]