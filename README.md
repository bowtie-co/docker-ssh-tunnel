# docker-ssh-tunnel

Docker SSH Tunnel - Easy port forwarding using Dockerized SSH Tunnel!

### Example

*See included [docker-compose.yml](docker-compose.yml) for basic example*

`docker-compose.yml`

```yaml
# bowtie/ssh-tunnel - Basic Example
version: '3.5'

services:
  ssh-tunnel:
    image: bowtie/ssh-tunnel
    ports:
      - 3333:3306
    volumes:
      - ~/.ssh:/home/user/.ssh
    environment:
      ##################################
      # Required environment variables #
      ##################################
      SSH_USER: username
      SSH_HOST: ssh-bastion-host.example.com
      REMOTE_HOST: mysql-database-host.example.private
      REMOTE_PORT: 3306

      ##################################
      # Optional environment variables # (showing default values below)
      ##################################
      # SSH_KEY: id_rsa
      # SSH_PORT: 22
      # SSH_PATH: /home/user/.ssh
      # SSH_CONF: $SSH_PATH/tunnel_config
      # BIND_HOST: '0.0.0.0'
      # BIND_PORT: $REMOTE_PORT
      # VERBOSE: 'true'
      # PING_WAIT: 30
```

**Run docker-compose services**

```bash
docker-compose up
# Run in background (detached)
# docker-compose up -d
```

**Connect to remote private MySQL using local host & port**

```bash
# Match port (-P option) to exposed host port in docker-compose (3333)
mysql -h 127.0.0.1 -P 3333 -u database_user -p
```
