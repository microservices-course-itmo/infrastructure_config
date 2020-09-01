#!/bin/bash

dockerManagerIp=${DOCKER_MANAGER_IP}

mkdir -p /etc/docker/shared/prometheus
cp prometheus.yml /etc/docker/shared/prometheus/prometheus.yml

docker service create --name prometheus --network default_network --replicas 1 --mount volume-driver=vieux/sshfs,source=prometheus,target=/etc/prometheus,volume-opt=sshcmd=root@${dockerManagerIp}:/etc/docker/shared/prometheus,volume-opt=allow_other,volume-opt=password=Hightower111#3 prom/prometheus
