# Runtime environment

This folder is intended to provide an environment to run the indy node containers.
It also contains a few utility / helper scripts to help with the setup.


## Step by Step Setup

This is a brief step by step guide for what to do if you want to add a containerized indy node to an existing network.

### Node Setup

Just clone the whole repository and generate a seed

```
git clone https://github.com/hyperledger/indy-node-container.git
cd indy-node-container/run/
./generate_random_seeds.sh 
```

and then securely backup `.node.env` which holds the seed for generating the private keys.

Change the network name in `etc_indy/indy_config.py` to `NETWORK_NAME = 'YOUR_NETWORK_NAME'` and in `.env` to `INDY_NETWORK_NAME=YOUR_NETWORK_NAME`. In the latter, also set the `INDY_NODE_NAME` to your nodes alias.  

You may choose [an image](https://github.com/hyperledger/indy-node-container/pkgs/container/indy-node-container%2Findy_node/versions) to use or stick with the default.
- **Caution**: The ubunut20 image is a test image to test the new release candidate of indy node. All other images are stable.


Prepare the folder accordingly
```
rm -rf lib_indy/ssi4de/
mkdir lib_indy/YOUR_NETWORK_NAME
```

Run `docker compose up --scale indy-controller=0`. This will run some setup and you will get some information which needs to share with the other nodes from the output like:

```
...
indy_node          | Public key is ...
indy_node          | Verification key is ...
indy_node          | BLS Public key is ...
indy_node          | Proof of possession for BLS key is ...
indy_node          | [OK]	 Init complete
...
```
It is a good idea to node down al those key/proof values. This is public information.

Since there are no genesis files in place yet, the startup will fail with an error, but you might now want to backup your keys and / or seed phrase ( `.node.env` ) if not done earlier. The latter is no longer required for further startups, so you might want to remove it for security reasons.

Put `pool_transactions_genesis` and `domain_transactions_genesis` for your network into the `lib_indy/YOUR_NETWORK_NAME` folder. **The sub folder name has to match the `INDY_NETWORK_NAME` set in `.env` file!**

Now is a good time to [setup IP Tables rules](#firewall-ip-tables), although you can also do this later.


### Create a DID

You most likely want to create a did for the node operator, using the indy-cli. This is independent of your node and may happen on another machine, which is recommended for security reasons.

```
indy-cli
indy> wallet create WALLET_NAME key=...
indy> wallet open WALLET_NAME key=...
WALLET_NAME:indy> did new seed=...
Did "..." has been created with "~..." verkey
```

Note down the created did and verkey and share it with your network peers for them to write it to the existing indy network. You do not have to specify a seed for the new did, but this might be helpful if you later need to recover the private key on another machine. The seed needs to be kept at least as safe as the wallet key.

### Running the node

```
indy-node-container/run$ docker compose up -d
```

you might want to check logs, ledger info (see  e.gg. https://github.com/IDunion/Internal-Information/tree/main/Tools/get-validator-info ), etc 😉




## Config

The relevant directories are mounted as

```
 volumes:
      - ./etc_indy:/etc/indy
      - ./lib_indy:/var/lib/indy
```

giving direct access to the relevant config files from the host machine, if needed. Note that the `NETWORK_NAME` in `indy_config.py` is overridden at startup with the value from `INDY_NETWORK_NAME` from `.env`.

## Firewall (IP Tables)

If the firewall rules for your indy node are not set elsewhere (on the docker host or upstream), you may want to use the
[set_iptables.sh](./set_iptables.sh) script to set the recommended firewall settings for your node in the DOCKER-USER
chain.
See `./set_iptables.sh -h` for usage information. You will need to provide the list of ip addresses of nodes in your
network in a suitable file. To this end, create a file and put your network's IP addresses into this file, one per line.
You also need to figure out the network interface over which you docker host receives incoming connections from the internet.
Then run the script like

```
sudo ./set_iptables.sh INTERFACE IP_FILE
```

### Connectivity check

There is [a simple connectivity check script](check_network_connectivity.sh) which you can run
- on your node's machine
- from outside
 in order to verify
- that your node is able to reach all other nodes
- the internal port is not internet reachable for any Node

```
./check_network_connectivity.sh IP_FILE
```

If incoming and outgoing IPs are the same for all nodes, you can use the same ips file as for setting the ip tables rules. Otherwise make sure to allow incoming connections from outgoing IPs and check reachability of your outgoing to their incoming IPs. :wink:


## Logging Configuration

Loggin can be configured through the variables in [indy_config.py](./etc_indy/indy_config.py):

```conf
## Logging
# 0 means everything
logLevel = 1

# Enable/Disable stdout logging
enableStdOutLogging = True

# Directory to store logs. You might want to mount this in order to access the log files from outside the container.
LOG_DIR = '/var/log/indy'
```

You might want to collect all logs via the Docker Daemon and the forward them to your Log Destination. To this end, enable the std out logging and set the options explained below:

### Via Docker Daemon

You can set logging options globally fot the Docker Daemon for all Containers in the `/etc/docker/daemon.json`. To apply the changes you need to restart the docker daemon. Example:

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m",
    "max-file": "5",
  }
}
```

### Via docker compose

See [docker-compose.yml](./docker-compose.yml):

```yml
services:
    ...
    logging:
        driver: "json-file"
        options:
          max-file: "5"
          max-size: "100m"
```


## Node Controller

Our current approach to handle pool restarts is to have the node controller running in a separate service container which has access to the docker socket. You can run the node without the node controller with e.g. `docker compose up --scale indy-controller=0`. Note however that such nodes will not participate in pool restarts.

If wou want to use the node controller, the variables `SOCK`, `NODE_CONTAINER_NAME`, `CONTROLLER_CONTAINER`, and `IMAGE_NAME_CONTROLLER` need to be set in the `.env` file. Appropriate default values are set in [the default file](/.env).

If the node controller container is running and has access to the docker socket of the host, the node will be restarted upon pool restart commands and will participate in a network upgrade. The decision mechanism for whether to accept or reject an upgrade based on available deb package versions is part of indy node server and hence unchanged. However, if an upgrade is accepted, the container will be stopped, pulled, and restarted. Use a tag like `latest-ubuntu20` and make sure that a new `latest` image is available before the network upgrade commences.


