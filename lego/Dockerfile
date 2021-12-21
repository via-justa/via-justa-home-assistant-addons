# https://developers.home-assistant.io/docs/add-ons/configuration#add-on-dockerfile
ARG BUILD_FROM
FROM $BUILD_FROM

ARG LEGO_VERSION
ARG BUILD_ARCH

RUN apk add --no-cache -t deps git make musl-dev go \
    && echo "Building lego version: ${LEGO_VERSION}" \
    && git clone https://github.com/go-acme/lego.git \
    && cd lego \
    && git checkout ${LEGO_VERSION} \
    && go env \
    && CGO_ENABLED=0 GO111MODULE=on go build -v -trimpath -ldflags '-X "main.version=${LEGO_VERSION}"' -o /usr/local/bin/lego ./cmd/lego/ \
    && apk del deps && rm -r /root/go \
    && chmod +x /usr/local/bin/lego

RUN apk add tzdata jq

COPY rootfs /

RUN chmod a+x /run.sh

CMD [ "/run.sh" ]