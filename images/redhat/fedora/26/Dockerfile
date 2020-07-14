FROM fedora:26

# Copy container configuration
COPY config /config

##########################################   Packages   ############################################
# Copy package list
COPY images/redhat/fedora/26/packages.txt /packages.txt
RUN \
# Upgrade packages
dnf -y upgrade; \
# Coreutils conflicts with coreutils-single. Install with allowerasing
dnf -y --allowerasing install coreutils; \
# Install default packages for distribution
dnf -y --setopt=install_weak_deps=false install $(cat /packages.txt); \
# Delete all cached information
dnf clean all


###########################################    User     ############################################
RUN \
# Create test user
useradd -m -d /home/test -p salSp1wOPp6fk test; \
# Add user to sudo group
usermod -aG wheel test; \
# Create ssh folder
mkdir /home/test/.ssh; \
# Create RSA key for test user
cat /dev/zero | ssh-keygen -t rsa -q -P "" -f /home/test/.ssh/id_rsa; \
# Authorize test user to self ssh
cat /home/test/.ssh/id_rsa.pub >> /home/test/.ssh/authorized_keys; \
# Authorize config key for test user
cat /config/keys/id_rsa.pub >> /home/test/.ssh/authorized_keys; \
# Set ownership and permissions for test user
chown -R test /home/test && \
chmod 755 /home/test && \
chmod 700 /home/test/.ssh && \
chmod 644 /home/test/.ssh/id_rsa.pub && \
chmod 600 /home/test/.ssh/id_rsa && \
chmod 600 /home/test/.ssh/authorized_keys; \
# Create ssh folder
mkdir /root/.ssh; \
# Authorize config key for root user
cat /config/keys/id_rsa.pub >> /root/.ssh/authorized_keys; \
chmod 700 /root/.ssh && \
chmod 600 /root/.ssh/authorized_keys;


########################################## Configuration ###########################################
# Copy configure
COPY images/redhat/fedora/26/configure.sh /configure.sh
RUN \
# Make configuration script runnable
chmod +x configure.sh; \
# Enable systemd -- See https://hub.docker.com/_/centos/
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*; \
# SSH login fix. Otherwise user is kicked off after login
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd; \
sed 's@account\s*required\s*pam_nologin.so@account optional pam_nologin.so@g' -i /etc/pam.d/sshd;

ENV container=docker
STOPSIGNAL SIGRTMIN+3
VOLUME ["/sys/fs/cgroup", "/run", "/tmp"]
CMD ["/configure.sh"]