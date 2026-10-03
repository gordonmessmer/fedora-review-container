FROM fedora:44

RUN dnf install -y sssd-client sudo
RUN dnf install -y fedora-packager fedora-packager-kerberos fedora-review mock
RUN dnf install -y rust2rpm pyp2rpm pyp2spec
RUN dnf install -y python3-pyyaml mock-scm

RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel \
 && chmod 0440 /etc/sudoers.d/wheel

# Running mock is a primary purpose of this container, so the entrypoint makes the
# invoking user a mock-group member (see entrypoint.sh) rather than leaving it as
# a per-user setup step.
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 0755 /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
