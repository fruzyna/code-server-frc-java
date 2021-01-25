#!/bin/bash

name=$1
pass=$2
port=$3

sudo=[sudo password here]

# TODO create volume of limited size, without overwriting contents of /config

docker run -d --name code-server-${name} \
		   -e PUID=1000 -e PGID=1000 -e TZ=America/Chicago \
		   -e PASSWORD=$2 -e SUDO_PASSWORD=$sudo \
		   -p $port:8443 \
		   --cpus 0.5 -m 2.0g --memory-swap 5g \
		   --restart unless-stopped \
		   mail929/code-server-frc-java

# TODO add reverse proxy entry
