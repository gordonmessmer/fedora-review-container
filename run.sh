#!/bin/sh
# Run as an unprivileged user: mock refuses to run as real root, and some
# test suites assert that unauthorized file access fails, which never happens
# as root. The user joins mock (to run mock) and wheel (passwordless sudo,
# used to install packages at runtime).
#
# --group-add only sets the process's supplementary groups; it does not make the
# user a member in the group database. mock's passwordless PAM rule
# (/etc/pam.d/mock: "pam_succeed_if user ingroup mock") checks the database, not
# the process groups, so without database membership running mock would fall
# through to a password prompt the (SSSD) account cannot satisfy. The startup
# command below adds the invoking user to the mock group in the container's
# /etc/group; because it uses `id -un` it works for any user, and the edit
# persists for the life of the container, so `podman exec` sessions inherit it.
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
 fedora-review:44 \
 bash -c 'sudo gpasswd -a "$(id -un)" mock >/dev/null; exec bash'
