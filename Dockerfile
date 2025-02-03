FROM ubuntu:jammy-20240911.1

ARG PRIVATE_KEY

RUN useradd -ms /bin/bash mmr -G sudo

ENV TZ=Europe/Rome \
    DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y build-essential \
    chrpath \
    cpio \
    debianutils \
    diffstat \
    file \
    gawk \
    gcc \
    git \
    iputils-ping \
    libacl1 \
    liblz4-tool \
    locales \
    python3 \
    python3-git \
    python3-jinja2 \
    python3-pexpect \
    python3-pip \
    python3-subunit \
    socat \
    texinfo \
    unzip \
    wget \
    xz-utils \
    zstd \
    openssh-server \
    libtinfo5 \
    xvfb \
    x11-utils \
    dbus-x11 \
    sudo \
    gettext-base \
    vim \
    tmux

RUN locale-gen "en_US.UTF-8"

RUN mkdir /var/run/sshd
RUN echo "mmr:mmr" | chpasswd
COPY ./sshd_config /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

COPY ./.ssh/${PRIVATE_KEY}.pub /home/mmr/.ssh/
COPY ./.ssh/${PRIVATE_KEY} /home/mmr/.ssh/
COPY ./config /home/mmr/.ssh

RUN chown -R mmr:mmr /home/mmr/.ssh && \
    sed -i "s/private_key/${PRIVATE_KEY}/g" /home/mmr/.ssh/config

EXPOSE 22

USER mmr
WORKDIR /home/mmr

# if you want add user usefull-script

USER root

# start sshd
CMD ["/usr/sbin/sshd", "-D"]