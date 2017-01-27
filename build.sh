#!/bin/sh

set -e

make checkout

tag=$(cd sources;git tag -l --points-at HEAD)
if ! test -z "$tag"; then
	VERSION=${tag} make build
	VERSION=${tag} make upload
	VERSION=${tag} make clean
fi

branch=$(cd sources;git rev-parse --abbrev-ref HEAD)
if ! "$branch" = "HEAD"; then
	VERSION=${branch} make build
	VERSION=${branch} make upload
	VERSION=${branch} make clean
fi
