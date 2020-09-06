#!/bin/bash

cd "$(dirname "$0")"

dockerManagerIp=${DOCKER_MANAGER_IP}

mkdir -p /etc/docker/shared/kibana
cp kibana.yml /etc/docker/shared/kibana.yml

docker service create --name kibana --network default_network --replicas 1 -p 5601:5601 --mount volume-driver=vieux/sshfs,source=kibana,target=/usr/share/kibana/config,volume-opt=sshcmd=root@${dockerManagerIp}:/etc/docker/shared/kibana,volume-opt=allow_other,volume-opt=password=${ROOT_PASSWORD} docker.elastic.co/kibana/kibana:7.8.0
