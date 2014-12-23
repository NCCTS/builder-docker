#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export HOME=/root

# Install Docker
apt-get update
apt-get -y install apt-transport-https ca-certificates lxc iptables
echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
apt-get update
apt-get -y install lxc-docker

# Install the Docker daemon wrapper
#   From: https://github.com/jpetazzo/dind
#   Apache License Version 2.0
#   https://github.com/jpetazzo/dind/blob/master/LICENSE
cp /docker-build/support/wrapdocker.sh /usr/local/bin/wrapdocker

# Install phusion/baseimage service to invoke the Docker daemon wrapper
mkdir -p /etc/service/docker
cp /docker-build/support/wrap_service.sh /etc/service/docker/run

# "sailor" user needs group or sudo privs to interface with the Docker daemon, 
#   whether in a docker-in-docker scenario (running its own Docker daemon) or
#   accessing the host's daemon
usermod -a -G docker sailor
usermod -a -G sudo sailor
usermod -a -G users sailor
echo '%sudo ALL=NOPASSWD: ALL' >> /etc/sudoers

# Setup docker cli environment for unprivileged user 'sailor'
sudo -i -u sailor /docker-build/support/user_sailor.sh

# Cleanup
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
