#!/bin/sh
# Make the invoking user a real member of the mock group in the group database.
#
# The container grants the mock group via podman --group-add, which only sets the
# process's supplementary groups. mock's passwordless PAM rule
# (/etc/pam.d/mock: "pam_succeed_if user ingroup mock") checks the group
# database, not process groups, so without database membership mock falls through
# to a password prompt the (SSSD) account cannot satisfy. The user is resolved at
# runtime, so this cannot be baked into the image at build time; add it here with
# id -un (works for any user). The edit persists for the container's lifetime, so
# podman exec sessions inherit it.
sudo gpasswd -a "$(id -un)" mock >/dev/null 2>&1 || true

exec "$@"
