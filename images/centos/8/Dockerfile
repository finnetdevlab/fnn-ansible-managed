FROM centos:8

# Centos 8 base image uses systemd as init system.
# No further init system configuration needed.

# Install and configure sudo and ssh
RUN dnf -y install \
        sudo \
        openssh-server openssh-clients \
        python3

CMD ["/usr/sbin/init"]