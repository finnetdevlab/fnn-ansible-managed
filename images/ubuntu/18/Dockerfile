FROM ubuntu:18.04

# Ubuntu 18.04 base image already has python.
# No further init system configuration needed.

RUN apt update && \
    apt install -y \
        sudo \
    sudo apt install -y \
        openssh-server \
        systemd

CMD ["/lib/systemd/systemd"]