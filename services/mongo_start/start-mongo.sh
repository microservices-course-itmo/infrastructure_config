#!/bin/bash

dockerManagerIp=${DOCKER_MANAGER_IP}

mkdir -p /etc/docker/shared/mongo

docker service create --replicas 1 --network default_network \
--mount volume-driver=vieux/sshfs,source=mongodata,target=/data,volume-opt=sshcmd=root@${dockerManagerIp}:/etc/docker/shared/mongo,volume-opt=allow_other,volume-opt=password=${ROOT_PASSWORD} \
-e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASWORD=${MONGO_PASSWORD} --name mongo -p 27017:27017 mongo
