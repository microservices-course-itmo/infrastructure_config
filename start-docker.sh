#!/bin/bash

yum check-update
curl -fsSL https://get.docker.com/ | sh

systemctl start docker
systemctl status docker

docker swarm init --advertise-addr ${DOCKER_MANAGER_IP}

echo "{
  \"insecure-registries\":[\"${DOCKER_REPO_HOST}\"],
  \"metrics-addr\" : \"${METRIC_ADDR}\",
  \"experimental\" : true
}" >> /etc/docker/daemon.json

systemctl restart docker

# Сеть для docker swarm
docker network create -d overlay --attachable default_network