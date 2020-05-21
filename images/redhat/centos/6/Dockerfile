FROM centos:6

# Copy container configuration
COPY config /config
COPY images/redhat/centos/6/setup.sh setup.sh

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
# Enable ssh server
chkconfig sshd on;

RUN \
########################################## Configuration ###########################################
# Make configuration script runnable
chmod +x setup.sh;

ENTRYPOINT [ "./setup.sh" ]