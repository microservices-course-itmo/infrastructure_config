\#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

chmod +x $DIR/scripts/*

docker build -t 0.0.0.0:25001/postgres_with_backup $DIR

docker push 0.0.0.0:25001/postgres_with_backup

docker service create --name postgres \
--network default_network --replicas 1 \
--mount type=bind,source=/etc/docker/shared/postgres,destination=/var/lib/postgresql/data \
--env POSTGRES_PASSWORD=postgres \
0.0.0.0:25001/postgres_with_backup

