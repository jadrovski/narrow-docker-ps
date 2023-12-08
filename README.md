# List docker containers in narrow mode
Bash script to output `docker ps` to fit small window (wrapping port mappings).

You will see:
```console
user@pc:~$ dps
CONTAINER ID  NAMES                 PORTS                   STATUS      STATE    IMAGE
6b812308b8ed  youtrack_youtrack_1   0.0.0.0:5050->8080/tcp  Up 10 days  running  jetbrains/youtrack:2022.3.64281
                                    :::5050->8080/tcp                            
              
633bc055de4f  sonarqube_postgres_1  0.0.0.0:5432->5432/tcp  Up 10 days  running  postgres:13-alpine
                                    :::5432->5432/tcp
```

instead of:
```console
CONTAINER ID   IMAGE                             COMMAND                  CREATED         STATUS       PORTS                                       NAMES
6b812308b8ed   jetbrains/youtrack:2022.3.64281   "/bin/bash /run.sh"      2 months ago    Up 10 days   0.0.0.0:5050->8080/tcp, :::5050->8080/tcp   youtrack_youtrack_1
633bc055de4f   postgres:13-alpine                "docker-entrypoint.s…"   11 months ago   Up 10 days   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   sonarqube_postgres_1
```

You can freely modify dps.sh script by your needs.

## How to install

### You and other local users
```shell
sudo mkdir -p /usr/local/bin
sudo wget -O /usr/local/bin/dps https://raw.githubusercontent.com/jadrovski/narrow-docker-ps/main/dps.sh
sudo chmod +x /usr/local/bin/dps
```

### Only you
```shell
mkdir -p ~/.local/bin
wget -O ~/.local/bin/dps https://raw.githubusercontent.com/jadrovski/narrow-docker-ps/main/dps.sh
chmod +x ~/.local/bin/dps
```
