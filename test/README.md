# Scripts to create a local Indy network for testing

This will create a local Indy network using the IDunion node container. It also adds a the ledger browser from [von-network](https://github.com/bcgov/von-network).
The docker network will use the subnet 10.133.133.0/24. You may change that according your needs.

## Setup

You need a (semi) recent version of [docker](https://docs.docker.com/engine/install/#server) and [docker compose (version => 1.27.0)](https://docs.docker.com/compose/install/) installed. 

Of course, you can also use all our containers with other tools such as podman but that currently requires [some extra work on](https://podman.io/blogs/2021/01/11/podman-compose.html). If you produce a setup + step by step guide for the [tests](https://github.com/IDunion/indy-node-container/tree/main/test) or for [running the node](https://github.com/IDunion/indy-node-container/tree/main/run), please do share them! (Open an [issue/PR](https://github.com/IDunion/indy-node-container) or start [here](https://github.com/IDunion/indy-node-container/issues/48).)


## Steps

1. Check/Update `.env`, `docker-compose.yaml` and `init-test-network.sh` files - if you need to update the IP subnet, then the change must be made everywhere.
2. Run `init-test-network.sh` to create genesis and key files.
3. Run `docker-compose up` to start the network.
4. Check the ledger browser at http://localhost:9000 .
5. Use `docker-compose down` to shutdown the network.

