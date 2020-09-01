#!/bin/bash

password=postgres

dockerManagerIp=${DOCKER_MANAGER_IP}

mkdir -p /etc/docker/shared/postgres

docker service create --name postgres --network default_network --replicas 1 --mount volume-driver=vieux/sshfs,source=postgres,target=/var/lib/postgresql/data,volume-opt=sshcmd=root@${dockerManagerIp}:/etc/docker/shared/postgres,volume-opt=allow_other,volume-opt=password=Hightower111#3 --env POSTGRES_PASSWORD=postgres postgres
