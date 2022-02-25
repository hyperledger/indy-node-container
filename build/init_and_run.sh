#!/bin/bash

# This script provides idempotent initialization and finally runs the indy node inside the docker container

# This file is part of https://github.com/hyperledger/indy-node-container .
# Copyright 2021-2022 by all people listed in https://github.com/hyperledger/indy-node-container/blob/main/NOTICE , see
# https://github.com/hyperledger/indy-node-container/blob/main/LICENSE for the license information.

set -e

date -Iseconds

echo "INDY_NETWORK_NAME=${INDY_NETWORK_NAME:=sandbox}"
echo "INDY_NODE_NAME=${INDY_NODE_NAME:=Alpha}"
echo "INDY_NODE_IP=${INDY_NODE_IP:=0.0.0.0}"
echo "INDY_NODE_PORT=${INDY_NODE_PORT:=9701}"
echo "INDY_CLIENT_IP=${INDY_CLIENT_IP:=0.0.0.0}"
echo "INDY_CLIENT_PORT=${INDY_CLIENT_PORT:=9702}"

echo "INDY_NODE_SEED=[$(echo -n $INDY_NODE_SEED|wc -c) characters]"

# Set NETWORK_NAME in indy_config.py
awk '{if (index($1, "NETWORK_NAME") != 0) {print("NETWORK_NAME = \"'$INDY_NETWORK_NAME'\"")} else print($0)}' /etc/indy/indy_config.py> /tmp/indy_config.py
mv /tmp/indy_config.py /etc/indy/indy_config.py

# Init indy-node
if [[ ! -d "/var/lib/indy/$INDY_NETWORK_NAME/keys" ]]
then
    echo -e "[...]\t No keys found. Running Indy Node Init..."
    if init_indy_keys --name "$INDY_NODE_NAME" --seed "$INDY_NODE_SEED"
    then
        echo -e "[OK]\t Init complete"
    else
        echo -e "[FAIL]\t Node Init returns $?"
        exit 1
    fi
else
    echo -e "[OK]\t Keys directory exists, skipping init."
fi

echo -e "[...]\t Setting directory owner to indy"

echo

mkdir -vp /var/log/indy
chown -vR indy:indy /var/log/indy
chown -vR indy:indy /var/lib/indy

echo -e "[OK]\t Setting directory owner to indy"

echo -e "[...]\t Starting Indy Node as indy user"

echo

exec su indy <<EOF
start_indy_node "$INDY_NODE_NAME" "$INDY_NODE_IP" "$INDY_NODE_PORT" "$INDY_CLIENT_IP" "$INDY_CLIENT_PORT"
EOF
