FROM centos:6

# Copy container configuration
COPY config /config

##########################################   Packages   ############################################
# Copy package list
COPY images/redhat/centos/6/packages.txt /packages.txt
RUN \
# Install EPEL(Extra Packages for Enterprise Linux) packages. EPEL includes open source packages
# like networking tools, sysadmin tools, programming, monitoring and so on.
yum -y install epel-release; \
# Install default packages for distribution
yum -y install $(cat /packages.txt); \
# Delete all cached information
yum clean all;


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
chmod 600 /home/test/.ssh/authorized_keys;


########################################## Configuration ###########################################
# Copy configure
COPY images/redhat/centos/6/configure.sh /configure.sh
RUN \
# Make configuration script runnable
chmod +x /configure.sh; \
# SSH login fix. Otherwise user is kicked off after login
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd;

STOPSIGNAL SIGRTMIN+3
VOLUME ["/sys/fs/cgroup", "/run", "/tmp"]
CMD ["/configure.sh"]