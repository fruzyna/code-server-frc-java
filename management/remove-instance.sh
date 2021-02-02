#!/bin/bash

name=$1

proxy_path=$(<config/proxy_path)
proxy_container=$(<config/proxy_container)

container_name=code-server-${name}

# TODO remove volume

docker stop $container_name
docker rm $container_name

if [ ! -z "$proxy_path" ]
then
    rm ${proxy_path}/${name}.code.subfolder.conf
    if [ ! -z "$proxy_container" ]
    then
        docker restart $proxy_container
    fi
fi