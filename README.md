Mulesoft Anypoint Studio ubuntu Docker edition
---

**Ubuntu version**: Desktop 20.04

**Anypoint Studio Version**: 7.5.0 w/ Runtime 4.3

**Host OS**: MacOS Catalina

---

# Goal:

You want to, from a simple and automatic method have an virtual environment with all the tools you need to work with Anypoint Studio.


# FAQ:

 - Why not a VM?
	 - Having a fully functional VM that you can import into VMWARE or VIRTUALBOX is indeed an option but you have to have the vm file around and you need to create it, you need need to install everything. This option take that out and all you need is to run a command.

- How is the performance?
	- This "solution" will work for simple application and testing, do not think of it as a replacement.

- Does this replace installing all the software locally?
	- No, having the software installed will always be a better option, the goal here is to have a testing environment that can be quickly deployed with all the tools you need.


How to run
---
Pre-check:

- Sign up in [Docker Hub](https://hub.docker.com/signup) if you haven't
- Install [Docker Desktop](https://www.docker.com/products/docker-desktop) if you haven't.
- Install [Homebrew.](https://docs.brew.sh/Installation)
- Install **XQuartz** if you didn't already: `brew cask install xquartz`
- Make sure the $DISPLAY_MAC variable is equals to your current IP, try this command from a terminal:
  - `DISPLAY_MAC=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')`

Let's give it a try:
- Download this repo and unzip it wherever you like
- From a terminal, navigate to the folder you unzipped the project.
- Build the container with the command:
	- `docker build -t <replace-with-your-docker-hub-username>/studio .`
- Run the container with the command:
	- `docker run -d -it -e DISPLAY=$DISPLAY_MAC --name anypoint-studio  <replace-with-your-docker-hub-username>/studio`
- Run the command `xhost` <-- This is still not fully working.
