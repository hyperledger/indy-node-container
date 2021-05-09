#!/usr/bin/env bash

docker build -f ./buster/Dockerfile.base.buster -t indy_node_base_container ./buster/
docker build -f ./buster/Dockerfile -t indy_node_container ./buster/
