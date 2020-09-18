# this docker file is assembled from the files in https://github.com/hyperledger/indy-node/tree/master/environment/docker/pool

FROM solita/ubuntu-systemd:16.04

# Install environment
RUN apt-get update -y && apt-get dist-upgrade -y && apt-get install -y \
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
RUN echo "deb https://repo.sovrin.org/deb xenial stable" >> /etc/apt/sources.list
RUN echo "deb https://repo.sovrin.org/sdk/deb xenial stable" >> /etc/apt/sources.list
#RUN useradd -ms /bin/bash -l -u $UID indy
RUN apt-get update -y && apt-get install -y indy-node=1.12.4 indy-plenum=1.12.4 python3-indy-crypto=0.4.5 libindy-crypto=0.4.5
RUN pip3 install python3-indy
#USER indy
WORKDIR /home/indy


COPY init_and_run.sh ./

CMD ["./init_and_run.sh"]
