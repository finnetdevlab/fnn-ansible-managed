FROM debian:buster

RUN apt-get update && \
    apt-get install -y \
        sudo && \
    sudo apt-get install -y \
        openssh-server \
        python3 \
        systemd

CMD ["/lib/systemd/systemd"]