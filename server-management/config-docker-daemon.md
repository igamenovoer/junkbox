## config docker daemon

Docker daemon configuration file is located at `/etc/docker/daemon.json`, if it doesn't exist, create it. Its specification is in [docker configuration file](https://docs.docker.com/reference/cli/dockerd/#daemon-configuration-file).

### proxy

add this to the file `/etc/docker/daemon.json`

```json
{
  "proxies": {
    "http-proxy": "http://127.0.0.1:7890",
    "https-proxy": "http://127.0.0.1:7890",
    "no-proxy": "127.0.0.1,localhost,192.168.0.0/24"
  },
}
```

then, restart docker

```bash
sudo systemctl restart docker
```

### data root

add this to the file `/etc/docker/daemon.json`

```json
{
  "data-root": "/path/to/docker/data"
}
```

then, restart docker

```bash
