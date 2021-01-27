#!/bin/bash

name=$1

proxypath=$(<config/proxy_path)

container_name=code-server-${name}

# TODO remove volume

docker stop $container_name
docker rm $container_name
rm ${proxypath}/${name}.code.subfolder.conf