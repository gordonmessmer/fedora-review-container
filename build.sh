#!/bin/sh
dnfcache=${HOME}/.cache/fedora-container-dnf/44/var/cache/libdnf5
mkdir -p "$dnfcache"
podman pull fedora:44
podman build -t fedora-review:44 -v "$dnfcache":/var/cache/libdnf5:z .
