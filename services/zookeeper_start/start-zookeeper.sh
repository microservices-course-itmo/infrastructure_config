#!/bin/bash

dockerManagerIp=${DOCKER_MANAGER_IP}

mkdir -p /etc/docker/shared/zookeeper

docker service create --name zookeeper --user root \
--network default_network \
--replicas 1 \
--mount volume-driver=vieux/sshfs,source=zookeeper,target=/bitnami/zookeeper,volume-opt=sshcmd=root@${dockerManagerIp}:/etc/docker/shared/zookeeper,volume-opt=password=Hightower111#3 \
--env ALLOW_ANONYMOUS_LOGIN=yes \
bitnami/zookeeper:latest
