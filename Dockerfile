#
# bloomd Dockerfile
#
# https://github.com/saidimu/bloomd-docker
# forked https://github.com/julienmarie/bloomd-docker

# Pull base image.
FROM ubuntu
MAINTAINER Julien Marie <jm@producture.com>

RUN apt-get update

#RUN echo "deb http://archive.ubuntu.com/ubuntu quantal main universe multiverse" > /etc/apt/sources.list
#RUN apt-get update
#RUN apt-get upgrade -y

# Install basic packages.
#RUN apt-get install -y software-properties-common
RUN apt-get install -y curl git  unzip  wget
RUN apt-get install -y build-essential


## Current binary version
ENV BLOOMD_VERSION 0.7.4

# Define location of default conf file
ENV BLOOMD_CFG /etc/bloomd/bloomd.conf

# Install bloomd.
RUN \
  mkdir -p /tmp/bloomd /data /etc/bloomd && \
  wget https://github.com/armon/bloomd/archive/master.tar.gz -O - \
	| tar -xvz --strip=1 -C /tmp/bloomd && \
  apt-get update && \
  apt-get -y install scons && \
  rm -rf /var/lib/apt/lists/* && \
  cd /tmp/bloomd && \
  scons && \
  mv /tmp/bloomd/bloomd /usr/local/bin/ && \
  rm -rf /tmp/bloomd

# Define mountable data and config folders
VOLUME /data
VOLUME /etc/bloomd

# Copy default conf file
ADD bloomd.conf /etc/bloomd/bloomd.conf

# Define working directory.
WORKDIR /data

# Define default command.
CMD /usr/local/bin/bloomd -f $BLOOMD_CFG

# Expose ports.
EXPOSE 8673
