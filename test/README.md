# Scripts to create a local Indy network for testing

## Steps

1. Check/Update `.env` file - if you need to update the IP addresses, then the same change must be made in `docker-compose.yaml` and `init-test-network.sh`.
2. Run `init-test-network.sh` to create genesis and key files.
3. Run `docker-compose up` to start the network.
