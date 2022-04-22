# Logging

## Log Configuration

In General it's advisiable to collect all logs via the Docker Daemon and the forward them to your Log Destination.

This gives you the most advanced benefits.

In General we support the following environment variables:

* `INDY_NODE_LOG_LEVEL` - Defaults to `0` this means most verbose level. For better non verbose set it to `1` - [Config Option](https://github.com/hyperledger/indy-node-container/blob/main/run/etc_indy/indy_config.py)
* `INDY_NODE_LOG_STDOUT` - The node prints also all Logging Information directly to `stdout` on the container. That lets your Log Collector ship easier
* `INDY_NODE_LOG_DIR` - This points to the Logging Directory in the Container mostly this doesn't need to be changed

### via Docker Daemon

You can set globaly in the Docker Daemon for all Containers in the `/etc/docker/daemon.json`. To apply the changes you need to restart the docker daemon

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m",
    "max-file": "5",
  }
}
```

### via docker-compose

```yml
version: '3.8'
services:
  indy-node:
    ...
    logging:
        driver: "json-file"
        options:
          max-file: "5"
          max-size: "100m"
```
