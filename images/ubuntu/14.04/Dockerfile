FROM ubuntu:14.04

# Ubuntu 14.04 uses upstart as init sytem.
# No further configuration is needed.

# Ubuntu 14.04 base image already has python.
# No further init system configuration needed.

RUN apt-get update && \
    apt-get install -y \
        sudo \
    sudo apt-get install -y \
        openssh-server

# Ensure environment variables are updated before every command
COPY utils/update-env.sh /etc/profile.d/update-env.sh