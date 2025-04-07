# Indy Node Container

[![Building All Containers](https://github.com/hyperledger/indy-node-container/actions/workflows/build-all.yml/badge.svg)](https://github.com/hyperledger/indy-node-container/actions/workflows/build-all.yml)

This repository aims to provide easy-to-use containers with minimal dependencies to run instances of [Hyperledger Indy Node](https://github.com/hyperledger/indy-node). The primary goal is to support stewards joining an existing Network, but of course the containers can also be used in a stand alone (local/test/...) network. The initial contributions stem from the Container Working Group of [ID Union](https://github.com/IDunion). The repository was contributed to Hyperledger in 2022-02.

Primary artifact are the container images for

- [Indy Node](https://github.com/hyperledger/indy-node-container/pkgs/container/indy-node-container%2Findy_node)
- and the [Indy Node Controller](https://github.com/hyperledger/indy-node-container/pkgs/container/indy-node-container%2Findy_node_controller)
 which are build from the files in [the build folder](build/).

We also provide a few [utility scripts, including a docker-compose file](run/) to help setting up a run time environment for the containers.
See [here](run/) for instructions how to setup and run the indy node images from this repository.

## Images


Currently we are providing the following stable indy node images. The images are tagged like`${INDY_NODE_VERSION}-${OS}-${CONTAINER_RELEASE_VERSION}`. E.g. `1.13.2-debian11-1.2.7` is a Debian 11 based image with indy-node version `1.13.2`.

- [Debian 11 - Bullseye](https://github.com/hyperledger/indy-node-container/pkgs/container/indy-node-container%2Findy_node/320834582?tag=1.13.2-debian11-1.2)
- [Debian 12 - Bookworm](https://github.com/hyperledger/indy-node-container/pkgs/container/indy-node-container%2Findy_node/320834582?tag=1.13.2-debian12-1.2)
- [Ubuntu 20 - Focal](https://github.com/hyperledger/indy-node-container/pkgs/container/indy-node-container%2Findy_node/320834582?tag=1.13.2-ubuntu20-1.2)

See [here](run/) for instructions how to setup and run the images.

## Building

To build the node image you can use `docker` from the project root like

```bash
docker build -f "build/Dockerfile.ubuntu20" -t indy-node-container/indy_node:ubuntu20 ./build
```

or you can use `make` which provides some shortcuts

```bash
# make [bullseye|ubuntu20|all|controller] (default is ubuntu20), e.g.
make ubuntu20

# make clean removes images
# make [clean|clean_bullseye|clean_ubuntu20|clean_controller], e.g. this removes all images
make clean
```

Please note that `make` generates different tags than the Github action (see [packages](https://github.com/hyperledger/indy-node-container/pkgs/container/indy-node-container%2Findy_node) vs. [Makefile](./Makefile)).

If you have [trivy](https://aquasecurity.github.io/trivy) installed, you can use the make check_* targets to run a trivy check against the local images:

```bash
#make [check_bullseye|check_ubuntu20|check_controller], e.g.
make check_ubuntu20
```

Trivy HTML reports are created in `./trivy-reports`.

## Contributing

Any contribution is welcome, e.g. documentation, [bug reports, feature request, issues](issues/), blog posts, tutorials, feature implementations, etc. You can contribute code or documentation through the standard GitHub pull request model.

[Please have a look at CONTRIBUTING.md](CONTRIBUTING.md) for details, in particular how and why you need to sign off commits.

## Code of Conduct

Be excellent to each other!

[See CODE_OF_CONDUCT.md for details.](CODE_OF_CONDUCT.md)

## License

Copyright 2020-2022 by all parties listed in the [NOTICE](NOTICE) file

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
