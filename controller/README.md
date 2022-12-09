# Indy node controller

Containerized indy node controller utilizing mounted container engine socket.

## Setup

### Container engine socket
The container engine must have an enabled user socket for the executing user to be mounted into the countainer. Please note that `XDG_RUNTIME_DIR` has to be set for this to work. Documentation on how to set it up can be found here:
* Docker: https://docs.docker.com/engine/security/rootless/#daemon
* Podman: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/building_running_and_managing_containers/assembly_using-the-container-tools-api_using-the-container-tools-cli#proc_enabling-the-podman-api-using-systemd-in-rootless-mode_assembly_using-the-container-tools-api

### Networking
By default the node will try to connect to the controller via the 127.0.0.1 loopback address. A different IP can be configured in `indy_config.py` using the setting `controlServiceHost=x.x.x.x`.
Alternatively both docker and podman allow container to share the same network via either the docker flag `--network=service:node-service-name` or the docker-compose setting `network_mode: "service:node-service-name"`. For Podman runniggng both the controller and node together in one pod is sufficient.

### Environment variables
* NODE_CONTAINER: name of the indy node container to be controlled
* CONTROLLER_CONTAINER: name of the indy node controller itself
* ENGINE: container engine to be used. Defaults to docker

### Mountpoints
Mountpoint for the respective container engine socket. This will give the Controller container the same access to the engine has the Host. It is strongly advised to run in rootless mode to not expose other container.
* Docker: `/run/user/$(id -u $USER)/docker.sock:/var/run/docker.sock`
* Podman: `/var/run/user/$(id -u $USER)/podman/podman.sock:/var/run/podman/podman.sock`
