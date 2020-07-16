FROM ubuntu:14.04

# Copy container configuration
COPY config /config

##########################################   Packages   ############################################
# Copy package list
COPY images/debian/ubuntu/14.04/packages.txt /packages.txt
RUN \
# Upgrade packages
apt-get -y update; \
# Install default packages for distribution
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends $(cat /packages.txt); \
# Delete all cached information
apt-get clean


###########################################    User     ############################################
RUN \
# Create test user
useradd -m -d /home/test -p salSp1wOPp6fk test; \
# Add user to sudo group
usermod -aG sudo test; \
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
COPY images/debian/ubuntu/14.04/configure.sh /configure.sh
RUN \
# Make configuration script runnable
chmod +x configure.sh;

ENV container=docker
STOPSIGNAL SIGRTMIN+3
VOLUME ["/sys/fs/cgroup", "/run", "/tmp"]
CMD ["/configure.sh"]