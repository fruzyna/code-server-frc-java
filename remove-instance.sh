#!/bin/bash

name=$1

proxypath=$(<config/proxy_path)

# TODO remove volume

docker stop $name
docker rm $name
rm ${proxypath}/${name}.code.subfolder.conf