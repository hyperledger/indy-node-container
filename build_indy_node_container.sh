#!/usr/bin/env bash


docker build -f ./node/Dockerfile.base.buster -t indy_node-base-buster ./node/
docker build -f ./node/Dockerfile -t indy_node_container --build-arg BASE=indy_node-base-buster ./node/
