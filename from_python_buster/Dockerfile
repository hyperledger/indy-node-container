# This is an indy-node build container created in the indy-node docker working group of the ID Union project.
# author: Sebastian Schmittner <sebastian.schmittner@eecc.de>
# version: 0.1+2021-04-29


FROM python:3.6

# dependencies
RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y && \
    apt-get install -y libsodium-dev librocksdb-dev libsecp256k1-dev libssl-dev openssl dpkg liblzma-dev\
            cmake autoconf libtool curl pkg-config git

# alternative libsodium build instead of package install:
#curl -fsSL https://github.com/jedisct1/libsodium/archive/1.0.18.tar.gz | tar -xz && \
#     cd libsodium-1.0.18 && \
#     ./autogen.sh && \
#     ./configure && \
#     make && \
#     sudo make install
#export SODIUM_LIB_DIR=/usr/local/lib && export LD_LIBRARY_PATH=/usr/local/lib


# rust
RUN curl -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"


# build Ursa
RUN git clone https://github.com/hyperledger/ursa.git &&\
    cd ursa && \
    cargo build --release
    
# package and install Ursa
RUN cargo install cargo-deb
RUN cd ursa && \
    cargo deb -p ursa && \
    dpkg -i /ursa/target/debian/ursa*.deb




#WORKDIR /usr/src/app
#
#COPY requirements.txt ./
#RUN pip install --no-cache-dir -r requirements.txt
#
#COPY . .
#
#CMD [ "python", "./your-daemon-or-script.py" ]

