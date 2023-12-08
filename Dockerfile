# checkov:skip=CKV_DOCKER_3:Ensure that a user for the container has been created
# kics-scan ignore-line
FROM alpine:3.19.0

# kics-scan ignore-line
RUN \
    apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing \
        distrobuilder && \
    apk add --no-cache \
        bash \
        git \
        rsync \
        tar

RUN \
    mkdir /workdir

WORKDIR /workdir

COPY entrypoint.sh /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
