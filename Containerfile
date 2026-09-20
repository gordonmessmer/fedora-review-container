FROM fedora:44

RUN dnf install -y sssd-client sudo
RUN dnf install -y fedora-packager fedora-packager-kerberos fedora-review mock
RUN dnf install -y rust2rpm pyp2rpm pyp2spec
RUN dnf install -y python3-pyyaml mock-scm

RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel \
 && chmod 0440 /etc/sudoers.d/wheel

CMD ["/bin/bash"]
