#!/bin/bash

cd "$(dirname "$0")"

dockerManagerIp=${DOCKER_MANAGER_IP}

mkdir -p /etc/docker/shared/kafka

docker service create --name kafka \
--network default_network \
--replicas 1 \
--mount volume-driver=vieux/sshfs,source=kafka,target=/bitnami/kafka,volume-opt=sshcmd=root@${dockerManagerIp}:/etc/docker/shared/kafka,volume-opt=allow_other,volume-opt=password=Hightower111#3 \
--env-file environment \
bitnami/kafka:latest
