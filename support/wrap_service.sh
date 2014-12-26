#!/bin/sh

if [ "${DIND+set}" = set ]; then
    mkdir -p /var/docker_host/run
    export DOCKER_DAEMON_ARGS="-H unix:///var/docker_host/run/docker.sock"
    /usr/local/bin/wrapdocker >>/var/log/dind.log 2>&1
else
    while true; do
        sleep 3600
    done
fi
