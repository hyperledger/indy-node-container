# This container is to run indy-node.
# It has been created in the indy-node docker working group of the ID Union project.
# author: Sebastian Schmittner <sebastian.schmittner@eecc.de>
# version: 1.0+2021-05-09

ARG BASE=indy_node_base_container

FROM $BASE

# ubuntu 18 libindy package
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CE7709D068DB5E88 && \
    add-apt-repository "deb https://repo.sovrin.org/sdk/deb bionic stable" && \
    apt-get update && \
    apt-get install -y libindy

# deprecated dependencies based on libssl1.0 / libiny-crypto
Run \
    # for old libssl needed for libindy-crypto
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32 && \
    add-apt-repository "deb http://security.ubuntu.com/ubuntu bionic-security main" && \
    # for libindy-crypto
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 68DB5E88 && \
    add-apt-repository "deb https://repo.sovrin.org/sdk/deb xenial stable" && \
    apt-get update && \
    apt-get install -y libssl1.0.0 libindy-crypto=0.4.5 python3-indy-crypto=0.4.5

RUN pip install python3-indy indy-node==1.12.4 indy-plenum==1.12.4 


COPY init_and_run.sh ./

CMD ["./init_and_run.sh"]
