#!/usr/bin/env bash
set -eux

for file in ./images/*.{yml,yaml}; do
	if [[ -e $file ]]; then
		distrobuilder build-lxd $file distrobuilder.output \
			--type=unified \
			--options=image.architecture=x86_64 \
			--options=image.release=38 \
			--options=image.variant=podman
	fi
done
