# Runtime environment

This folder is intended to provide an environment to run the indy node containers.
It also contains a few utility / helper scripts to help with the setup.


## How To


### Setup

You need a (semi) recent version of [docker](https://docs.docker.com/engine/install/#server) and [docker compose (version => 1.27.0)](https://docs.docker.com/compose/install/) installed. 

Of course, you can also use all our containers with other tools such as podman but that currently requires [some extra work on](https://podman.io/blogs/2021/01/11/podman-compose.html). If you produce a setup + step by step guide for the [tests](https://github.com/IDunion/indy-node-container/tree/main/test) or for [running the node](https://github.com/IDunion/indy-node-container/tree/main/run), please do share them! (Open an [issue/PR](https://github.com/IDunion/indy-node-container) or start [here](https://github.com/IDunion/indy-node-container/issues/48).)

### Step By Step

- `./generate_random_seeds.sh` and then securely backup `.node.env` which holds the seed for generating the private keys
- Put `pool_transactions_genesis` and `domain_transactions_genesis` for your network into the `lib_indy` folder. The sub folder name has to match the `INDY_NETWORK_NAME` set in `.env` in the next step.
- Set the variables (network name, ips, ports) in the `.env` file. You can also choose the base image, see https://github.com/IDunion/indy-node-container/pkgs/container/indy-node-container%2Findy_node .
- (Pull and) run the container in daemon mode via `docker-compose up -d`.
  - This will start two containers. One for the indy node and one for the node controller service that takes care of pool restarts. See below for details.
- Look at `docker logs indy_node` and `docker exec -it indy_node validator-info` to check the state of your node
- You need to run e.g. indy_cli (not included here) to actually interact with the ledger


## Config

The relevant directories are mounted as

```
 volumes:
      - ./etc_indy:/etc/indy
      - ./lib_indy:/var/lib/indy
```

giving direct access to the relevant config files from the host machine, if needed. Note that the `NETWORK_NAME` in `indy_config.py` is overridden at startup with the value from `INDY_NETWORK_NAME` from `.env`.

## Logging

The log dir is mounted to `./log_indy` by default to ease access to the log files.

## Node Controller

Our current approach to handle pool restarts is to have the node controller running in a separate service container which has access to the docker socket (`SOCK=/var/run/docker.sock`  in the `.env` file which might have to be adapted depending on your local docker setting). You can run the node without the node controller with e.g. `docker-compose up --scale indy-controller=0`. Note however that such nodes will not participate in pool restarts.

If the node controller container is running and has access to the docker socket of the host, the node will be restarted upon pool restart commands and will participate in a network upgrade. The decision mechanism for whether to accept or reject an upgrade based on avaiable deb package versions is part of indy node server and hence unchanged. However, if an upgrade is accepted, the container will be stopped, pulled, and restarted. Use a tag like `latest-ubuntu18` and make sure that a new `latest` image is avaiable bevor the network upgrade commences.


