#!/usr/bin/env bash

# inits 4 nodes for a local test network 
mkdir -p lib_indy
docker run -v ${PWD}/etc_indy:/etc/indy -v ${PWD}/lib_indy:/var/lib/indy  -it ghcr.io/idunion/indy-node-container/indy_node:buster \
    /bin/bash -c "rm -rf /var/lib/indy/* && generate_indy_pool_transactions --nodes 4 --clients 0 --nodeNum 1 2 3 4 --ips=\"10.133.133.1,10.133.133.2,10.133.133.3,10.133.133.4\" --network idunion_local_test"
