#!/bin/bash

print_error() {
    >&2 echo -e "\033[1;31mError:\033[0m $1"
}

if [ -z "$CONTAINER" ]; then
    print_error "Missing node container environment variable"
    exit 22
fi

if [ "$ENGINE" == "podman" ]; then
    podman --remote container restart $CONTAINER
else
    docker container restart $CONTAINER
fi

exit 0
