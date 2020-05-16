FROM centos:7
ENV container docker

# Centos 7 base image already has python.
# No further init system configuration needed.

# Install systemd -- See https://hub.docker.com/_/centos/
RUN yum -y update; \
    yum clean all; \
    ( \
        cd /lib/systemd/system/sysinit.target.wants/; \
        for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done \
    ); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*; \
    yum -y install sudo openssh-server openssh-clients \
    systemctl enable sshd

# Ensure environment variables are updated before every command
COPY utils/update-env.sh /etc/profile.d/update-env.sh

CMD ["/usr/lib/systemd/systemd"]