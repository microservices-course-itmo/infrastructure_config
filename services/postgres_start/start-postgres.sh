#!/bin/bash

dockerManagerIp=${DOCKER_MANAGER_IP}

mkdir -p /etc/docker/shared/postgres

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

chmod +x $DIR/scripts/*

docker build -t postgres_with_backup $DIR

docker service create --name postgres --network default_network --replicas 1 --mount volume-driver=vieux/sshfs,source=postgres,target=/var/lib/postgresql/data,volume-opt=sshcmd=root@${dockerManagerIp}:/etc/docker/shared/postgres,volume-opt=allow_other,volume-opt=password=${ROOT_PASSWORD} --env POSTGRES_PASSWORD=postgres postgres_with_backup
