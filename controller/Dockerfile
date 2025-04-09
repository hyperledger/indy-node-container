FROM ubuntu:20.04

RUN apt-get update -y && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    gnupg2 \
    ## ToDo remove unused packages
    libgflags-dev \
    libsnappy-dev \
    zlib1g-dev \
    libbz2-dev \
    liblz4-dev \
    libgflags-dev \
    python3-pip \
    docker.io

# Bionic-security for libssl1.0.0
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3B4FE6ACC0B21F32 \
    && echo "deb http://security.ubuntu.com/ubuntu bionic-security main"  >> /etc/apt/sources.list

# Hyperledger Artifactory
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 9692C00E657DDE61 \
    && echo "deb https://hyperledger.jfrog.io/artifactory/indy focal stable" >> /etc/apt/sources.list \
    # For Ursa
    && echo "deb https://hyperledger.jfrog.io/artifactory/indy bionic master" >> /etc/apt/sources.list \
    # Prioritize packages from hyperledger.jfrog.io
    && printf '%s\n%s\n%s\n' 'Package: *' 'Pin: origin hyperledger.jfrog.io' 'Pin-Priority: 1001' >> /etc/apt/preferences

RUN pip3 install -U \
    # Required by setup.py
    'setuptools==50.3.2'

RUN apt-get update -y && apt-get install -y \
    indy-node="1.13.2" \
    && rm -rf /var/lib/apt/lists/* \
    # fix path to libursa
    && ln -s /usr/lib/ursa/libursa.so /usr/lib/libursa.so

RUN mkdir /opt/controller

COPY restart_indy_node.sh /opt/controller/restart_indy_node
COPY upgrade_indy.sh /opt/controller/upgrade_indy
COPY start_node_control_tool /opt/controller/start_node_control_tool
COPY container_node_control_tool.py /opt/controller/container_node_control_tool.py
COPY init_and_run.sh ./

RUN chmod +x /opt/controller/restart_indy_node \
             /opt/controller/upgrade_indy \
             /opt/controller/start_node_control_tool \
             ./init_and_run.sh

CMD ["./init_and_run.sh"]
