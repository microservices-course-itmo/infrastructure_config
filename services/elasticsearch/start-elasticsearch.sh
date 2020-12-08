#!/bin/bash

cd "$(dirname "$0")"

#mkdir -p /etc/docker/shared/elasticsearch/data

docker config create elasticsearch elasticsearch.yml

docker service create --name elasticsearch --network default_network --replicas 1 \
--config src=elasticsearch,target=/usr/share/elasticsearch/config/elasticsearch.yml \
--mount type=bind,source=/etc/docker/shared/elasticsearch/data,destination=/usr/share/elasticsearch/data \
--env ES_JAVA_OPTS='-Xmx256m -Xms256m' --env ELASTIC_PASSWORD=elasticP --env discovery.type=single-node docker.elastic.co/elasticsearch/elasticsearch:7.8.0


