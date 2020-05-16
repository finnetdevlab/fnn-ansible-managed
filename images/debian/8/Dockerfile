FROM debian:jessie

RUN apt-get update && \
    apt-get install -y \
        sudo && \
    sudo apt-get install -y \
        openssh-server \
        python \
        systemd

# Ensure environment variables are updated before every command
COPY utils/update-env.sh /etc/profile.d/update-env.sh

CMD ["/lib/systemd/systemd"]