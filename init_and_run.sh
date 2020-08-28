#!/bin/bash

# This script provides idempotent initialization and finally runs the indy node inside the docker container

echo -e "[...]\t Indy node init"
echo "INDY_NETWORK_NAME=${INDY_NETWORK_NAME:sandbox}"
echo "INDY_NODE_NAME=${INDY_NODE_NAME:=Alpha}"
echo "INDY_NODE_PORT=${INDY_NODE_PORT:=9701}"
echo "INDY_CLIENT_PORT=${INDY_CLIENT_PORT:=9702}"


# Set NETWORK_NAME in indy_config.py
awk '{if (index($1, "NETWORK_NAME") != 0) {print("NETWORK_NAME = \"$INDY_NETWORK_NAME\"")} else print($0)}' /etc/indy/indy_config.py> /tmp/indy_config.py
mv /tmp/indy_config.py /etc/indy/indy_config.py

# Init indy-node
init_indy_node $INDY_NODE_NAME $INDY_NODE_IP $INDY_NODE_PORT $INDY_CLIENT_IP $INDY_CLIENT_PORT

#USER root
#CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]


start_indy_node "$INDY_NODE_NAME" "$INDY_NODE_IP" "$INDY_NODE_PORT" "$INDY_CLIENT_IP" "$INDY_CLIENT_PORT"


