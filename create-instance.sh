#!/bin/bash

name=$1
pass=$2
port=$3

proxypath=$(<config/proxy_path)
domain=$(<config/domain)
sudo=$(<config/sudo_password)

container_name=code-server-${name}

# TODO create volume of limited size, without overwriting contents of /config

# start docker container
docker run -d --name $container_name \
		   -e PUID=1000 -e PGID=1000 -e TZ=America/Chicago \
		   -e PASSWORD=$2 -e SUDO_PASSWORD=$sudo \
		   -p $port:8443 \
		   --cpus 0.5 -m 2.0g --memory-swap 5g \
		   --restart unless-stopped \
		   mail929/code-server-frc-java

# generate reverse proxy entry
config=$(<code.subfolder.conf.sample)
config="${config/DOMAIN/$domain}"
config="${config//NAME/$name}"
config="${config/CONTAINER_PORT/$port}"
tee ${proxypath}/${name}.code.subfolder.conf <<< $config

docker restart reverse-proxy