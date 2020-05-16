FROM ubuntu:20.04

# Ubuntu 20.04 base image already has python.
# No further init system configuration needed.

RUN apt update && \
    apt install -y \
        sudo \
    sudo apt install -y \
        openssh-server \
        systemd

# Ensure environment variables are updated before every command
COPY utils/update-env.sh /etc/profile.d/update-env.sh

CMD ["/lib/systemd/systemd"]