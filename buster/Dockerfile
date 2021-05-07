# This is an indy-node build container created in the indy-node docker working group of the ID Union project.
# author: Sebastian Schmittner <sebastian.schmittner@eecc.de>
# version: 0.1+2021-04-29

FROM python:3.6-buster

ARG INDY_NODE_VERSION=1.12.4

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get autoremove -y && \
    apt-get install -y \
            libsodium-dev \
            libsecp256k1-dev \
            libssl-dev \
            liblzma-dev \
            libsnappy-dev \
            liblz4-dev \
            librocksdb-dev \
            software-properties-common

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CE7709D068DB5E88 && \
    add-apt-repository "deb https://repo.sovrin.org/sdk/deb bionic stable" && \
    apt-get update && \
    apt-get install -y libindy

#Run apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 68DB5E88 && \
#    add-apt-repository "deb https://repo.sovrin.org/sdk/deb xenial stable" && \
#    apt-get update && \
#    apt-get install -y libindy-crypto

RUN pip install indy-node==$INDY_NODE_VERSION

COPY init_and_run.sh ./

CMD ["./init_and_run.sh"]
