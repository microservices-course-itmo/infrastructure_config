#!/bin/bash

dockerManagerIp=${DOCKER_MANAGER_IP}
dockerRepoHost=${DOCKER_REPO_HOST}

yum check-update
curl -fsSL https://get.docker.com/ | sh
systemctl start docker
systemctl status docker

docker swarm init --advertise-addr ${dockerManagerIp}

firewall-cmd --zone=public --add-masquerade --permanent
firewall-cmd --add-port=2376/tcp --permanent
firewall-cmd --add-port=2377/tcp --permanent
firewall-cmd --add-port=7946/tcp --permanent
firewall-cmd --add-port=7946/udp --permanent
firewall-cmd --add-port=4789/udp --permanent
firewall-cmd --reload

docker plugin install --grant-all-permissions vieux/sshfs

echo "{ \"insecure-registries\":[\"${dockerRepoHost}\"] }" > /etc/docker/daemon.json

systemctl restart docker

#Сеть для docker swarm
docker network create -d overlay default_network
#Сеть для jenkins, jfrog artifactory, docker registry
docker network create j-a-net
