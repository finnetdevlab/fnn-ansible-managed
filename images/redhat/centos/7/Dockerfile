FROM centos:7

# Copy container configuration
COPY config /config
COPY images/redhat/centos/7/setup.sh setup.sh

RUN \
##########################################   Packages   ############################################
# Update packages
yum -y update; \
# Install required packages
yum -y install sudo iptables-services openssh-server openssh-clients;

RUN \
###########################################    User     ############################################
# Create test user
useradd -m -d /home/test -p salSp1wOPp6fk test; \
usermod -aG wheel test; \
mkdir /home/test/.ssh; \
# Create RSA key for test user
cat /dev/zero | ssh-keygen -q -P "" -f /home/test/.ssh/id_rsa; \
# Authorize config key for test user
cat /config/keys/id_rsa.pub >> /home/test/.ssh/authorized_keys; \
# SSH login fix. Otherwise user is kicked off after login
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd;

RUN \
##########################################  Environment  ###########################################
# Add environment variable configuration script
cp /config/update-env.sh /etc/profile.d/update-env.sh;

RUN \
##########################################    Process    ###########################################
# Enable systemd -- See https://hub.docker.com/_/centos/
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*; \
# Enable ssh server
systemctl enable sshd;

RUN \
########################################## Configuration ###########################################
# Make configuration script runnable
chmod +x setup.sh; \
cp /config/sys-setup.service /etc/systemd/system/sys-setup.service; \
systemctl enable sys-setup;

VOLUME [ "/sys/fs/cgroup" ]
CMD [ "/usr/sbin/init" ]