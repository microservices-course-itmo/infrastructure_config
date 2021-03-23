#!/bin/bash

# yum install -y java-1.8.0-openjdk


# DO NOT LOOK AT THIS FILE
# WORK IN PROGRESS

# WHAT IS COMMENTED, REWRITTEN TO DOCKER-COMPOSE.yml

# chmod u+x services/*_start/start-*.sh

test -e ./.env || { echo ".env not found" ; exit 1; }

export $(xargs <.env)

mkdir -p /etc/docker/shared/registry
mkdir -p /etc/docker/shared/artifactory
mkdir -p /etc/docker/shared/zookeeper
mkdir -p /etc/docker/shared/prometheus
mkdir -p /etc/docker/shared/grafana
mkdir -p /etc/docker/shared/mongo/db
mkdir -p /etc/docker/shared/elasticsearch
mkdir -p /etc/docker/shared/jenkins/home

# chown -R 1001:1001 /etc/docker/shared/zookeeper
# chown -R 1000:1000 /etc/docker/shared/prometheus
# chown -R 472:1 /etc/docker/shared/grafana
# chown -R 1000:1000 /etc/docker/shared/elasticsearch

function compose_cfg { docker-compose -f ./$1/docker-compose.yml --env-file ./$1/.env config; }


# ./services/docker_start/start-*.sh
# ./services/gluster_start/start-*.sh

docker stack deploy -c ./services_new/registry/docker-compose.yml registry

docker stack deploy --with-registry-auth -c ./services_new/proxy/docker-compose.yml proxies

docker stack deploy --with-registry-auth -c ./services_new/artifactory/docker-compose.yml artifactory

# ./services/jenkins_start/start-*.sh

docker stack deploy --with-registry-auth -c ./services_new/kafka/docker-compose.yml kafka
docker stack deploy --with-registry-auth -c ./services_new/monitoring/docker-compose.yml monitoring

# ./services/postgres_start/start-*.sh

docker stack deploy --with-registry-auth -c ./services_new/mongo/docker-compose.yml mongo
docker stack deploy --with-registry-auth -c  <(compose_cfg elk)  elk 
