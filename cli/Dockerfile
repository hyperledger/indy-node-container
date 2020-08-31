FROM ubuntu:xenial


RUN apt-get update -y \
    && apt-get dist-upgrade -y \
    && apt-get autoremove -y \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CE7709D068DB5E88 \
    && apt-get install -y \
    apt-transport-https \
    ca-certificates\
    python-software-properties \
    software-properties-common \
    && add-apt-repository "deb https://repo.sovrin.org/sdk/deb xenial stable" \
    && add-apt-repository "deb https://repo.sovrin.org/deb xenial stable" \
    && apt-get update -y \
    && apt-get install -y indy-cli

RUN mkdir /home/indy
WORKDIR /home/indy

COPY init_and_run.sh ttyd ./

CMD ["./init_and_run.sh"]
