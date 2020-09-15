#!/bin/bash

cd "$(dirname "$0")"

dockerManagerIp=${DOCKER_MANAGER_IP}

mkdir -p /etc/docker/shared/elasticsearch/data

docker config create elasticsearch elasticsearch.yml

docker service create --name elasticsearch --network default_network --replicas 1 \
--config src=elasticsearch,target=/usr/share/elasticsearch/config/elasticsearch.yml \
--mount volume-driver=vieux/sshfs,source=elasticsearch-data,target=/usr/share/elasticsearch/data,volume-opt=sshcmd=root@${dockerManagerIp}:/etc/docker/shared/elasticsearch/data,volume-opt=allow_other,volume-opt=password=${ROOT_PASSWORD} \
--env ES_JAVA_OPTS='-Xmx256m -Xms256m' --env ELASTIC_PASSWORD=elasticP --env discovery.type=single-node docker.elastic.co/elasticsearch/elasticsearch:7.8.0

