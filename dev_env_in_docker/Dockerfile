FROM ubuntu:latest

ENV DOCKER_BUILDKIT=1 \
    GOPROXY=https://goproxy.cn,direct

WORKDIR /opt
COPY . /opt

ADD sources.list /etc/apt
RUN apt clean && apt update
RUN bash /opt/tools_installer.sh
WORKDIR /home
