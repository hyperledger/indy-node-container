# Runtime environment

This folder is intended to provide an environment to run the indy node containers.
It also contains a few utility / helper scripts to help with the setup.


## How To

- `./generate_random_seeds.sh` and then securely backup `.node.env` which holds the seed for generating the private keys
- Put `pool_transactions_genesis` and `domain_transactions_genesis` for your network into the `lib_indy` folder. The sub folder name has to match the `INDY_NETWORK_NAME` set in `.env` in the next step.
- Set the variables (Networkname, ips, ports) in the `.env` file
- Pull and run the container in deamon mode `docker-compose up -d`
- Look at `docker logs indy_node` and `docker exec -it indy_node validator-info` to check the state of your node
- You need to run e.g. indy_cli (not included here) to actually interact with the ledger


## Config

The relevant directories are mounted as

```
 volumes:
      - ./etc_indy:/etc/indy
      - ./lib_indy:/var/lib/indy
```

giving direct access to the relevant config files from the host machine, if needed. Note that the `NETWORK_NAME` is overriden at startup with the value from `INDY_NETWORK_NAME` from `.env`.
