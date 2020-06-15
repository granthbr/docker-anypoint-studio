## Setup Anypoint Studio in Docker

FROM ubuntu:20.04
MAINTAINER Brandon Grantham <brandon.grantham@mulesoft.com>

LABEL Description="MuleSoft Anypoint Studio 7"

## Set version for build
ARG STUDIO_VERSION=7.5.1

## Update Ubuntu in preparation for installing Anypoint Studio

RUN   sed 's/main$/main universe/' -i /etc/apt/sources.list \
      && apt-get update && apt-get install -y software-properties-common \
      && apt-get install openjdk-8-jre -y \
      && apt-get update \
      && apt-get install wget \
      && apt-get -y install sudo \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/* \
      && rm -rf /tmp/*
    
# Setup the additional libraries
RUN   apt-get update \
      && apt-get install -y libgtk-3-0 libcanberra-gtk-module maven 

# Download and Extract Studio
RUN  wget -nv --show-progress --progress=bar:force:noscroll  http://mule-studio.s3.amazonaws.com/$STUDIO_VERSION-U1/AnypointStudio-$STUDIO_VERSION-linux64.tar.gz -O /tmp/studio.tar.gz -q \ 
      && echo 'Installing Studio' \
      && tar -zxf /tmp/studio.tar.gz -C /opt \
      && rm /tmp/studio.tar.gz

## Copy over the run studio file
ADD   run /usr/local/bin/studio

## Create the mule user and assign to the appropriate role
RUN    chmod +x /usr/local/bin/studio \
       && mkdir -p /home/mule \
       && echo "mule:x:1000:1000:mule,,,:/home/mule:/bin/bash" >> /etc/passwd \
       && echo "mule:x:1000:" >> /etc/group \
       && echo "mule ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/mule \
       && chmod 0440 /etc/sudoers.d/mule \
       && chown mule:mule -R /home/mule \
       && chown root:root /usr/bin/sudo \
       && chmod 4755 /usr/bin/sudo

## Change to the mule user and create home
USER        mule
ENV         HOME /home/mule
WORKDIR     /home/mule
ADD         docker-entrypoint.sh /home/mule/
#RUN         chmod a+rwx,o-w /home/mule/docker-entrypoint.sh \
#            && sudo chown mule.mule /home/mule/docker-entrypoint.sh
ENTRYPOINT  ["/home/mule/docker-entrypoint.sh"]

## Run the start command
CMD         /usr/local/bin/studio


