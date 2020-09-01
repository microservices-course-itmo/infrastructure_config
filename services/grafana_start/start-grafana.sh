#!/bin/bash

dockerManagerIp=${DOCKER_MANAGER_IP}

mkdir -p /etc/docker/shared/grafana

firewall-cmd --zone=trusted --add-port=3000/tcp --permanent
firewall-cmd --reload

docker service create --name grafana --network default_network --replicas 1 --mount volume-driver=vieux/sshfs,source=grafana,target=/var/lib/grafana,volume-opt=sshcmd=root@${dockerManagerIp}:/etc/docker/shared/grafana,volume-opt=allow_other,volume-opt=password=Hightower111#3 -p 3000:3000 grafana/grafana
