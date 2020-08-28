# this docker file is assembled from the files in https://github.com/hyperledger/indy-node/tree/master/environment/docker/pool

FROM solita/ubuntu-systemd:16.04

ARG INDY_NETWORK_NAME
ARG INDY_NODE_NAME
ARG INDY_NODE_IP
ARG INDY_NODE_PORT
ARG INDY_CLIENT_IP
ARG INDY_CLIENT_PORT=9702

#ARG UID=1000

# Install environment
RUN apt-get update -y && apt-get install -y \
    git \
    wget \
    python3.5 \
    python3-pip \
    python-setuptools \
    python3-nacl \
    apt-transport-https \
    ca-certificates 
RUN pip3 install -U \ 
    'pip<10.0.0' \
    setuptools
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CE7709D068DB5E88
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BD33704C
RUN echo "deb https://repo.sovrin.org/deb xenial master" >> /etc/apt/sources.list
RUN echo "deb https://repo.sovrin.org/sdk/deb xenial master" >> /etc/apt/sources.list
#RUN useradd -ms /bin/bash -l -u $UID indy
RUN apt-get update -y && apt-get install -y indy-node libindy
RUN pip3 install python3-indy
#USER indy
WORKDIR /home/indy


COPY init_and_run.sh ./

CMD ["./init_and_run.sh"]
