FROM ubuntu:xenial


RUN apt-get update -y && apt-get dist-upgrade -y && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CE7709D068DB5E88 && \
    apt-get install -y software-properties-common python-software-properties
    add-apt-repository "deb https://repo.sovrin.org/sdk/deb xenial stable" && \
    add-apt-repository "deb https://repo.sovrin.org/deb xenial stable" && \
    apt-get update -y && \
    apt-get install -y indy-cli


USER indy
WORKDIR /home/indy


ENTRYPOINT ["indy-cli"]
CMD ["--config", "cliconfig.json"]