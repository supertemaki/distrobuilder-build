#!/usr/bin/env bash
set -eux

for file in ./images/*.{yml,yaml}; do
	[[ -e "$file" ]] || continue
	distrobuilder build-lxd "$file" distrobuilder.output --cache-dir distrobuilder.cache \
		--type=unified \
		--options=image.architecture=x86_64 \
		--options=image.release=38 \
done
