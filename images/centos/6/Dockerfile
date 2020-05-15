FROM centos:6

# Centos 6 base image uses init.d as init system.
# No further init system configuration needed.

# Centos 6 base image already has python.
# No further init system configuration needed.

RUN yum -y install \
        sudo \
        openssh-server openssh-clients && \
    chkconfig sshd on