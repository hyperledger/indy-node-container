[![Buster Build](https://github.com/IDunion/docker-container-wg/actions/workflows/build-buster.yml/badge.svg)](https://github.com/IDunion/docker-container-wg/actions/workflows/build-buster.yml)
[![Ubuntu 18 Build](https://github.com/IDunion/docker-container-wg/actions/workflows/build-ubuntu18.yml/badge.svg)](https://github.com/IDunion/docker-container-wg/actions/workflows/build-ubuntu18.yml)

# Indy Node Docker Container Working Group

This is the work bench of the Docker Container Working Group of the [ID Union project](https://github.com/IDunion). The primary goal of this working group is to develop an [Hyperledger Indy Node](https://github.com/hyperledger/indy-node) Docker Image with minimal dependencies.

The primary artifact are the container images at https://github.com/IDunion/docker-container-wg/packages/780050 which are build from the files in [the build folder](build/).

We also provide a few [utility scripts, including a docker-compose file](run/) to help setting up a runtime environment for the containers.
See here for instructions how to setup and run the indy node images from this repository.



## License

Copyright 2020 Sebastian Schmittner

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
