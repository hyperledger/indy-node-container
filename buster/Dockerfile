# This is an indy-node build container created in the indy-node docker working group of the ID Union project.
# author: Sebastian Schmittner <sebastian.schmittner@eecc.de>
# version: 0.1+2021-04-29

FROM rust:buster AS ursa_builder

ARG URSA_VERSION=bbs-v0.4.0

# dependencies
#RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y && \
#    apt-get install -y libsodium-dev librocksdb-dev libsecp256k1-dev libssl-dev openssl dpkg liblzma-dev\
#            cmake autoconf libtool curl pkg-config git



# alternative libsodium build instead of package install:
#curl -fsSL https://github.com/jedisct1/libsodium/archive/1.0.18.tar.gz | tar -xz && \
#     cd libsodium-1.0.18 && \
#     ./autogen.sh && \
#     ./configure && \
#     make && \
#     sudo make install
#export SODIUM_LIB_DIR=/usr/local/lib && export LD_LIBRARY_PATH=/usr/local/lib


# rust
#RUN curl -sSf https://sh.rustup.rs | sh -s -- -y
#ENV PATH="/root/.cargo/bin:${PATH}"


# build Ursa
RUN git clone https://github.com/hyperledger/ursa.git &&\
    cd ursa && \
    git checkout tags/$URSA_VERSION && \
    cargo build --release

# package Ursa
RUN cargo install cargo-deb
RUN cd ursa && \
    cargo deb -p ursa

RUN mv /ursa/target/debian/ursa*.deb /root/ursa.deb



FROM python:3.6-buster

ARG INDY_NODE_VERSION=v1.12.4

RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y && \
    apt-get install -y libsodium-dev libsecp256k1-dev libssl-dev openssl dpkg liblzma-dev\
            cmake autoconf libtool pkg-config curl

ARG rocksdb_lib_ver=5.13.fb

# Build and install rocksdb library
RUN mkdir rocksdb && \
    curl -o rocksdb/rocksdb.tar.gz "https://codeload.github.com/facebook/rocksdb/tar.gz/${rocksdb_lib_ver}" && \
    cd rocksdb && \
    tar xzf rocksdb.tar.gz && \
    cd ./* && \
    CXXFLAGS="-flto -Os -s" PORTABLE=1 make install-shared

#    cd $HOME && \
#    cp -a /usr/local/lib/librocksdb.so* "$HOME/.local/lib" && \
#    rm -rf rocksdb

COPY --from=ursa_builder /root/ursa.deb .
RUN dpkg -i ursa.deb

RUN apt-get install -y libsnappy-dev liblz4-dev

RUN pip install indy-node==1.12.4


COPY init_and_run.sh ./

CMD ["./init_and_run.sh"]
