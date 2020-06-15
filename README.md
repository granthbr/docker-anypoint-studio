Mulesoft Anypoint Studio ubuntu Docker edition
---

**Ubuntu version**: Desktop 20.04

**Anypoint Studio Version**: 7.5.1 (Runtime v4.3)

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

- Sign up in [Docker Hub](https://hub.docker.com/signup) if you haven't already
- Install the following software if you haven't already
 - [Docker Desktop](https://www.docker.com/products/docker-desktop)
 - [Homebrew.](https://docs.brew.sh/Installation)
 - **XQuartz**
   - Command: `brew cask install xquartz`
 - **Socat**
   - Command: `brew install socat`
- Make sure XQuartz accept client connections:
 - run the command: `open -a Xquartz`
 - On the top left menu, click on ""XQuartz" and select "Preferences"
 - On the "Security" section, be sure "Allow connections from network clients" is marked.
- Make sure socat is listenning on the port 6000:
  - Command: `socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"`

Let's give it a try:
- Download this repo and unzip it wherever you like
- From a terminal, navigate to the folder you unzipped or cloned the project.
- Build the container with the command:
	- `docker build -t <replace-with-your-docker-hub-username>/studio7 .`

![enter image description here](https://i.imgur.com/juJZTEw.jpg)

- Run the container with the command:
	- `docker run -d -it -e DISPLAY=<replace-with-your-local-IP>:0 --name anypoint-studio7  <replace-with-your-docker-hub-username>/studio`

- Voila!

- From now, all you have to do to start Studio is to run the command `docker start anypoint-studio7`
---
In case of emergency, Nuke docker completly:
 - `docker system prune -a --volumes`

---
To-do:
- fix folder permission issue to make studio fully launch
- test ports and performance
