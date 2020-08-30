# docker-indy-node

A simple container setup to run a node in an Hyperledger Indy network.

## How To

- put `pool_transactions_genesis` and `domain_transactions_genesis` for your network into the `lib_indy` folder
- set the variables (Networkname, ips, ports) in the `.env` file
- build and run the container in deamon mode `docker-compose up -d`
- check `docker logs docker-indy-node_indy-node_1`

The first run will generate the keys in the `lib_indy` folder. 

