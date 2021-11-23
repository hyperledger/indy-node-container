FROM ubuntu:18.04

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
    python3.6 \
    python3-pip \
    docker.io
RUN pip3 install -U \
    'pip<10.0.0' \
    'setuptools<58.0'

RUN echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_18.04/ /" | tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
RUN apt-key adv --fetch-keys https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_18.04/Release.key
RUN pip install python3-indy indy-node==1.12.4
RUN apt-get update -y && apt-get install -y podman

RUN mkdir /opt/controller

COPY restart_indy_node.sh /opt/controller/restart_indy_node
COPY upgrade_indy.sh /opt/controller/upgrade_indy
COPY start_node_control_tool /opt/controller/start_node_control_tool
COPY container_node_control_tool.py /opt/controller/container_node_control_tool.py
COPY init_and_run.sh ./

CMD ["./init_and_run.sh"]
