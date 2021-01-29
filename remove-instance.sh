#!/bin/bash

name=$1

proxy_path=$(<config/proxy_path)
proxy_container=$(<config/proxy_container)

container_name=code-server-${name}

# TODO remove volume

docker stop $container_name
docker rm $container_name
rm ${proxy_path}/${name}.code.subfolder.conf
docker restart $proxy_container