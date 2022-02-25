#!/usr/bin/env bash
NODES=${NODES:-4}

source .env

if [ -z ${1+x} ]; then
  IMAGE_NAME_NODE=ghcr.io/hyperledger/indy-node-container/indy_node:latest-buster
else
  IMAGE_NAME_NODE=$1
fi

echo "using image $IMAGE_NAME_NODE"

# inits N nodes for a local test network
mkdir -p lib_indy
docker run -v "${PWD}"/etc_indy:/etc/indy -v "${PWD}"/lib_indy:/var/lib/indy "$IMAGE_NAME_NODE" \
    /bin/bash -c "rm -rf /var/lib/indy/* && generate_indy_pool_transactions --nodes ${NODES} --clients 0 --nodeNum $(seq -s ' ' $NODES) --ips=\"$(seq -f '10.133.133.%g' -s ',' $NODES)\" --network $INDY_NETWORK_NAME && chmod -R go+w /var/lib/indy/"

for i in $(seq 1 $NODES); do
    mkdir -p "${PWD}"/etc_indy/node$i
    cp "${PWD}"/etc_indy/{indy.env,indy_config.py} "${PWD}"/etc_indy/node$i/
    echo -e "\n# node controller container IP\ncontrolServiceHost = '10.133.133.1$i'" >> "${PWD}"/etc_indy/node$i/indy_config.py
done
