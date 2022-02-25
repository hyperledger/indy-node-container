#!/bin/bash

# Set NETWORK_NAME in indy_config.py
sed -i "s/None/\'${INDY_NETWORK_NAME:=local_test}\'/g" /etc/indy/indy_config.py

/opt/controller/start_node_control_tool
