# docker-indy-node

A simple container setup to run a node in an Hyperledger Indy network.

## How To

- `./generate_random_seeds.sh` and then securely backup `.node.env` which holds the seed for generating the private keys
- put `pool_transactions_genesis` and `domain_transactions_genesis` for your network into the `lib_indy` folder
- set the variables (Networkname, ips, ports) in the `.env` file
- build and run the container in deamon mode `docker-compose up -d`
- check `docker logs docker-indy-node_indy-node_1` and `docker exec -it docker-indy-node_indy-node_1 validator-info` to check the state of your node
- you need to run indy_cli (no longer included here) to actually interact with the ledger



