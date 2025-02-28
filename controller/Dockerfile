FROM ubuntu:24.04

RUN apt-get update -y && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    libsodium-dev \
    libsecp256k1-dev \
    libssl-dev \
    liblzma-dev \
    libsnappy-dev \
    liblz4-dev \
    libbz2-dev \
    zlib1g-dev \
    librocksdb-dev \
    python3.5 \
    python3-pip \
    docker.io
RUN pip3 install -U \
    'pip<10.0.0' \
    'setuptools<58.0'



# get node 1.12.4 dependencies from Ubtuntu 16 + sovrin repos
RUN \
    add-apt-repository "deb http://archive.ubuntu.com/ubuntu xenial universe" && \
    add-apt-repository "deb http://archive.ubuntu.com/ubuntu xenial main" && \
    add-apt-repository "deb http://archive.ubuntu.com/ubuntu xenial-security main" && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CE7709D068DB5E88 && \
    add-apt-repository "deb https://repo.sovrin.org/deb xenial stable" 

    RUN apt-get update -y && \
    apt-get install -y --allow-downgrades \
#    libssl1.0.0 \
#    libsodium18 \
#    libindy-crypto=0.4.5 \
#    python3-indy-crypto=0.4.5 \
    indy-node=1.12.6 \
    # node depends on plenum
    indy-plenum=1.12.6 \
    #plenum dependencies
    python3-ujson=1.33-1build1 \
    python3-prompt-toolkit=0.57-1 \
    python3-pygments=2.2.0 \
    python3-rlp=0.5.1 \
    python3-sha3=0.2.1 \
    python3-leveldb=0~svn68-2build4 \
    python3-sortedcontainers=1.5.7 \
    python3-pip=9.0.1-2 \
    python3-portalocker=0.5.7 \
    python3-libnacl=1.6.1 \
    python3-six=1.11.0 \
    python3-intervaltree=2.1.0 \
    python3-msgpack=0.4.6-1build1 \
    python3-rocksdb=0.6.9 \
    python3-dateutil=2.6.1 \
    # meta dependencies of those python packages
    python3-setuptools=38.5.2 \
    python-pip-whl=9.0.1-2 \
    # plenum in particular depends on python 3.5
    python3=3.5.1-3 \
    python3-minimal=3.5.1-3 \
    libpython3-stdlib=3.5.1-3 \
    dh-python=2.20151103ubuntu1.2 \
    #
    && apt-get autoremove -y


# https://podman.io/getting-started/installation#installing-on-linux
# > CAUTION: The Kubic repo is NOT recommended for production use. 
#RUN echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_18.04/ /" | tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
#RUN apt-key adv --fetch-keys https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_18.04/Release.key
#RUN apt-get update -y && apt-get install -y podman

RUN mkdir /opt/controller

COPY restart_indy_node.sh /opt/controller/restart_indy_node
COPY upgrade_indy.sh /opt/controller/upgrade_indy
COPY start_node_control_tool /opt/controller/start_node_control_tool
COPY container_node_control_tool.py /opt/controller/container_node_control_tool.py
COPY init_and_run.sh ./

CMD ["./init_and_run.sh"]
