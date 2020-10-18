#!/bin/bash

dockerManagerIp=${DOCKER_MANAGER_IP}

mkdir -p /etc/docker/shared/postgres

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

chmod +x $DIR/scripts/*

cp -r "$DIR/scripts" "/etc/docker/shared/postgres"

docker service create --name postgres --network default_network --replicas 1 --mount volume-driver=vieux/sshfs,source=postgres,target=/var/lib/postgresql/data,volume-opt=sshcmd=root@${dockerManagerIp}:/etc/docker/shared/postgres,volume-opt=allow_other,volume-opt=password=${ROOT_PASSWORD} --env POSTGRES_PASSWORD=postgres postgres

ssh $(docker service ps postgres | sed -n 2p | awk '{print $4}')

docker exec -it $( docker ps -f name=postgres -q ) bash -c 'apt update; apt install cron -y'

docker exec -it $( docker ps -f name=postgres -q ) bash -c '(echo -e "0 0 * * * /var/lib/postgresql/data/scripts/create-backup.sh\n"; echo "*/5 * * * * /var/lib/postgresql/data/scripts/update-connections-amount.sh") | crontab - '

docker exec -it $( docker ps -f name=postgres -q ) bash -c 'cron'


