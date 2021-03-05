#!/bin/bash

test -e ./.env || { echo ".env not found" ; exit 1; }

export $(xargs <.env)

yum check-update
curl -fsSL https://get.docker.com/ | sh

systemctl start docker
systemctl status docker

docker swarm init --advertise-addr ${DOCKER_MANAGER_IP}
docker plugin install --grant-all-permissions vieux/sshfs

echo "{
  \"insecure-registries\":[\"${DOCKER_REPO_HOST}\"],
  \"metrics-addr\" : \"${METRIC_ADDR}\",
  \"experimental\" : true
}" >> /etc/docker/daemon.json


systemctl restart docker

# Сеть для docker swarm
docker network create -d overlay --attachable default_network