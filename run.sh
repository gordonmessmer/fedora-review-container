#!/bin/sh
podman run --rm -it --privileged \
 -v /etc/nsswitch.conf:/etc/nsswitch.conf \
 -v /etc/krb5.conf.d/kcm_default_ccache:/etc/krb5.conf.d/kcm_default_ccache \
 -v /run/.heim_org.h5l.kcm-socket:/run/.heim_org.h5l.kcm-socket \
 -v /var/lib/sss:/var/lib/sss \
 -v ${HOME}/.config:/root/.config:z \
 -v ${HOME}/.gitconfig:/root/.gitconfig:z \
 -v /home/gmessmer/git:/home/gmessmer/git:z \
 -w /home/gmessmer/git \
 fedora-review:44
