# docker-indy-node

A simple container setup to run a node in an Hyperledger Indy network.

## How To

- `./generate_random_seeds.sh` and then securely backup `.node.env` which holds the seed for generating the private keys
- put `pool_transactions_genesis` and `domain_transactions_genesis` for your network into the `lib_indy` folder
- set the variables (Networkname, ips, ports) in the `.env` file
- build and run the container in deamon mode `docker-compose up -d`
- check `docker logs docker-indy-node_indy-node_1` and `docker exec -it docker-indy-node_indy-node_1 validator-info` to check the state of your node
- you need to run indy_cli (no longer included here) to actually interact with the ledger


## Config

The relevant directories are mounted as

```
 volumes:
      - ./etc_indy:/etc/indy
      - ./lib_indy:/var/lib/indy
```

giving direct access to the relevant config files from the host machine, if needed.


## License

Copyright 2020 Sebastian Schmittner

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
