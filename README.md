# Docker for use Yocto Everywhere

## How to use
```bash
$ git clone https://github.com/EdoardoTorrini/yocto_mmr_docker.git
```
For the correct usage, it needs a pair of ssh key (private and public) in the current directory `./.ssh` in that way the `.gitignore` not allowed to push your private key.
```bash
$ mkdir .ssh
$ ssh-keygen
Enter file in which to save the key (/home/user/.ssh/id_ed25519): 
/home/user/yocto_mmr_docker/.ssh/
```

After that you have to create your local `docker-compose.yml`

```yaml
services:
  pc:
    build: 
      context: .
      args:
        PRIVATE_KEY: name_of_the_private_key
    ports:
      - 2227:22
    volumes:
      - /your/path/to/yocto/project:/home/mmr/yocto_project:rw
```

For the docker build use:
```bash
$ docker compose build --no-cache
$ docker compose up -d
```

After that you can connect using:
```bash
$ ssh -p 2227 mmr@localhost
$ cd yocto_project
$ git pull
The authenticity of host 'github.com (140.82.121.4)' can't be established.
ED25519 key fingerprint is SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```
This last passage needs to add to the `know_hosts` file the host: `github.com` and enabling the usage of the custom ssh key.