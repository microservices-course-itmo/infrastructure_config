#!/bin/bash

mongo_pass=$MONGO_PASSWORD

#mkdir -p /etc/docker/shared/mongo

docker service create --replicas 1 --network default_network \
--mount type=bind,source=/etc/docker/shared/mongo/db,destination=/data/db \
-e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=${mongo_pass} --name mongo -p 27017:27017 mongo
