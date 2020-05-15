FROM ubuntu:16.04

# Ubuntu 16.04 uses systemd as init sytem.
# No further configuration is needed.

# Ubuntu 16.04 base image already has python.
# No further init system configuration needed.

RUN apt-get update && \
    apt-get install -y \
        sudo \
    sudo apt-get install -y \
        openssh-server

CMD ["/lib/systemd/systemd"]