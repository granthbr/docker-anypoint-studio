## Run Anypoint Studio in Docker

Build and run Anypoint Studio in an Ubuntu image. Expose the correct ports, volumes (for libs and plugins), and workspace for persistence. 
Currently, this Docker image is specific to Mac OSX. 

### Pre-requisites

1. XQuartz: Install XQuartz.
	 - Easiest method for installation is to use homebrew: brew cask install xquartz
	 
2. There are a couple of methods to start the X11 engine with quartz. 

*** Warning:There might be an error running studio such as "AnypointStudio: Cannot open display", try to use each one of the below commands and attempt to run studio again.Assign IP address or hostname to xquartz ***   
   
   a. Method 1: DISPLAY_MAC=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
   b. Method 2: DISPLAY_MAC=`ifconfig en0 | grep "inet " | cut -d " " -f2`:0
   c. Method 3: DISPLAY_MAC=`hostname`
   
   Start xhost:
   a. Method 1: xhost 
   
   If you have problems with multiple IPs. Try
   b. Method 2: xhost + $DISPLAY_MAC
   
	A response should return something similar the message below:
	192.168.86.23 being added to access control list


### Instructions for build and run

Below, the reference to <docker-hub-username> should be replaced with your docker store/hub user name. For example, mine is granthbr.

Build the image:
```
docker build -t <docker-hub-username>/studio .
```

Can be ran with internally hosted workspace, maven, and libs:
```
docker run -d -it -e DISPLAY=$DISPLAY_MAC --name anypoint-studio  <docker-hub-username>/studio
```

Or with external mounted volumes (recommended for persistent workspace, maven repo, and libraries. To externally host the libs, first run without volumes (see above), then onces the container is running, copy the features and plugins out to the external environment like so:
```
docker cp anypoint-studio:/opt/AnypointStudio/features . and docker cp anypoint-studio:/opt/AnypointStudio/plugins .
```
Next, use a command similar to the command below:
(include the --rm command if you don't want the image to persist after you build it)
```
docker run -it --rm -e DISPLAY=$DISPLAY_MAC --name studio -v `pwd`/features:/opt/AnypointStudio/features -v `pwd`/plugins:/opt/AnypointStudio/plugins -v `pwd`/workspace:/home/mule/workspace -v ~/.m2:/home/mule/.m2 <docker-hub-username>/studio
```
Running with ports open:
```
docker run -it --rm -e DISPLAY=$DISPLAY_MAC --name studio -p 8181:8181 -p 6666:6666 -v `pwd`/features:/opt/AnypointStudio/features -v `pwd`/plugins:/opt/AnypointStudio/plugins -v `pwd`/workspace:/home/mule/workspace -v ~/.m2:/home/mule/.m2 <docker-hub-username>/studio
```

### Caveats

There are certain restrictions to running the IDE in a Docker container. There should be handlers and adjustments that assist with manaeuvering around the obstacles.

1. Running/debugging in the IDE. 
	- Opening the ports in the run command can allow access to the application on the assigned port. 
	- Open up the Mule Runtime Debugger port. Usually port 6666.
	
### TODO
1. Configure for Docker Compose
2. Clean up X11 process
3. Setup for Windows... (yuck)

###### Informational
The docker-entrypoint.sh script will exit the run script if any commnad fails and exec "$@" will redirect input variables if the user adds any. 
