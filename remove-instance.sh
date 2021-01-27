#!/bin/bash

name=$1

proxypath=[/path/to/proxy-confs]

# TODO remove volume

docker stop $name
docker rm $name
rm ${proxypath}/${name}.code.subfolder.conf