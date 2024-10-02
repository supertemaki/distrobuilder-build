FROM docker.io/golang:1.23.2-alpine3.20 AS build-stage

WORKDIR /go/src/app

ADD https://github.com/lxc/distrobuilder.git#ed79e198e5c51e1da82e3dad0dda25aaf0e79c35 .

RUN <<EOF
apk add --no-cache \
    gcc \
    musl-dev
go install -v ./...
EOF



FROM docker.io/alpine:3.20.3 AS final-stage

COPY --from=build-stage /go/bin/* /usr/local/bin/

WORKDIR /workdir

RUN <<EOF
apk add --no-cache \
    bash \
    rsync \
    squashfs-tools \
    tar \
    xz
EOF

ENV TYPE="split"

ENV ARCHITECTURE=""
ENV RELEASE=""
ENV VARIANT=""

COPY --chmod=755 <<"EOF" /usr/local/bin/entrypoint.sh
#!/usr/bin/env bash

set -euxo pipefail

# Check if the images directory exists
if [[ ! -d images ]]; then
    printf '%s\n' "Directory 'images' not found."
    exit 1
fi

# Loop through all *.yml and *.yaml files
shopt -s nullglob
for file in images/*.{yml,yaml}; do
    args=(
        build-incus "${file}"

        # Directory to output images
        image-output

        # Without this cache directory the overlayfs don't work
        --cache-dir cache

        --type="${TYPE}"
        $([[ -n "${ARCHITECTURE}" ]] && printf '%s' --options=image.architecture="${ARCHITECTURE}" || true)
        $([[ -n "${RELEASE}" ]] && printf '%s' --options=image.release="${RELEASE}" || true)
        $([[ -n "${VARIANT}" ]] && printf '%s' --options=image.variant="${VARIANT}" || true)
    )
    distrobuilder "${args[@]}"
done
shopt -u nullglob

exit 0
EOF

VOLUME [ "/workdir" ]

ENTRYPOINT [ "entrypoint.sh" ]
