# Scripts to create a local Indy network for testing

This will create a local Indy network using the IDunion node container. It also adds a the ledger browser from [von-network](https://github.com/bcgov/von-network).
The docker network will use the subnet 10.133.133.0/24. You may change that according your needs.
Please make sure the OS and tools listed below are installed.

## OS

To successfully set up the test container you'll need Ubuntu 20.04 (The desktop version is required)

## Prerequisites
If not already installed, you will need to install Git, Docker and Docker-Compose on your Ubuntu system. 

* recent version of [docker](https://docs.docker.com/engine/install/#server)
* Current user added to 'docker' group (not needed for all environments)
* [docker compose (version => 1.27.0)](https://docs.docker.com/compose/install/) installed. 


## Git
```sh
sudo apt install -y git`
```

## Docker

Only perform Steps 1 and 2 from the following link to install docker: [How To Install and Use Docker on Ubuntu 20.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04)

## Docker-Composse

Enter these three commands in your terminal:
```sh
sudo curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
```

Your output should read as follows: `docker-compose version 1.29.2, build 5becea4`

## Download repo

Enter these command into your terminal:
```sh
git clone https://github.com/IDunion/indy-node-container.git
cd indy-node-container/test
```

## Setup

Of course, you can also use all our containers with other tools such as podman but that currently requires [some extra work on](https://podman.io/blogs/2021/01/11/podman-compose.html). If you produce a setup + step by step guide for the [tests](https://github.com/IDunion/indy-node-container/tree/main/test) or for [running the node](https://github.com/IDunion/indy-node-container/tree/main/run), please do share them! (Open an [issue/PR](https://github.com/IDunion/indy-node-container) or start [here](https://github.com/IDunion/indy-node-container/issues/48).)

## Steps

1. Check/Update `.env`, `docker-compose.yaml` and `init-test-network.sh` files - if you need to update the IP subnet, then the change must be made everywhere.
2. Run `init-test-network.sh` to create genesis and key files.
3. Run `docker-compose up` to start the network.
4. Check the ledger browser at http://localhost:9000 .
5. Use `docker-compose down` to shutdown the network.

