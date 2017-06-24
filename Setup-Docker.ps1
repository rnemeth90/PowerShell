New-Item -Type Directory -Path $env:ProgramFiles\Docker\


Copy-Item C:\ContainerSources\d*.exe $env:ProgramFiles\Docker -Recurse

#install docker service
dockerd --register-service

#start docker service
start-service docker

#inspect docker networking
docker network ls

#inspect advanced docker networking
docker network inspect nat

#load docker nano server image
docker load -i c:\ContainerSource\Nanoserver.tar.gz

#list docker images
docker images

#tag the nano server image
docker tag microsoft/nanoserver:10.0.14393 nanoserver:latest

#Create a container and run a program
docker run -it --isolation=hyperv --name dockerdemo nanoserver cmd*

#list Container
docker ps

#list containers, including containers with a status of "Exited"
docker ps -a

#create a new container from an existing image
docker commit dockerdemo newcontainerimage

#create a new container from a new image
docker run -it --name newcontainer newcontainerimage cmd

#Remove a container
docker rm <container name>

#build an image from a config file
docker build -t nanoserver_iis1 c:\build\iis