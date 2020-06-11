## Setup Anypoint Studio in Docker
## Last Update June 2020
## Based on Brandon Grantham project https://github.com/granthbr/docker-anypoint-studio

FROM ubuntu:20.04
MAINTAINER Santiago Moneta <santiago.moneta@mulesoft.com>

LABEL Description="MuleSoft Anypoint Studio 7.5.0"

## Set version for build
ARG STUDIO_VERSION=7.5.0


## Update Ubuntu in preparation for installing Anypoint Studio

RUN   sed 's/main$/main universe/' -i /etc/apt/sources.list && \
      apt-get update && apt-get install -y software-properties-common && \
      apt-get install openjdk-8-jre -y && \
      apt-get update && \
      apt-get install wget && \
      apt-get -y install sudo && \
      apt-get clean && \
      rm -rf /var/lib/apt/lists/* && \
      rm -rf /tmp/*
    
# Setup the additional libraries
RUN   apt-get update && apt-get install -y libgtk2.0-0 libcanberra-gtk-module \ 
    && apt-get install maven -y

## Retrieve studio for Linux from S3 and uncompress

RUN  echo 'Downloading Studio, please wait...'  && \
      wget -nv --show-progress --progress=bar:force:noscroll https://mule-studio.s3.amazonaws.com/$STUDIO_VERSION-GA/AnypointStudio-$STUDIO_VERSION-linux64.tar.gz -O /tmp/studio.tar.gz \ 
      && echo 'extracting, please wait...' && \
      tar -zxf /tmp/studio.tar.gz -C /opt && \ 
      rm /tmp/studio.tar.gz
    
## Copy over the run studio file
ADD run /usr/local/bin/studio

## Create the mule user and assign to the appropriate role
#RUN   useradd -m mule && echo "mule:mule" | chpasswd && adduser mule sudo && \
      #chmod +x /usr/local/bin/studio && \
      #mkdir -p /home/mule && \
      #echo "mule:x:1000:1000:mule,,,:/home/mule:/bin/bash" >> /etc/passwd && \
      #echo "mule:x:1000:" >> /etc/group && \
      #echo "ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
      #chmod 0440 /etc/sudoers.d/mule && \
      #chown mule:mule -R /home/mule 
      #chown root:root /usr/bin/sudo
      #chmod 4755 /usr/bin/sudo


RUN \
    groupadd -g 999 mule && useradd -u 999 -g mule -G sudo -m -s /bin/bash mule && \
    sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g' && \
    sed -i /etc/sudoers -re 's/^root.*/root ALL=(ALL:ALL) NOPASSWD: ALL/g' && \
    sed -i /etc/sudoers -re 's/^#includedir.*/## **Removed the include directive** ##"/g' && \
    echo "mule ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "Customized the sudoers file for passwordless access to the mule user!" && \
    echo "mule user:";  su - mule -c id     



## Change to the mule user and create home
USER   mule
ENV    HOME /home/mule
WORKDIR /home/mule
ADD   docker-entrypoint.sh /home/mule/
RUN   ls -al /home/mule
      #chmod 775 /home/mule/docker-entrypoint.sh && \
      #chown mule.mule /home/mule/docker-entrypoint.sh
ENTRYPOINT ["/home/mule/docker-entrypoint.sh"]
## Run the start command
CMD    /usr/local/bin/studio