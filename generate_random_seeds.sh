#!/bin/bash

echo -e "[...]\t storing random seeds in .cli.env and .node.env"
echo "INDY_NODE_SEED=$(head -c 32 /dev/random | base64 | head -c 32)" > .node.env
echo "INDY_STEWARD_SEED=$(head -c 32 /dev/random | base64 | head -c 32)" > .cli.env
echo "WALLET_KEY=$(head -c 32 /dev/random | base64 | head -c 32)" >> .cli.env
echo "INDY_ENDORSER_SEED=$(head -c 32 /dev/random | base64 | head -c 32)" >> .cli.env
echo -e "[OK]\t done"
