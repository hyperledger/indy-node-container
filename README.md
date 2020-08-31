# docker-indy-node

A simple container setup to run a node in an Hyperledger Indy network.

## How To

- `./generate_random_seeds.sh` and then securely backup `.cli.env` and `.node.env` which holds the seeds for generating all private keys
- put `pool_transactions_genesis` and `domain_transactions_genesis` for your network into the `lib_indy` and `cli_cfg` folders
- set the variables (Networkname, ips, ports) in the `.env` file
- build and run the container in deamon mode `docker-compose up -d`
- check `docker logs docker-indy-node_indy-node_1`

