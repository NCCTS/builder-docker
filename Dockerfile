# Docker version 1.4.1, build 5bc2ff8
FROM nccts/baseimage:0.0.10

# nccts/builder
# Version: 0.0.10
MAINTAINER "Michael Bradley" <michael.bradley@nccts.org>
# Et vidimus gloriam ejus, gloriam quasi unigeniti a Patre plenum gratiæ et veritatis.

# Cache buster
ENV REFRESHED_AT [2014-12-25 Thu 19:24]

# Set environment variables
ENV HOME /root

# Add supporting files for the build
ADD . /docker-build

# Run main setup script, cleanup supporting files
RUN chmod -R 777 /docker-build
RUN /docker-build/setup.sh && rm -rf /docker-build

# Ensure the place where Docker stores its containers is not an AUFS filesystem
VOLUME [ "/var/lib/docker" ]

# Use phusion/baseimage's init system as the entrypoint:
# 'entry.sh' starts shell (or tmux) as the 'sailor' user
# (tmux: with a session named 'builder')
ENTRYPOINT ["/sbin/my_init", "--", "/usr/local/bin/entry.sh", "builder"]
CMD [""]

# example usage
# --------------------------------------------------
# docker run -it --rm nccts/builder
#
# need more examples...
