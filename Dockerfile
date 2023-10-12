FROM alpine:3.18.4

RUN \
  apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing \
	   distrobuilder

RUN \
  apk add --no-cache \
	   bash \
	   git \
	   rsync \
	   tar

RUN \
  mkdir /data

WORKDIR /data

COPY entrypoint.sh /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
