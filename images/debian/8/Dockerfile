FROM debian:jessie

RUN apt-get update && \
    apt-get install -y \
        sudo && \
    sudo apt-get install -y \
        openssh-server \
        python \
        systemd

CMD ["/lib/systemd/systemd"]