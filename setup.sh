#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export HOME=/root

# Install Docker
apt-get update
apt-get -y install apt-transport-https \
                   ca-certificates \
                   lxc \
                   iptables
echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
apt-get update
apt-get -y install lxc-docker

# Install the Docker daemon wrapper
#   From: https://github.com/jpetazzo/dind
#   Apache License Version 2.0
#   https://github.com/jpetazzo/dind/blob/master/LICENSE
cp /docker-build/support/dind.sh /usr/local/bin/dind

# Install phusion/baseimage service to invoke the Docker daemon wrapper
mkdir -p /etc/service/dind
cp /docker-build/support/dind_service.sh /etc/service/dind/run

# User "sailor" needs group-privs to interface with the Docker daemon, whether
# in a docker-in-docker scenario (running its own Docker daemon) or accessing
# the host's daemon
usermod -a -G docker,users sailor

# Install Fig
fig_base_url=https://github.com/docker/fig/releases/download/1.0.1/fig
curl -L $fig_base_url-$(uname -s)-$(uname -m) \
     > /usr/local/bin/fig
chmod +x /usr/local/bin/fig

# Setup docker cli environment for root
/docker-build/support/user_common.sh

# Setup docker cli environment for unprivileged user 'sailor'
sudo -i -u sailor /docker-build/support/user_common.sh

# Cleanup
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
