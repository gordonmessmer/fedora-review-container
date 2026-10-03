#!/bin/sh
# Run as an unprivileged user: mock refuses to run as real root, and some
# test suites assert that unauthorized file access fails, which never happens
# as root. The user joins mock (to run mock) and wheel (passwordless sudo,
# used to install packages at runtime).
#
# --group-add only sets the process's supplementary groups, which is not enough
# for mock's passwordless PAM rule; the image entrypoint makes the invoking user
# a real mock-group member in the database (see entrypoint.sh).
podman run --rm -it --privileged \
 --userns=keep-id \
 --group-add=wheel,mock \
 -v /etc/nsswitch.conf:/etc/nsswitch.conf \
 -v /etc/krb5.conf.d/kcm_default_ccache:/etc/krb5.conf.d/kcm_default_ccache \
 -v /run/.heim_org.h5l.kcm-socket:/run/.heim_org.h5l.kcm-socket \
 -v /var/lib/sss:/var/lib/sss \
 -v ${HOME}/.config:/home/gmessmer/.config \
 -v ${HOME}/.gitconfig:/home/gmessmer/.gitconfig \
 -v ${HOME}/git:/home/gmessmer/git \
 -w /home/gmessmer/git \
 fedora-review:44
