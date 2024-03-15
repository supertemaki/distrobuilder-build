#!/usr/bin/env bash
set -eux

# Loop all the *.yml and *yaml files
# inside the images directory relative
# to working directory
tree
for file in ./images/*.{yml,yaml}; do
    # Verify if output is not empty and continue
    [[ -e "$file" ]] || continue
    args=(
        build-incus "$file"

        # Directory to output images
        distrobuilder.output

        # Without this cache directory the overlayfs don't work
        --cache-dir distrobuilder.cache

        # Need to adjust below to variables
        --type=unified
        --options=image.architecture=x86_64
        --options=image.release=39
        --options=image.variant=podman
    )
    distrobuilder "${args[@]}"
done
