#!/bin/bash

dockerManagerIp=${DOCKER_MANAGER_IP}

mkdir -p /etc/docker/shared/zookeeper

docker service create --name zookeeper \
--network default_network \
--replicas 1 \
--mount volume-driver=vieux/sshfs,source=zookeeper,target=/bitnami/zookeeper,volume-opt=sshcmd=root@${dockerManagerIp}:/etc/docker/shared/zookeeper,volume-opt=allow_other,volume-opt=password=${ROOT_PASSWORD} \
--env ALLOW_ANONYMOUS_LOGIN=yes \
bitnami/zookeeper:latest
