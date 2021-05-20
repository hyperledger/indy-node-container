# Scripts to create a local Indy network for testing

This will create a local Indy network using the IDunion node container. It also adds a the ledger browser from [von-network](https://github.com/bcgov/von-network).
The docker network will use the subnet 10.133.133.0/24. You may change that according your needs.
## Steps

1. Check/Update `.env`, `docker-compose.yaml` and `init-test-network.sh` files - if you need to update the IP subnet, then the change must be made everywhere.
2. Run `init-test-network.sh` to create genesis and key files.
3. Run `docker-compose up` to start the network.
4. Check the ledger browser at http://localhost:9000 .
5. Use `docker-compose down` to shutdown the network.

