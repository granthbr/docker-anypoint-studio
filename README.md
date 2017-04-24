#### Run Anypoint Studio in Docker

Build and run Anypoint Studio in an Ubuntu image. Expose the correct ports, volumes (for libs and plugins), and workspace for persistence. 
Currently, this Docker image is specific to Mac OSX. 

#### Pre-requisites

1. XQuartz -- Install XQuartz. Easiest to install with homebrew: brew cask install xquartz
2. Assign IP address or hostname to xquartz :  
   This: DISPLAY_MAC=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
   or this: DISPLAY_MAC=`ifconfig en0 | grep "inet " | cut -d " " -f2`:0
   or this: DISPLAY_MAC=`hostname`
   Then run:
   xhost 
   If you have problems with multiple IPs. Try
   xhost + $DISPLAY_MAC
Should return:
192.168.86.23 being added to access control list (of course, whatever your IP address is should be returned.)


#### Instructions for build and run
Build the image:
```
docker build -t <docker-hub-username>/studio .
```
Can be ran with internally hosted workspace and libs:
```
docker run -d -it -e DISPLAY=$DISPLAY_MAC --name anypoint-studio  <docker-hub-username>/studio
```

Or with external mounted volumes (recommended for persistent workspace and libraries. To externally host the libs, first run without volumes, then onces the container is running, copy the features and plugins out to the external environment like so:
docker cp anypoint-studio:/opt/AnypointStudio/features . and docker cp anypoint-studio:/opt/AnypointStudio/plugins .)
```
docker run -d -it -e DISPLAY=$DISPLAY_MAC --name studio -v `pwd`/features:/opt/AnypointStudio/features -v `pwd`/plugins:/opt/AnypointStudio/plugins -v `pwd`/workspace:/home/mule/workspace  granthbr/studio
```