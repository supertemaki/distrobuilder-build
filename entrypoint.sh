#!/usr/bin/env bash
set -eux

# Loop all the *.yml and *yaml files
# inside the images directory relative
# to working directory
for file in ./images/*.{yml,yaml}; do
        # Verify if output is not empty and continue
	[[ -e "$file" ]] || continue
	distrobuilder build-lxd "$file" \
                distrobuilder.output \ # Directory to output images
                --cache-dir distrobuilder.cache \ # Without this cache directory the overlayfs don't work
		--type=unified \ # Need to adjust below to variables
		--options=image.architecture=x86_64 \
		--options=image.release=38
done
