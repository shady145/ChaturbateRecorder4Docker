# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.
FROM phusion/baseimage:master-amd64

ARG PROGRAM_NAME=ChaturbateRecorder4Docker

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...

ENV TZ=Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update
RUN apt install python3 python3-pip unzip wget -y && \
	python3 -m pip install livestreamer bs4 lxml gevent && \
	wget https://github.com/shady145/${PROGRAM_NAME}/archive/master.zip && \
	unzip master.zip && \
	rm master.zip && \
	chmod +x /${PROGRAM_NAME}-master/run && \
	mv /${PROGRAM_NAME}-master /ChaturbateRecorder

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME /chaturbaterecorder

ENTRYPOINT /ChaturbateRecorder/run
